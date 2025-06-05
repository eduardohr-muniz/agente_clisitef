import 'package:agente_clisitef/src/models/refund.dart';
import 'package:agente_clisitef/src/models/payment_status.dart';
import 'package:agente_clisitef/src/enums/tipo_transacao.dart';
import 'package:agente_clisitef/src/services/mappers/error_mapper.dart';
import 'package:agente_clisitef/src/services/mappers/transaction_function_mapper.dart';
import 'package:agente_clisitef/src/services/mappers/string_mapper.dart';

/// Classe utilitária para mapeamento de funções de transação
class TransactionMappers {
  /// Obtém uma mensagem de erro amigável baseada na mensagem recebida
  static String getErrorMessage(String message) {
    return ErrorMapper.getErrorMessage(message);
  }

  /// Obtém uma mensagem amigável para um código de status
  static String getStatusMessage(int statusCode) {
    return ErrorMapper.getStatusMessage(statusCode);
  }

  /// Verifica se a mensagem contém um erro conhecido
  static bool hasKnownError(String message) {
    return ErrorMapper.hasKnownError(message);
  }

  /// Identifica a categoria do erro baseado na mensagem
  static String getErrorCategory(String message) {
    return ErrorMapper.getErrorCategory(message);
  }

  /// Verifica se um status indica erro
  static bool isErrorStatus(int statusCode) {
    return ErrorMapper.isErrorStatus(statusCode);
  }

  /// Obtém o tipo de erro baseado no status
  static String getErrorType(int statusCode) {
    return ErrorMapper.getErrorType(statusCode);
  }

  /// Obtém o código de erro da mensagem
  static String? getErrorCode(String message) {
    return ErrorMapper.getErrorCode(message);
  }

  /// Verifica se é um erro interno do sistema
  static bool isInternalError(String message) {
    return ErrorMapper.isInternalError(message);
  }

  /// Obtém uma mensagem de erro interno amigável
  static String getInternalErrorMessage(String message) {
    return ErrorMapper.getInternalErrorMessage(message);
  }

  /// Extrai números de uma string
  static String extractNumbers(String input) {
    return StringMapper.extractNumbers(input);
  }

  /// Extrai letras de uma string
  static String extractLetters(String input) {
    return StringMapper.extractLetters(input);
  }

  /// Mapeia a função de transação (versão simples)
  static String mapFuncTransacaoSimple(String input) {
    return StringMapper.mapFuncTransacaoSimple(input);
  }

  /// Mapeia a função de cancelamento (versão simples)
  static String mapFuncCancelarTransacaoSimple(String input) {
    return StringMapper.mapFuncCancelarTransacaoSimple(input);
  }

  /// Mapeia funções de continuação de transação conforme o código e tipo.
  static Map<int, Future<void> Function()> mapFuncTransacao({
    required int continueCode,
    required TipoTransacao tipoTransacao,
    String? data,
    required Function(int, String?) continueTransaction,
    required Function(PaymentStatus) updatePaymentStatus,
  }) {
    return TransactionFunctionMapper.mapFuncTransacao(
      continueCode: continueCode,
      tipoTransacao: tipoTransacao,
      data: data,
      continueTransaction: continueTransaction,
      updatePaymentStatus: updatePaymentStatus,
    );
  }

  /// Mapeia funções de cancelamento de transação conforme o código e tipo.
  static Map<String, Future<void> Function()> mapFuncCancelarTransacao({
    required String data,
    required Refund refund,
    required Function(int, String?) continueTransaction,
    required Function(Exception) completeError,
    required Function() setIsFinish,
  }) {
    return TransactionFunctionMapper.mapFuncCancelarTransacao(
      data: data,
      refund: refund,
      continueTransaction: continueTransaction,
      completeError: completeError,
      setIsFinish: setIsFinish,
    );
  }

  /// Mapeia funções de finalização de fluxo, como erro inesperado ou término.
  static Map<String, void Function()> handleFinish({
    required Function() setIsFinish,
    required Function(PaymentStatus) updatePaymentStatus,
    required Function(Exception) completeError,
  }) {
    return TransactionFunctionMapper.handleFinish(
      setIsFinish: setIsFinish,
      updatePaymentStatus: updatePaymentStatus,
      completeError: completeError,
    );
  }

  /// Busca chave Pix em um dado de entrada.
  static String? whenPix(String? data) {
    return TransactionFunctionMapper.whenPix(data);
  }
}
