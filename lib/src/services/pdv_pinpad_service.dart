import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
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

  void dispose() {
    _transactionStreamController.close();
  }

  Future<void> startTransaction({required PaymentMethod paymentMethod, required double amount}) async {
    _currentTransaction = Transaction.empty();
    _updatePaymentStatus(PaymentStatus.unknow);
    _transactionStreamController.add(_currentTransaction);
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(
      paymentMethod: paymentMethod,
      amount: amount,
    );
    _updateTransaction(startTransactionResponse: startTransactionResponse);

    continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.venda);
  }

  Future<void> extornarTransacao({required Extorno extorno}) async {
    _extorno = extorno;
  }

  Future<void> continueTransaction({String? data, required int continueCode, required TipoTransacao tipoTransacao}) async {
    final response = await agenteClisitefRepository.continueTransaction(
        sessionId: _currentTransaction.startTransactionResponse!.sessionId, data: data?.toString() ?? '', continueCode: continueCode);
    if (response != null) {
      _updateTransaction(response: response);
      if (tipoTransacao == TipoTransacao.venda) {
        final map = _mapFuncTransacao(continueCode, tipoTransacao)[response.commandId];
        if (map != null) {
          map.call();
          return;
        }

        final customComand = _customComandId(response.fieldId, response.clisitefStatus);
        if (customComand != null) {
          if (continueCode != 0) return;
          final map = _mapFuncTransacao(continueCode, tipoTransacao)[customComand];
          if (map != null) {
            map.call();
            return;
          }
        }
      }
      if (tipoTransacao == TipoTransacao.extorno) {
        final func = _mapFuncCancelarContains(response.data ?? '');
        if (func != null) {
          await func().call();
          return;
        }
      }
    }
    await Future.delayed(const Duration(milliseconds: 200));
    await continueTransaction(continueCode: continueCode, tipoTransacao: tipoTransacao);
  }

  Future<void> finishTransaction() async {
    await agenteClisitefRepository.finishTransaction(
      sessionId: _currentTransaction.startTransactionResponse!.sessionId,
      taxInvoiceNumber: config.taxInvoiceNumber,
      taxInvoiceDate: config.taxInvoiceDate,
      taxInvoiceTime: config.taxInvoiceTime,
      confirm: 1,
    );
    _updatePaymentStatus(PaymentStatus.done);
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
    final key = _mapFuncCancelarTransacao(tipoTransacao: TipoTransacao.extorno, data: data)
        .keys
        .firstWhere((element) => element.contains(data), orElse: () => '');
    if (key.isNotEmpty) {
      return _mapFuncCancelarTransacao(tipoTransacao: TipoTransacao.extorno, data: data)[key]!;
    }
    return null;
  }

  Map<String, Future<void> Function()> _mapFuncCancelarTransacao({required TipoTransacao tipoTransacao, required String data}) => {
        "Cancelamento de transacao": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('cancelamento de transacao')));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: tipoTransacao);
        },
        "Forneca o codigo do superviso": () async {
          continueTransaction(continueCode: 0, tipoTransacao: tipoTransacao);
        },
        "Cancelamento de Cartao de Credito": () async {
          final options = data.split(';');
          final result = switch (_extorno!.paymentMethod) {
            FunctionId.debito => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('debito'))),
            FunctionId.credito => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('credito'))),
            FunctionId.vendaCarteiraDigital => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('carteira digital'))),
            _ => '2',
          };
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: tipoTransacao);
        },
        "Digite o valor da transacao": () async {
          String amount = _extorno!.amount.toStringAsFixed(2).replaceAll('.', '');
          await continueTransaction(continueCode: 0, data: amount, tipoTransacao: tipoTransacao);
        },
        "Data da transacao": () async {
          String date = DateFormat('ddMMyyyy').format(_extorno!.data);

          await continueTransaction(continueCode: 0, data: date, tipoTransacao: tipoTransacao);
        },
        "Forneca o numero do documento a ser cancelado": () async {
          await continueTransaction(continueCode: 0, data: _extorno!.nsuHost, tipoTransacao: tipoTransacao);
        },
        "Magnetico": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('magnetico')));

          await continueTransaction(continueCode: 0, data: result, tipoTransacao: tipoTransacao);
        }
      };

  Map<int, Future<void> Function()> _mapFuncTransacao(int continueCode, TipoTransacao tipoTransacao) => {
        21: () async {
          await continueTransaction(continueCode: continueCode, data: '1', tipoTransacao: tipoTransacao);
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

  static String _onlyNumbersRgx(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }
}
