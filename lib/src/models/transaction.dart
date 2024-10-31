import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/models/comand_events.dart';
import 'package:agente_clisitef/src/models/data_events.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';

class Transaction {
  final StartTransactionResponse? startTransactionResponse;
  final bool done;
  final bool success;
  CliSiTefResp cliSiTefResp;
  final DataEvents? event;
  final String buufer;
  final CommandEvents command;
  final int fildId;
  Transaction({
    this.startTransactionResponse,
    this.done = false,
    this.success = false,
    required this.cliSiTefResp,
    this.event,
    this.buufer = '',
    this.command = CommandEvents.unknown,
    this.fildId = 0,
  });

  Transaction copyWith({
    StartTransactionResponse? startTransactionResponse,
    bool? done,
    bool? success,
    CliSiTefResp? cliSiTefResp,
    DataEvents? event,
    String? buufer,
    CommandEvents? command,
    int? fildId,
  }) {
    return Transaction(
      startTransactionResponse: startTransactionResponse ?? this.startTransactionResponse,
      done: done ?? this.done,
      success: success ?? this.success,
      cliSiTefResp: cliSiTefResp ?? this.cliSiTefResp,
      event: event ?? this.event,
      buufer: buufer ?? this.buufer,
      command: command ?? this.command,
      fildId: fildId ?? this.fildId,
    );
  }
}
