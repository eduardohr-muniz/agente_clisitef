import 'dart:async';
import 'package:agente_clisitef/src/models/messages.dart';
import 'package:agente_clisitef/src/models/payment_status.dart';
import 'package:agente_clisitef/src/models/transaction.dart';
import 'package:agente_clisitef/src/models/refund.dart';
import 'package:flutter/foundation.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/enums/tipo_transacao.dart';
import 'package:agente_clisitef/src/models/data_events.dart';
import 'package:agente_clisitef/src/models/comand_events.dart';

/// Classe responsável por gerenciar o estado das transações
class TransactionState {
  final _transactionController = StreamController<Transaction>.broadcast();
  final _paymentStatusController = StreamController<PaymentStatus>.broadcast();
  final _transactionCompleter = Completer<Transaction>();
  final _messagesNotifier = ValueNotifier<Messages>(Messages(message: '', comandEvent: CommandEvents.messageCustomer));

  Transaction? _currentTransaction;
  Refund? _refund;
  bool _isFinish = false;
  String _taxInvoiceNumber = '';

  Stream<Transaction> get transactionStream => _transactionController.stream;
  Stream<PaymentStatus> get paymentStatusStream => _paymentStatusController.stream;
  Transaction? get currentTransaction => _currentTransaction;
  bool get isFinish => _isFinish;
  String get taxInvoiceNumber => _taxInvoiceNumber;
  ValueNotifier<Messages> get messagesNotifier => _messagesNotifier;
  Refund? get refund => _refund;

  /// Reseta o estado da transação
  void reset() {
    _currentTransaction = null;
    _refund = null;
    _isFinish = false;
    _taxInvoiceNumber = '';
    _messagesNotifier.value = Messages(message: '', comandEvent: CommandEvents.messageCustomer);
  }

  /// Atualiza a transação atual
  void updateTransaction({
    required CliSiTefResp cliSiTefResp,
    required DataEvents event,
    required CommandEvents command,
    required String buffer,
    required int fildId,
    required int commandId,
  }) {
    _currentTransaction = Transaction(
      cliSiTefResp: cliSiTefResp,
      event: event,
      command: command,
      buffer: buffer,
      fildId: fildId,
      commandId: commandId,
      tipoTransacao: TipoTransacao.venda,
    );
    _transactionController.add(_currentTransaction!);
  }

  /// Atualiza o status do pagamento
  void updatePaymentStatus(PaymentStatus status) {
    _paymentStatusController.add(status);
  }

  /// Define o estorno
  void setRefund(Refund refund) {
    _refund = refund;
  }

  /// Define o número da nota fiscal
  void setTaxInvoiceNumber(String number) {
    _taxInvoiceNumber = number;
  }

  /// Define o estado de finalização
  void setFinish(bool value) {
    _isFinish = value;
  }

  /// Completa a transação com sucesso
  void completeTransaction(Transaction transaction) {
    if (!_transactionCompleter.isCompleted) {
      _transactionCompleter.complete(transaction);
    }
  }

  /// Completa a transação com erro
  void completeError(Exception error) {
    if (!_transactionCompleter.isCompleted) {
      _transactionCompleter.completeError(error);
    }
  }

  /// Atualiza a mensagem
  void updateMessage({
    required String message,
    required String commandEvent,
  }) {
    _messagesNotifier.value = Messages(
      message: message,
      comandEvent: CommandEvents.fromCommandId(int.parse(commandEvent)),
    );
  }

  /// Libera os recursos
  void dispose() {
    _transactionController.close();
    _paymentStatusController.close();
    _messagesNotifier.dispose();
  }
}
