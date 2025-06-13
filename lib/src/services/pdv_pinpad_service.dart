import 'dart:developer';
import 'package:agente_clisitef/src/models/messages.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:talker/talker.dart';

class PdvPinpadService {
  final IAgenteClisitefRepository agenteClisitefRepository;
  final AgenteClisitefConfig config;

  PdvPinpadService({required this.agenteClisitefRepository, required this.config});

  Talker? get _logger => config.talker;

  final _transactionStreamController = StreamController<Transaction>.broadcast();
  final _paymentStatusStreamController = StreamController<PaymentStatus>.broadcast();
  Stream<PaymentStatus> get paymentStatusStream => _paymentStatusStreamController.stream;
  Stream<Transaction> get transactionStream => _transactionStreamController.stream;
  Transaction _currentTransaction = Transaction.empty();
  Transaction get currentTransaction => _currentTransaction;
  Estorno? _estorno;
  String? _taxInvoiceNumber;
  bool _isFinish = false;
  final ValueNotifier<Messages> messagesNotifier = ValueNotifier(Messages(message: '', comandEvent: CommandEvents.unknown));
  Completer<Transaction> _transactionCompleter = Completer<Transaction>();

  void _reset() {
    _logger?.info('🔄 Resetando transação');
    _transactionCompleter = Completer<Transaction>();
    messagesNotifier.value = Messages(message: '', comandEvent: CommandEvents.unknown);
    _currentTransaction = Transaction.empty();
    _updatePaymentStatus(PaymentStatus.unknow);
    _transactionStreamController.add(_currentTransaction);
    _estorno = null;
    _taxInvoiceNumber = null;
    _isFinish = false;
  }

  void dispose() {
    _logger?.info('🔄 Disposando transação');
    _transactionStreamController.close();
    _paymentStatusStreamController.close();
  }

