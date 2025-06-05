/// Enum que representa os possíveis status de uma transação TEF.
enum PaymentStatus {
  /// Status inicial ou desconhecido.
  unknow,

  /// Transação em processamento.
  processing,

  /// Erro durante a transação.
  error,

  /// Transação concluída com sucesso.
  sucess,

  /// Transação finalizada e confirmada.
  done;
}
