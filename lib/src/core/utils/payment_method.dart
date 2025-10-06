// ignore_for_file: constant_identifier_names

enum PaymentMethod {
  CREDITO,
  DEBITO,
  PIX;

  int get code {
    switch (this) {
      case PaymentMethod.CREDITO:
        return 3;
      case PaymentMethod.DEBITO:
        return 4;
      case PaymentMethod.PIX:
        return 122;
    }
  }

  static PaymentMethod fromCode(int code) {
    return switch (code) {
      3 => PaymentMethod.CREDITO,
      4 => PaymentMethod.DEBITO,
      122 => PaymentMethod.PIX,
      _ => PaymentMethod.PIX,
    };
  }
}
