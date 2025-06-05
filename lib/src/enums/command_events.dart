/// Enumeração para eventos de comando do CliSiTef
enum CommandEvents {
  messageCustomer,
  messageOperator,
  messageSupervisor,
  messageSystem,
  messageBank,
  messageTerminal,
  messagePinpad,
  messageHost,
  messageGateway,
  messageProxy,
  messageCertificate,
  messageCard,
  messageTransaction,
  messageRefund,
  messageCancel,
  messageFinish,
  messageError,
  messageSuccess,
  messageTimeout,
  unknown;

  static CommandEvents fromCommandId(int commandId) {
    switch (commandId) {
      case 1:
        return CommandEvents.messageCustomer;
      case 2:
        return CommandEvents.messageOperator;
      case 3:
        return CommandEvents.messageSupervisor;
      case 4:
        return CommandEvents.messageSystem;
      case 5:
        return CommandEvents.messageBank;
      case 6:
        return CommandEvents.messageTerminal;
      case 7:
        return CommandEvents.messagePinpad;
      case 8:
        return CommandEvents.messageHost;
      case 9:
        return CommandEvents.messageGateway;
      case 10:
        return CommandEvents.messageProxy;
      case 11:
        return CommandEvents.messageCertificate;
      case 12:
        return CommandEvents.messageCard;
      case 13:
        return CommandEvents.messageTransaction;
      case 14:
        return CommandEvents.messageRefund;
      case 15:
        return CommandEvents.messageCancel;
      case 16:
        return CommandEvents.messageFinish;
      case 17:
        return CommandEvents.messageError;
      case 18:
        return CommandEvents.messageSuccess;
      case 19:
        return CommandEvents.messageTimeout;
      default:
        return CommandEvents.unknown;
    }
  }
}
