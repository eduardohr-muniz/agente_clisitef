import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/models/transaction.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';

class TransactionPDVService {
  final IAgenteClisitefRepository agenteClisitefRepository;

  TransactionPDVService({required this.agenteClisitefRepository});
  Transaction transaction = Transaction(cliSiTefResp: CliSiTefResp());

  onEvent({int? data, required int continueCode}) async {
    final response =
        await agenteClisitefRepository.continueTransaction(transaction.startTransactionResponse!.sessionId, data?.toString() ?? '', continueCode);
    transaction = transaction.copyWith(cliSiTefResp: transaction.cliSiTefResp.onFildid(fieldId: response.fieldId, buffer: response.data ?? ''));
    if (response.fieldMaxLength > 0) {
      return;
    }
    onEvent(continueCode: continueCode);
  }

  Future startTransaction(PaymentMethod paymentMethod, double amount) async {
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(paymentMethod, amount);
    transaction = transaction.copyWith(startTransactionResponse: startTransactionResponse);
    onEvent(continueCode: 0);
  } // StartTransactionResponse
}
