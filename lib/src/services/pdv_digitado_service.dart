import 'package:flutter/cupertino.dart';

import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';
import 'package:agente_clisitef/src/models/transaction.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';

class PdvDigitadoService {
  final IAgenteClisitefRepository agenteClisitefRepository;
  final AgenteClisitefConfig config;

  PdvDigitadoService({
    required this.agenteClisitefRepository,
    required this.config,
  });
  ValueNotifier<Transaction> transaction = ValueNotifier(Transaction(cliSiTefResp: CliSiTefResp(codResult: {})));

  continueTransaction({String? data, required int continueCode}) async {
    final response = await agenteClisitefRepository.continueTransaction(
        sessionId: transaction.value.startTransactionResponse!.sessionId, data: data?.toString() ?? '', continueCode: continueCode);
    transaction.value =
        transaction.value.copyWith(cliSiTefResp: transaction.value.cliSiTefResp.onFildid(fieldId: response.fieldId, buffer: response.data ?? ''));
    if (response.clisitefStatus == 0) {
      finishTransaction();
      return;
    }
    if (response.fieldMaxLength > 0) {
      return;
    }
    continueTransaction(continueCode: continueCode);
  }

  Future startTransaction({required PaymentMethod paymentMethod, required double amount}) async {
    final startTransactionResponse = await agenteClisitefRepository.startTransaction(paymentMethod: paymentMethod, amount: amount);
    transaction.value = transaction.value.copyWith(startTransactionResponse: startTransactionResponse);
    continueTransaction(continueCode: 0);
  }

  finishTransaction() {
    agenteClisitefRepository.finishTransaction(
        sessionId: transaction.value.startTransactionResponse!.sessionId,
        taxInvoiceNumber: config.taxInvoiceNumber,
        taxInvoiceDate: config.taxInvoiceDate,
        taxInvoiceTime: config.taxInvoiceTime,
        confirm: 1);
  }
}
