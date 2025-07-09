import 'package:flutter/foundation.dart';

/// Singleton responsável por gerenciar as mensagens do operador e caixa
/// Permite atualizações em tempo real das mensagens através de ValueNotifiers
class AgenteClisitefMessageManager {
  static final AgenteClisitefMessageManager _instance = AgenteClisitefMessageManager._internal();
  factory AgenteClisitefMessageManager() => _instance;
  AgenteClisitefMessageManager._internal();

  /// Getter global para acessar a instância do MessageManager
  static AgenteClisitefMessageManager get instance => _instance;

  /// Mensagem para o caixa (operador)
  final ValueNotifier<String> messageCashier = ValueNotifier<String>('');

  /// Mensagem para o operador (PinPad/terminal)
  final ValueNotifier<String> messageOperator = ValueNotifier<String>('');

  /// Processa um comando do CliSiTef e atualiza as mensagens apropriadas
  void processCommand(int commandId, {String? message}) {
    _logCommand(commandId, message);

    switch (commandId) {
      case 1: // Mensagem para o operador (PinPad)
        messageOperator.value = message ?? '';
        break;

      case 2: // Mensagem para o cliente (visível para ambos)
        messageCashier.value = message ?? '';
        break;

      case 3: // Mensagem para ambos
        messageCashier.value = message ?? '';
        messageOperator.value = message ?? '';
        break;

      case 11: // Remove mensagem do operador
        messageOperator.value = '';
        break;

      case 12: // Remove mensagem do cliente
        messageCashier.value = '';
        break;

      case 13: // Remove mensagem de ambos
        messageCashier.value = '';
        messageOperator.value = '';
        break;

      default:
        // Comando não tratado
        break;
    }
  }

  /// Processa um cancelamento
  void processCancellation({
    required bool isOperatorCancellation,
    required bool isUserCancellation,
    required bool isAutomationCancellation,
  }) {
    if (isOperatorCancellation) {
      messageCashier.value = '❌ Operador cancelou a operação';
      messageOperator.value = 'CANCELADO';
    } else if (isUserCancellation) {
      messageCashier.value = '❌ Cliente cancelou no PinPad';
      messageOperator.value = 'CANCELADO';
    } else if (isAutomationCancellation) {
      messageCashier.value = '❌ Sistema cancelou automaticamente';
      messageOperator.value = 'CANCELADO';
    }
  }

  /// Processa sucesso da transação
  void processSuccess({String? additionalMessage}) {
    messageCashier.value = '✅ Transação realizada com sucesso! ${additionalMessage ?? ''}';
    messageOperator.value = 'APROVADO';
  }

  /// Processa erro da transação
  void processError({required String errorMessage}) {
    messageCashier.value = '❌ Erro na transação: $errorMessage';
    messageOperator.value = 'REJEITADO';
  }

  /// Limpa todas as mensagens
  void clearMessages() {
    messageCashier.value = '';
    messageOperator.value = '';
  }

  /// Log dos comandos para debug
  void _logCommand(int commandId, String? message) {
    if (kDebugMode) {
      print('[MessageManager] Comando $commandId: $message');
    }
  }

  /// Dispose dos ValueNotifiers
  void dispose() {
    messageCashier.dispose();
    messageOperator.dispose();
  }
}
