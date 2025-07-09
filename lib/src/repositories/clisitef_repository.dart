import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/models/transaction_data.dart';
import 'package:agente_clisitef/src/models/transaction_response.dart';

/// Interface do repositório CliSiTef
abstract class CliSiTefRepository {
  /// Verifica se o repositório está inicializado
  bool get isInitialized;

  /// Inicia uma transação
  Future<TransactionResponse> startTransaction(TransactionData data);

  /// Continua uma transação
  Future<TransactionResponse> continueTransaction({
    required String sessionId,
    required int command,
    String? data,
  });

  /// Finaliza uma transação
  Future<TransactionResponse> finishTransaction({
    required String sessionId,
    required bool confirm,
    String? taxInvoiceNumber,
    String? taxInvoiceDate,
    String? taxInvoiceTime,
  });

  /// Cria uma nova sessão
  Future<TransactionResponse> createSession();

  /// Obtém a sessão atual
  Future<TransactionResponse> getSession();

  /// Exclui a sessão atual
  Future<TransactionResponse> deleteSession();

  /// Obtém o estado do AgenteCliSiTef
  Future<TransactionResponse> getState();

  /// Obtém a versão do AgenteCliSiTef
  Future<TransactionResponse> getVersion();

  /// Abre o PinPad
  Future<TransactionResponse> openPinPad({required String sessionId});

  /// Fecha o PinPad
  Future<TransactionResponse> closePinPad({required String sessionId});

  /// Verifica se o PinPad está presente
  Future<TransactionResponse> isPinPadPresent({required String sessionId});

  /// Lê confirmação Sim/Não do PinPad
  Future<TransactionResponse> readPinPadYesNo({
    required String sessionId,
    required String displayMessage,
  });

  /// Define mensagem de exibição do PinPad
  Future<TransactionResponse> setPinPadDisplayMessage({
    required String sessionId,
    required String displayMessage,
  });

  /// Verifica a presença do PinPad (método auxiliar)
  Future<bool> checkPinPadPresence();

  /// Define mensagem no PinPad (método auxiliar)
  Future<int> setPinPadMessage(String message);

  /// Obtém o ID da sessão atual
  String? get currentSessionId;

  /// Libera recursos
  void dispose();
}
