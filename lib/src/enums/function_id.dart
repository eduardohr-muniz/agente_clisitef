/// Alias para FunctionId, usado para representar métodos de pagamento.
typedef PaymentMethod = FunctionId;

/// Enum que representa os IDs de função suportados pelo TEF.
enum FunctionId {
  /// Função genérica (0).
  generico(0),

  /// Pagamento via cheque (1).
  cheque(1),

  /// Pagamento via débito (2).
  debito(2),

  /// Pagamento via crédito (3).
  credito(3),

  /// Pagamento via voucher (5).
  voucher(5),

  /// Função de teste (6).
  teste(6),

  /// Venda via carteira digital (122).
  vendaCarteiraDigital(122),

  /// Cancelamento via carteira digital (123).
  cancelamentoCarteiraDigital(123);

  /// Cria uma instância de FunctionId.
  const FunctionId(this.value);

  /// Valor numérico do ID de função.
  final int value;
}
