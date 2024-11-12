import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/models/comand_events.dart';
import 'package:agente_clisitef/src/models/data_events.dart';
import 'package:agente_clisitef/src/models/payment_status.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';

class Transaction {
  final StartTransactionResponse? startTransactionResponse;
  final PaymentStatus paymentStatus;
  CliSiTefResp cliSiTefResp;
  final DataEvents? event;
  final String buffer;
  final CommandEvents command;
  final int fildId;
  Transaction({
    this.startTransactionResponse,
    this.paymentStatus = PaymentStatus.unknow,
    required this.cliSiTefResp,
    this.event,
    this.buffer = '',
    this.command = CommandEvents.unknown,
    this.fildId = 0,
  });
  factory Transaction.empty() {
    return Transaction(cliSiTefResp: CliSiTefResp(codResult: {}), paymentStatus: PaymentStatus.unknow);
  }

  Transaction copyWith({
    StartTransactionResponse? startTransactionResponse,
    PaymentStatus? paymentStatus,
    CliSiTefResp? cliSiTefResp,
    DataEvents? event,
    String? buffer,
    CommandEvents? command,
    int? fildId,
  }) {
    return Transaction(
      startTransactionResponse: startTransactionResponse ?? this.startTransactionResponse,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cliSiTefResp: cliSiTefResp ?? this.cliSiTefResp,
      event: event ?? this.event,
      buffer: buffer ?? this.buffer,
      command: command ?? this.command,
      fildId: fildId ?? this.fildId,
    );
  }
}
