enum TransactionEvents {
  unknown,
  transactionConfirm,
  transactionFailed,
  transactionOk,
  transactionError;

  static Map<int, TransactionEvents> transactionCodeToEvent = {
    0: TransactionEvents.transactionOk, // Transação concluída com sucesso
    -1: TransactionEvents.transactionFailed, // Módulo não inicializado ou erro
    -2: TransactionEvents.transactionFailed, // Transação cancelada pelo operador
    -5: TransactionEvents.transactionError, // Sem comunicação com o SiTef
    -6: TransactionEvents.transactionFailed, // Cancelada pelo usuário no pinpad
    -20: TransactionEvents.transactionFailed, // Parâmetro inválido
    -40: TransactionEvents.transactionFailed, // Transação negada pelo servidor SiTef
    -50: TransactionEvents.transactionError, // Transação não segura
    // Outros valores podem ser adicionados conforme necessário
  };

  static TransactionEvents fromCode(int transactionCode) {
    return transactionCodeToEvent[transactionCode] ?? TransactionEvents.unknown;
  }
}
