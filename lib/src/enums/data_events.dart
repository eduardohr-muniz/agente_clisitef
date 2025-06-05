/// Enumeração para eventos de dados do CliSiTef
enum DataEvents {
  /// Evento de mensagem para o cliente
  messageCustomer,

  /// Evento de mensagem para o operador
  messageOperator,

  /// Evento de mensagem para o supervisor
  messageSupervisor,

  /// Evento de mensagem para o sistema
  messageSystem,

  /// Evento de mensagem para o banco
  messageBank,

  /// Evento de mensagem para o terminal
  messageTerminal,

  /// Evento de mensagem para o PINPAD
  messagePinpad,

  /// Evento de mensagem para o host
  messageHost,

  /// Evento de mensagem para o gateway
  messageGateway,

  /// Evento de mensagem para o proxy
  messageProxy,

  /// Evento de mensagem para o certificado
  messageCertificate,

  /// Evento de mensagem para o cartão
  messageCard,

  /// Evento de mensagem para a transação
  messageTransaction,

  /// Evento de mensagem para o estorno
  messageRefund,

  /// Evento de mensagem para o cancelamento
  messageCancel,

  /// Evento de mensagem para a finalização
  messageFinish,

  /// Evento de mensagem para o erro
  messageError,

  /// Evento de mensagem para o sucesso
  messageSuccess,

  /// Evento de mensagem para o timeout
  messageTimeout,

  /// Evento de mensagem para o desconhecido
  unknown;

  /// Converte um ID de comando para um evento
  static DataEvents fromCommandId(int commandId) {
    switch (commandId) {
      case 1:
        return DataEvents.messageCustomer;
      case 2:
        return DataEvents.messageOperator;
      case 3:
        return DataEvents.messageSupervisor;
      case 4:
        return DataEvents.messageSystem;
      case 5:
        return DataEvents.messageBank;
      case 6:
        return DataEvents.messageTerminal;
      case 7:
        return DataEvents.messagePinpad;
      case 8:
        return DataEvents.messageHost;
      case 9:
        return DataEvents.messageGateway;
      case 10:
        return DataEvents.messageProxy;
      case 11:
        return DataEvents.messageCertificate;
      case 12:
        return DataEvents.messageCard;
      case 13:
        return DataEvents.messageTransaction;
      case 14:
        return DataEvents.messageRefund;
      case 15:
        return DataEvents.messageCancel;
      case 16:
        return DataEvents.messageFinish;
      case 17:
        return DataEvents.messageError;
      case 18:
        return DataEvents.messageSuccess;
      case 19:
        return DataEvents.messageTimeout;
      default:
        return DataEvents.unknown;
    }
  }
}