  Future<void> startTransaction({required PaymentMethod paymentMethod, required double amount, required String taxInvoiceNumber}) async {
    _reset();
    _logger?.info('🔄 Iniciando transação');
    _currentTransaction = _currentTransaction.copyWith(tipoTransacao: TipoTransacao.venda);
    _taxInvoiceNumber = taxInvoiceNumber;
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(
      paymentMethod: paymentMethod,
      amount: amount,
      taxInvoiceNumber: taxInvoiceNumber,
    );
    _updateTransaction(startTransactionResponse: startTransactionResponse);

    await continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.venda);
  }

  Future<Transaction> extornarTransacao({required Estorno estorno}) async {
    _reset();
    _logger?.info('🔄 Iniciando estorno');
    _currentTransaction = _currentTransaction.copyWith(tipoTransacao: TipoTransacao.estorno);
    _estorno = estorno;
    messagesNotifier.value = Messages(message: 'Extornando venda, aguarde...', comandEvent: CommandEvents.messageCustomer);
    _taxInvoiceNumber = null;
    final session = await agenteClisitefRepository.createSession();
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(
      paymentMethod: FunctionId.generico,
      sesionId: session.sessionId,
      functionId: "110",
    );
    _updateTransaction(startTransactionResponse: startTransactionResponse);

    await continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.estorno);
    return await _transactionCompleter.future;
  }

  Future<void> continueTransaction({String? data, required int continueCode, required TipoTransacao tipoTransacao}) async {
    if (_isFinish) return;

    if (_currentTransaction.startTransactionResponse == null) {
      _logger?.info('🔄 Iniciando continueTransaction - continueCode: $continueCode, tipoTransacao: $tipoTransacao, data: $data');
      _logger?.error('startTransactionResponse está nulo');
      throw Exception('startTransactionResponse não pode ser nulo ao continuar a transação');
    }

    final response = await agenteClisitefRepository.continueTransaction(
      sessionId: _currentTransaction.startTransactionResponse!.sessionId,
      data: data?.toString() ?? '',
      continueCode: continueCode,
    );

    _updateMessage(response: response);

    _updateTransaction(response: response);

    if (continueCode == -1) {
      final func = _handleFinish('-1');
      if (func != null) {
        return func();
      }
    }

    if (response != null) {
      if (tipoTransacao == TipoTransacao.venda) {
        final map = _mapFuncTransacao(continueCode: continueCode, tipoTransacao: tipoTransacao, data: response.data)[response.commandId];
        if (map != null) {
          await map.call();
          return;
        }

        final customComand = _customComandId(response.fieldId, response.clisitefStatus);
        if (customComand != null && continueCode == 0) {
          final mappedFunction = _mapFuncTransacao(continueCode: continueCode, tipoTransacao: tipoTransacao, data: response.data)[customComand];
          if (mappedFunction != null) {
            await mappedFunction.call();
            return;
          }
        }
      }

      // 🔹 Verifique se há um cancelamento
      if (tipoTransacao == TipoTransacao.estorno) {
        if (response.fieldId == 121) {
          Future.delayed(const Duration(seconds: 3), () {
            if (_transactionCompleter.isCompleted == false) {
              _handleFinalizarEstorno(response.fieldId, response.clisitefStatus);
            }
          });
        }
        final func = _mapFuncCancelarContains(response.data ?? '');
        if (func != null) {
          await func();
          return;
        }
        _handleFinalizarEstorno(response.fieldId, response.clisitefStatus);
      }

      // 🔹 Verifique se deve finalizar
      final finishFunction = _handleFinish(response.serviceMessage ?? '');
      if (finishFunction != null) {
        finishFunction();
        return;
      }
    }

    if (response == null) {
      _logger?.info('🔄 Chamando continueTransaction novamente - sem resposta');
      _logger?.error('response está nulo');
      await Future.delayed(const Duration(milliseconds: 500));
      await continueTransaction(continueCode: continueCode, tipoTransacao: tipoTransacao);
    } else {
      _logger?.warning('⚠️ Nenhuma ação tomada para a resposta recebida');
    }
  }

  Future<void> finishTransaction() async {
    await agenteClisitefRepository.finishTransaction(
      sessionId: _currentTransaction.startTransactionResponse!.sessionId,
      taxInvoiceNumber: _taxInvoiceNumber,
      confirm: 1,
    );
    _updatePaymentStatus(PaymentStatus.done);
    _isFinish = true;
    if (_transactionCompleter.isCompleted) return;
    _transactionCompleter.complete(_currentTransaction);
  }

  void _updateMessage({ContinueTransactionResponse? response}) {
    if (response != null) {
      final command = CommandEvents.fromCommandId(response.commandId);
      if (command == CommandEvents.messageCashier) {
        messagesNotifier.value = Messages(message: response.data ?? '', comandEvent: command);
      }
      if (command == CommandEvents.messageCustomer) {
        messagesNotifier.value = Messages(message: response.data ?? '', comandEvent: command);
      }
      if (command == CommandEvents.messageCashierCustomer) {
        messagesNotifier.value = Messages(message: response.data ?? '', comandEvent: command);
      }
    }
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
    final key = _mapFuncCancelarTransacao(data: data.trim().toLowerCase(), estorno: _estorno!)
        .keys
        .firstWhere((k) => data.toLowerCase().trim().contains(k.toLowerCase().trim()), orElse: () => '');
    if (key.isNotEmpty) {
      return _mapFuncCancelarTransacao(data: data, estorno: _estorno!)[key]!;
    }
    return null;
  }

  Map<String, Future<void> Function()> _mapFuncCancelarTransacao({required String data, required Estorno estorno}) => {
        "cancelamento de transacao": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('cancelamento de transacao')));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.estorno);
        },
        "forneca o codigo do superviso": () async {
          await continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.estorno);
        },
        "cancelamento de Cartao de Credito": () async {
          final options = data.split(';');
          final result = switch (estorno.paymentMethod) {
            FunctionId.debito => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('debito'))),
            FunctionId.credito => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('credito'))),
            FunctionId.vendaCarteiraDigital => _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('carteira digital'))),
            _ => '2',
          };
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.estorno);
        },
        "valor da transacao": () async {
          log('amount: ${estorno.amount}', name: 'valor da transacao');
          String amount = estorno.amount.toStringAsFixed(2).replaceAll('.', '');
          await continueTransaction(continueCode: 0, data: amount, tipoTransacao: TipoTransacao.estorno);
        },
        "data da transacao": () async {
          String date = DateFormat('ddMMyyyy').format(estorno.data);
          await continueTransaction(continueCode: 0, data: date, tipoTransacao: TipoTransacao.estorno);
        },
        "forneca o numero do documento a ser cancelado": () async {
          final int nsuHost = int.parse(estorno.nsuHost);
          await continueTransaction(continueCode: 0, data: nsuHost.toString(), tipoTransacao: TipoTransacao.estorno);
        },
        "pix": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => _onlyLettersRgx(e.toLowerCase().trim()) == 'pix'));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.estorno);
        },
        "magnetico": () async {
          final options = data.split(';');
          final result = _onlyNumbersRgx(options.firstWhere((e) => e.toLowerCase().contains('magnetico')));
          await continueTransaction(continueCode: 0, data: result, tipoTransacao: TipoTransacao.estorno);
        },
        "Estorno invalido": () async {
          _transactionCompleter.completeError(Exception('Estorno invalido'));
          _isFinish = true;
        },
        "ERRO": () async {
          _transactionCompleter.completeError(Exception(data));
          _isFinish = true;
        },
        "Transacao nao aceita": () async {
          _transactionCompleter.completeError(Exception(data));
          _isFinish = true;
        },
        "Confirma Cancelamento?": () async {
          await continueTransaction(continueCode: 0, data: '0', tipoTransacao: TipoTransacao.estorno);
        }
      };

  void Function()? _handleFinish(String serviceMessage) {
    final map = {
      "Agente nao esta esperando continua.": () {
        _isFinish = true;
        _updatePaymentStatus(PaymentStatus.unknow);
        Future.delayed(const Duration(seconds: 2), () {
          if (_transactionCompleter.isCompleted) return;
          _transactionCompleter.completeError(Exception('Erro inesperado'));
        });
      },
      "-1": () {
        _isFinish = true;
        _updatePaymentStatus(PaymentStatus.unknow);
        Future.delayed(const Duration(seconds: 2), () {
          if (_transactionCompleter.isCompleted) return;
          _transactionCompleter.completeError(Exception('Erro inesperado'));
        });
      },
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

  _handleFinalizarEstorno(int fieldId, int clisitefStatus) {
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
