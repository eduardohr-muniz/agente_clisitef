import 'dart:developer';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:collection/collection.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class PdvPinpadService {
  final IAgenteClisitefRepository agenteClisitefRepository;
  final AgenteClisitefConfig config;

  PdvPinpadService({required this.agenteClisitefRepository, required this.config});

  final _transactionStreamController = StreamController<Transaction>.broadcast();
  final _paymentStatusStreamController = StreamController<PaymentStatus>.broadcast();
  Stream<PaymentStatus> get paymentStatusStream => _paymentStatusStreamController.stream;
  Stream<Transaction> get transactionStream => _transactionStreamController.stream;
  Transaction _currentTransaction = Transaction(cliSiTefResp: CliSiTefResp(codResult: {}));
  Transaction get currentTransaction => _currentTransaction;
  Extorno? _extorno;
  String? _taxInvoiceNumber;
  bool _isFinish = false;

  void _reset() {
    _currentTransaction = Transaction.empty();
    _updatePaymentStatus(PaymentStatus.unknow);
    _transactionStreamController.add(_currentTransaction);
    _extorno = null;
    _taxInvoiceNumber = null;
    _isFinish = false;
  }

  void dispose() {
    _transactionStreamController.close();
    _paymentStatusStreamController.close();
  }

  Future<void> startTransaction({required PaymentMethod paymentMethod, required double amount, required String taxInvoiceNumber}) async {
    _reset();
    _taxInvoiceNumber = taxInvoiceNumber;
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(
      paymentMethod: paymentMethod,
      amount: amount,
      taxInvoiceNumber: taxInvoiceNumber,
    );
    _updateTransaction(startTransactionResponse: startTransactionResponse);

    continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.venda);
  }

  Future<void> extornarTransacao({required Extorno extorno}) async {
    _reset();
    _extorno = extorno;
    _taxInvoiceNumber == null;
    final session = await agenteClisitefRepository.createSession();
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(
      paymentMethod: FunctionId.generico,
      sesionId: session.sessionId,
      functionId: "110",
    );
    _updateTransaction(startTransactionResponse: startTransactionResponse);

    continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.extorno);
  }

  Future<void> continueTransaction({String? data, required int continueCode, required TipoTransacao tipoTransacao}) async {
    if (_isFinish) return;

    log('🔄 Iniciando continueTransaction - continueCode: $continueCode, tipoTransacao: $tipoTransacao, data: $data', name: 'REQUEST');

    final response = await agenteClisitefRepository.continueTransaction(
      sessionId: _currentTransaction.startTransactionResponse!.sessionId,
      data: data?.toString() ?? '',
      continueCode: continueCode,
    );

    log('🔄 Resposta recebida - commandId: ${response?.commandId}, fieldId: ${response?.fieldId}', name: 'RESPONSE');

    await Future.delayed(const Duration(milliseconds: 500));

    if (response != null) {
      // 🔹 Verifique os mapeamentos de funções
      if (tipoTransacao == TipoTransacao.venda) {
        _updateTransaction(response: response);

        final map = _mapFuncTransacao(continueCode: continueCode, tipoTransacao: tipoTransacao, data: response.data)[response.commandId];
        if (map != null) {
          log('⏩ Executando função mapeada para commandId: ${response.commandId}', name: 'TRANSACTION');
          await map.call();
          return;
        }

        final customComand = _customComandId(response.fieldId, response.clisitefStatus);
        if (customComand != null && continueCode == 0) {
          final mappedFunction = _mapFuncTransacao(continueCode: continueCode, tipoTransacao: tipoTransacao, data: response.data)[customComand];
          if (mappedFunction != null) {
            log('⏩ Executando função personalizada para commandId: $customComand', name: 'TRANSACTION');
            await mappedFunction.call();
            return;
          }
        }
      }

      // 🔹 Verifique se há um cancelamento
      if (tipoTransacao == TipoTransacao.extorno) {
        final func = _mapFuncCancelarContains(response.data ?? '');
        if (func != null) {
          log('⏩ Executando função de cancelamento', name: 'CANCEL');
          await func();
          return;
        }
        _handleFinalizarExtorno(response.fieldId, response.clisitefStatus);
      }

      // 🔹 Verifique se deve finalizar
      final finishFunction = _handleFinish(response.serviceMessage ?? '');
      if (finishFunction != null) {
        log('✅ Finalizando transação', name: 'FINISH');
        finishFunction();
        return;
      }
    }

    // 🔄 Continue chamando recursivamente
    log('🔄 Chamando continueTransaction novamente', name: 'RECURSION');
    await continueTransaction(continueCode: continueCode, tipoTransacao: tipoTransacao);
  }

  Future<void> finishTransaction() async {
    await agenteClisitefRepository.finishTransaction(
      sessionId: _currentTransaction.startTransactionResponse!.sessionId,
      taxInvoiceNumber: _taxInvoiceNumber,
      confirm: 1,
    );
    _updatePaymentStatus(PaymentStatus.done);
    _isFinish = true;
  }

  void _updateTransaction({ContinueTransactionResponse? response, StartTransactionResponse? startTransactionResponse}) {
    if (response != null) {
      final event = DataEvents.fildIdToDataEvent[response.fieldId] ?? DataEvents.unknown;
      final command = CommandEvents.fromCommandId(response.commandId);
      _currentTransaction = _currentTransaction.copyWith(
        cliSiTefResp: _currentTransaction.cliSiTefResp.onFildid(
          fieldId: response.fieldId,
          buffer: response.data ?? '',
        ),
        event: event,
        command: command,
        buffer: response.data ?? '',
        fildId: response.fieldId,
        commandId: response.commandId,
      );
    }
    if (startTransactionResponse != null) {
      _currentTransaction = _currentTransaction.copyWith(startTransactionResponse: startTransactionResponse);
    }

    _transactionStreamController.add(_currentTransaction);
  }

  void _updatePaymentStatus(PaymentStatus status) {
    _paymentStatusStreamController.add(status);
  }

  Future<void> cancelTransaction() async => await continueTransaction(continueCode: -1, tipoTransacao: TipoTransacao.venda);

  Future<void> Function()? _mapFuncCancelarContains(String data) {
    final key = _mapFuncCancelarTransacao(data: data.trim(), extorno: _extorno!)
        .keys
        .firstWhere((k) => data.toLowerCase().trim().contains(k.toLowerCase().trim()), orElse: () => '');
    if (key.isNotEmpty) {
      return _mapFuncCancelarTransacao(data: data, extorno: _extorno!)[key]!;
    }
    return null;
  }

  Map<String, Future<void> Function()> _mapFuncCancelarTransacao({required String data, required Extorno extorno}) => {
        "cancelamento de transacao": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('cancelamento de transacao')));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.extorno);
        },
        "forneca o codigo do superviso": () async {
          await continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.extorno);
        },
        "cancelamento de Cartao de Credito": () async {
          final options = data.split(';');
          final result = switch (extorno.paymentMethod) {
            FunctionId.debito => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('debito'))),
            FunctionId.credito => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('credito'))),
            FunctionId.vendaCarteiraDigital => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('carteira digital'))),
            _ => '2',
          };
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.extorno);
        },
        "valor da transacao": () async {
          log('amount: ${extorno.amount}', name: 'valor da transacao');
          String amount = extorno.amount.toStringAsFixed(2).replaceAll('.', '');
          await continueTransaction(continueCode: 0, data: amount, tipoTransacao: TipoTransacao.extorno);
        },
        "data da transacao": () async {
          String date = DateFormat('ddMMyyyy').format(extorno.data);
          await continueTransaction(continueCode: 0, data: date, tipoTransacao: TipoTransacao.extorno);
        },
        "forneca o numero do documento a ser cancelado": () async {
          await continueTransaction(continueCode: 0, data: extorno.nsuHost, tipoTransacao: TipoTransacao.extorno);
        },
        "pix": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => _onlyLettersRgx(e.toLowerCase().trim()) == 'pix'));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.extorno);
        },
        "magnetico": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('magnetico')));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.extorno);
        }
      };

  void Function()? _handleFinish(String serviceMessage) {
    final map = {
      "Agente nao esta esperando continua.": () {
        _isFinish = true;
        _updatePaymentStatus(PaymentStatus.unknow);
      }
    };
    return map[serviceMessage];
  }

  String? whenPix(String? data) {
    if (data == null) return null;
    final datas = data.split(';');
    final key = datas.firstWhereOrNull((e) => e.toLowerCase().contains('pix'));
    if (key != null) {
      return _onlyNumbersRgx(key);
    }
    return null;
  }

  Map<int, Future<void> Function()> _mapFuncTransacao({required int continueCode, required TipoTransacao tipoTransacao, String? data}) => {
        21: () async {
          final result = whenPix(data);
          await continueTransaction(continueCode: continueCode, data: result ?? '1', tipoTransacao: tipoTransacao);
        },
        -11: () async {
          _updatePaymentStatus(PaymentStatus.sucess);
        }
      };

  int? _customComandId(int fieldId, int clisitefStatus) {
    if (fieldId == 0 && clisitefStatus == 0) {
      return -11;
    }
    return null;
  }

  _handleFinalizarExtorno(int fieldId, int clisitefStatus) {
    if (fieldId == 0 && clisitefStatus == 0) {
      _updatePaymentStatus(PaymentStatus.sucess);
      finishTransaction();
    }
  }

  static String _onlyNumbersRgx(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }

  static String _onlyLettersRgx(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }
}
