import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/repositories/responses/start_transaction_response.dart';

class Transaction {
  final StartTransactionResponse? startTransactionResponse;
  final bool done;
  final bool success;
  CliSiTefResp cliSiTefResp;
  Transaction({
    this.startTransactionResponse,
    this.done = false,
    this.success = false,
    required this.cliSiTefResp,
  });

  Transaction copyWith({
    StartTransactionResponse? startTransactionResponse,
    bool? done,
    bool? success,
    CliSiTefResp? cliSiTefResp,
  }) {
    return Transaction(
      startTransactionResponse: startTransactionResponse ?? this.startTransactionResponse,
      done: done ?? this.done,
      success: success ?? this.success,
      cliSiTefResp: cliSiTefResp ?? this.cliSiTefResp,
    );
  }
}
