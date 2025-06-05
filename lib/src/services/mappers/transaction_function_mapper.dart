import 'package:agente_clisitef/src/models/refund.dart';
import 'package:agente_clisitef/src/models/payment_status.dart';
import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/enums/tipo_transacao.dart';
import 'package:intl/intl.dart';
import 'package:agente_clisitef/src/services/mappers/string_mapper.dart';
import 'package:agente_clisitef/src/exceptions/agent_clisitef_exception.dart';

/// Classe responsável por mapear funções de transação
class TransactionFunctionMapper {
  /// Mapeia funções de continuação de transação conforme o código e tipo.
  static Map<int, Future<void> Function()> mapFuncTransacao({
    required int continueCode,
    required TipoTransacao tipoTransacao,
    String? data,
    required Function(int, String?) continueTransaction,
    required Function(PaymentStatus) updatePaymentStatus,
  }) {
    return {
      21: () async {
        final result = whenPix(data);
        await continueTransaction(continueCode, result ?? '1');
      },
      -11: () async {
        updatePaymentStatus(PaymentStatus.sucess);
      }
    };
  }

  /// Mapeia funções de continuação para cancelamento/estorno.
  static Map<String, Future<void> Function()> mapFuncCancelarTransacao({
    required String data,
    required Refund refund,
    required Function(int, String?) continueTransaction,
    required Function(Exception) completeError,
    required Function() setIsFinish,
  }) {
    return {
      "cancelamento de transacao": () async {
        final options = data.split(';');
        final result = StringMapper.extractNumbers(options.firstWhere((e) => e.toLowerCase().contains('cancelamento de transacao')));
        await continueTransaction(0, result);
      },
      "forneca o codigo do superviso": () async {
        await continueTransaction(0, null);
      },
      "cancelamento de Cartao de Credito": () async {
        final options = data.split(';');
        final result = switch (refund.paymentMethod) {
          FunctionId.debito => StringMapper.extractNumbers(options.firstWhere((e) => e.toLowerCase().contains('debito'))),
          FunctionId.credito => StringMapper.extractNumbers(options.firstWhere((e) => e.toLowerCase().contains('credito'))),
          FunctionId.vendaCarteiraDigital => StringMapper.extractNumbers(options.firstWhere((e) => e.toLowerCase().contains('carteira digital'))),
          _ => '2',
        };
        await continueTransaction(0, result);
      },
      "valor da transacao": () async {
        String amount = refund.amount.toStringAsFixed(2).replaceAll('.', '');
        await continueTransaction(0, amount);
      },
      "data da transacao": () async {
        String date = DateFormat('ddMMyyyy').format(refund.date);
        await continueTransaction(0, date);
      },
      "forneca o numero do documento a ser cancelado": () async {
        final int nsuHost = int.parse(refund.nsuHost);
        await continueTransaction(0, nsuHost.toString());
      },
      "pix": () async {
        final options = data.split(';');
        final result = StringMapper.extractNumbers(options.firstWhere((e) => StringMapper.extractLetters(e.toLowerCase().trim()) == 'pix'));
        await continueTransaction(0, result);
      },
      "magnetico": () async {
        final options = data.split(';');
        final result = StringMapper.extractNumbers(options.firstWhere((e) => e.toLowerCase().contains('magnetico')));
        await continueTransaction(0, result);
      },
      "Estorno invalido": () async {
        completeError(AgentClisitefException.transactionError('Estorno inválido'));
        setIsFinish();
      },
      "ERRO": () async {
        completeError(AgentClisitefException.unexpectedError(data));
        setIsFinish();
      },
      "Transacao nao aceita": () async {
        completeError(AgentClisitefException.transactionError(data));
        setIsFinish();
      },
      "Confirma Cancelamento?": () async {
        await continueTransaction(0, '0');
      }
    };
  }

  /// Mapeia funções de finalização de fluxo, como erro inesperado ou término.
  static Map<String, void Function()> handleFinish({
    required Function() setIsFinish,
    required Function(PaymentStatus) updatePaymentStatus,
    required Function(Exception) completeError,
  }) {
    return {
      "Agente nao esta esperando continua.": () {
        setIsFinish();
        updatePaymentStatus(PaymentStatus.unknow);
        Future.delayed(const Duration(seconds: 2), () {
          completeError(AgentClisitefException.unexpectedError('Erro inesperado'));
        });
      },
      "-1": () {
        setIsFinish();
        updatePaymentStatus(PaymentStatus.unknow);
        Future.delayed(const Duration(seconds: 2), () {
          completeError(AgentClisitefException.unexpectedError('Erro inesperado'));
        });
      },
    };
  }

  /// Busca chave Pix em um dado de entrada.
  static String? whenPix(String? data) {
    if (data == null) return null;
    final datas = data.split(';');
    final key = datas.firstWhere((e) => e.toLowerCase().contains('pix'), orElse: () => '');
    if (key.isNotEmpty) {
      return StringMapper.extractNumbers(key);
    }
    return null;
  }
}
