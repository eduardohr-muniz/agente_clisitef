import 'package:agente_clisitef/src/models/cancelar_transacao_dto.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'dart:async';

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

  Future<void> extornarTransacao({required CancelarTransacaoDto cancelarTransacaoDto}) async {}

  Future<void> continueTransaction({String? data, required int continueCode, required TipoTransacao tipoTransacao}) async {
    final response = await agenteClisitefRepository.continueTransaction(
        sessionId: _currentTransaction.startTransactionResponse!.sessionId, data: data?.toString() ?? '', continueCode: continueCode);
    if (response != null) {
      _updateTransaction(response: response);
      if (tipoTransacao == TipoTransacao.venda) {
        final customComand = _customComandId(response.fieldId, response.clisitefStatus);
        if (customComand != null) {
          if (continueCode != 0) return;
          _mapFuncTransacao(continueCode, tipoTransacao)[customComand]?.call();
          return;
        } else {
          _mapFuncTransacao(continueCode, tipoTransacao)[response.commandId]?.call();
          return;
        }
      }
      if (tipoTransacao == TipoTransacao.extorno) {
        _mapFuncCancelarTransacao(tipoTransacao: tipoTransacao)[response.data ?? '']?.call();
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

  Map<String, Future<void> Function()> _mapFuncCancelarTransacao({required TipoTransacao tipoTransacao}) => {
        "1:Teste de comunicacao;2:Reimpressao de comprovante;3:Cancelamento de transacao;4:Pre-autorizacao;5:Consulta parcelas CDC;6:Consulta Private Label;7:Consulta saque e saque Fininvest;8:Consulta Saldo Debito;9:Consulta Saldo Credito;10:Outros Cielo;11:Carga forcada de tabelas no pinpad (Servidor);12:Consulta Saque Parcelado;13:Consulta Parcelas Cred. Conductor;14:Consulta Parcelas Cred. MarketPay;":
            () async {
          await continueTransaction(continueCode: 0, data: '3', tipoTransacao: tipoTransacao);
        },
        "Forneca o codigo do superviso": () async {
          continueTransaction(continueCode: 0, tipoTransacao: tipoTransacao);
        },
        "1:Cancelamento de Cartao de Debito;2:Cancelamento de Cartao de Credito;3:Cancelamento Venda Private Label;4:Cancelamento Saque Fininvest;5:Cancelamento de Pre-autorizacao;6:Cancelamento de Confirmacao de Pre-autorizacao;7:Cancelamento Garantia de Cheque Tecban;8:Cancelamento Saque GetNet;9:Cancelamento de Emissao de Pontos;10:Cancelamento Carteira Digital;":
            () async {
          await continueTransaction(continueCode: 0, data: '2', tipoTransacao: tipoTransacao);
        },
        "Digite o valor da transacao": () async {
          String valor = '100';
          await continueTransaction(continueCode: 0, data: valor, tipoTransacao: tipoTransacao);
        },
        "Data da transacao (DDMMAAAA)": () async {
          await continueTransaction(continueCode: 0, data: 'ddmmyyyy', tipoTransacao: tipoTransacao);
        },
        "Forneca o numero do documento a ser cancelado": () async {
          await continueTransaction(continueCode: 0, data: '123456', tipoTransacao: tipoTransacao);
        },
        "1:Magnetico/Chip;2:Digitado;": () async {
          await continueTransaction(continueCode: 0, data: '1', tipoTransacao: tipoTransacao);
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
}
