import 'package:agente_clisitef/src/models/payment_status.dart';
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

  _updatePaymentStatus(PaymentStatus status) {
    _currentTransaction = _currentTransaction.copyWith(paymentStatus: status);
    _paymentStatusStreamController.add(status);
  }

  Future<void> continueTransaction({String? data, required int continueCode}) async {
    final response = await agenteClisitefRepository.continueTransaction(
        sessionId: _currentTransaction.startTransactionResponse!.sessionId, data: data?.toString() ?? '', continueCode: continueCode);
    if (response != null) {
      _updateTransaction(response: response);
      if (response.commandId == 21) {
        await continueTransaction(continueCode: continueCode, data: '1');
        return;
      }
      if (continueCode != 0) return;
      if (response.fieldId == 5005) {
        _updatePaymentStatus(PaymentStatus.sucess);
        _updateTransaction();
      }
      if (response.fieldMaxLength > 0) {
        return;
      }
    }

    await continueTransaction(continueCode: continueCode);
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

    continueTransaction(continueCode: 0);
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
    _updateTransaction();
  }

  void dispose() {
    _transactionStreamController.close();
  }

  Future<void> cancelTransaction() async => await continueTransaction(continueCode: -1);

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
      );
    }
    if (startTransactionResponse != null) {
      _currentTransaction = _currentTransaction.copyWith(startTransactionResponse: startTransactionResponse);
    }

    _transactionStreamController.add(_currentTransaction);
  }
}
