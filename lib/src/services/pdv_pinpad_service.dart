import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/models/transaction.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'dart:async';

class PdvPinpadService {
  final IAgenteClisitefRepository agenteClisitefRepository;
  final AgenteClisitefConfig config;

  PdvPinpadService({required this.agenteClisitefRepository, required this.config});

  final _transactionStreamController = StreamController<Transaction>.broadcast();
  Stream<Transaction> get transactionStream => _transactionStreamController.stream;
  Transaction _currentTransaction = Transaction(cliSiTefResp: CliSiTefResp(codResult: {}));

  Transaction get currentTransaction => _currentTransaction;

  Future<void> continueTransaction({String? data, required int continueCode}) async {
    final response = await agenteClisitefRepository.continueTransaction(
        sessionId: _currentTransaction.startTransactionResponse!.sessionId, data: data?.toString() ?? '', continueCode: continueCode);
    _updateTransaction(response: response);
    if (response.clisitefStatus == 0) {
      finishTransaction();
      return;
    }
    if (continueCode != 0) return;
    if (response.fieldMaxLength > 0 || response.fieldId == 102 || response.fieldId == 123) {
      return;
    }
    await continueTransaction(continueCode: continueCode);
  }

  Future<void> startTransaction({required PaymentMethod paymentMethod, required double amount}) async {
    _currentTransaction = Transaction(cliSiTefResp: CliSiTefResp(codResult: {}));
    _transactionStreamController.add(_currentTransaction);
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(
      paymentMethod: paymentMethod,
      amount: amount,
    );
    _updateTransaction(startTransactionResponse: startTransactionResponse);

    await continueTransaction(continueCode: 0);
  }

  void finishTransaction() {
    agenteClisitefRepository.finishTransaction(
      sessionId: _currentTransaction.startTransactionResponse!.sessionId,
      taxInvoiceNumber: config.taxInvoiceNumber,
      taxInvoiceDate: config.taxInvoiceDate,
      taxInvoiceTime: config.taxInvoiceTime,
      confirm: 1,
    );
  }

  void dispose() {
    _transactionStreamController.close();
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
        buufer: response.data ?? '',
        fildId: response.fieldId,
      );
    }
    if (startTransactionResponse != null) {
      _currentTransaction = _currentTransaction.copyWith(startTransactionResponse: startTransactionResponse);
    }

    _transactionStreamController.add(_currentTransaction);
  }
}
