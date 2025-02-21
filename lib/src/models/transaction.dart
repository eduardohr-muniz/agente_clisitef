import 'package:agente_clisitef/agente_clisitef.dart';
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
  final int? commandId;
  final TipoTransacao tipoTransacao;
  Transaction({
    this.startTransactionResponse,
    this.paymentStatus = PaymentStatus.unknow,
    required this.cliSiTefResp,
    required this.tipoTransacao,
    this.event,
    this.buffer = '',
    this.command = CommandEvents.unknown,
    this.fildId = 0,
    this.commandId,
  });
  factory Transaction.empty() {
    return Transaction(cliSiTefResp: CliSiTefResp(codResult: {}), paymentStatus: PaymentStatus.unknow, tipoTransacao: TipoTransacao.unknow);
  }

  Transaction copyWith({
    StartTransactionResponse? startTransactionResponse,
    PaymentStatus? paymentStatus,
    CliSiTefResp? cliSiTefResp,
    DataEvents? event,
    String? buffer,
    CommandEvents? command,
    int? fildId,
    int? commandId,
    TipoTransacao? tipoTransacao,
  }) {
    return Transaction(
      startTransactionResponse: startTransactionResponse ?? this.startTransactionResponse,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cliSiTefResp: cliSiTefResp ?? this.cliSiTefResp,
      event: event ?? this.event,
      buffer: buffer ?? this.buffer,
      command: command ?? this.command,
      fildId: fildId ?? this.fildId,
      commandId: commandId ?? this.commandId,
      tipoTransacao: tipoTransacao ?? this.tipoTransacao,
    );
  }

  @override
  String toString() {
    return 'Transaction(startTransactionResponse: $startTransactionResponse, paymentStatus: $paymentStatus, cliSiTefResp: $cliSiTefResp, event: $event, buffer: $buffer, command: $command, fildId: $fildId, commandId: $commandId)';
  }
}
