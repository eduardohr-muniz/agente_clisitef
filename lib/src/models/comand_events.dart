enum CommandEvents {
  data,
  storeData, // Comando 0 - Armazenar valor
  messageCashier, // Comando 1 - Mensagem para o operador
  messageCustomer, // Comando 2 - Mensagem para o cliente
  messageCashierCustomer, // Comando 3 - Mensagem para operador e cliente
  menuTitle, // Comando 4 - Título do menu
  removeMessageCashier, // Comando 11 - Remove mensagem do operador
  removeMessageCustomer, // Comando 12 - Remove mensagem do cliente
  removeMessageCashierCustomer, // Comando 13 - Remove mensagem de operador e cliente
  clearMenuTitle, // Comando 14 - Limpar título do menu
  headerShow, // Comando 15 - Cabeçalho adicional
  removeHeader, // Comando 16 - Remove cabeçalho
  confirmation, // Comando 20 - Solicita confirmação (SIM/NÃO)
  menuOptions, // Comando 21 - Menu de opções
  pressAnyKey, // Comando 22 - Aguardar tecla do operador
  abortRequest, // Comando 23 - Interrompe coleta de dados
  getFieldInternal, // Comando 29 - Coleta campo sem intervenção
  getField, // Comando 30 - Coleta campo
  getFieldCheque, // Comando 31 - Número de cheque
  getFieldCurrency, // Comando 34 - Campo monetário
  getFieldBarCode, // Comando 35 - Coleta de código de barras
  getMaskedField, // Comando 41 - Coleta de campo mascarado
  menuOptionsIdentified, // Comando 42 - Menu identificado
  unknown; // Valor padrão para comandos não mapeados

  static Map<int, CommandEvents> comandoToDataEvent = {
    -1: CommandEvents.unknown, // Informação não tratadamente
    0: CommandEvents.data, // Armazenar valor
    1: CommandEvents.messageCashier, // Mensagem para o operador
    2: CommandEvents.messageCustomer, // Mensagem para o cliente
    3: CommandEvents.messageCashierCustomer, // Mensagem para ambos
    4: CommandEvents.menuTitle, // Título do menu
    11: CommandEvents.removeMessageCashier, // Remove mensagem do operador
    12: CommandEvents.removeMessageCustomer, // Remove mensagem do cliente
    13: CommandEvents.removeMessageCashierCustomer, // Remove mensagem de ambos
    14: CommandEvents.clearMenuTitle, // Limpar título do menu
    15: CommandEvents.headerShow, // Cabeçalho adicional
    16: CommandEvents.removeHeader, // Remove cabeçalho
    20: CommandEvents.confirmation, // Solicita confirmação (SIM/NÃO)
    21: CommandEvents.menuOptions, // Menu de opções
    22: CommandEvents.pressAnyKey, // Aguardar tecla do operador
    23: CommandEvents.abortRequest, // Interrompe coleta de dados
    29: CommandEvents.getFieldInternal, // Coleta de campo sem intervenção
    30: CommandEvents.getField, // Coleta de campo
    31: CommandEvents.getFieldCheque, // Número de cheque
    34: CommandEvents.getFieldCurrency, // Campo monetário
    35: CommandEvents.getFieldBarCode, // Coleta de código de barras
    41: CommandEvents.getMaskedField, // Coleta de campo mascarado
    42: CommandEvents.menuOptionsIdentified, // Menu identificado
  };

  static CommandEvents fromCommandId(int id) {
    return comandoToDataEvent[id] ?? CommandEvents.unknown;
  }
}
