import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_exception.dart';

/// Utilitários de validação para o CliSiTef
class ValidationUtils {
  /// Valida o valor da transação
  static void validateAmount(String amount) {
    if (amount.isEmpty) return;
    if (!RegExp(r'^[\d,.]+$').hasMatch(amount)) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Valor deve conter apenas números e separador decimal',
      );
    }
    final doubleValue = double.tryParse(amount.replaceAll(',', '.'));
    if (doubleValue == null || doubleValue < 0) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Valor deve ser um número positivo válido',
      );
    }
  }

  /// Valida o operador
  static void validateOperator(String operator) {
    if (operator.isEmpty) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_MISSING_PARAMETER,
        details: 'Identificação do operador não pode estar vazia',
      );
    }
    if (operator.length > CliSiTefConstants.MAX_OPERATOR_LENGTH) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Identificação do operador excede o tamanho máximo',
      );
    }
  }

  /// Valida a data fiscal (formato AAAAMMDD)
  static void validateFiscalDate(String date) {
    if (date.isEmpty || date.length != 8 || !RegExp(r'^\d{8}$').hasMatch(date)) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Data fiscal inválida',
      );
    }
  }

  /// Valida o horário fiscal (formato HHMMSS)
  static void validateFiscalTime(String time) {
    if (time.isEmpty || time.length != 6 || !RegExp(r'^\d{6}$').hasMatch(time)) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Horário fiscal inválido',
      );
    }
  }

  /// Valida o número do cupom fiscal
  static void validateFiscalCupon(String cupon) {
    if (cupon.isEmpty) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_MISSING_PARAMETER,
        details: 'Número do cupom fiscal não pode estar vazio',
      );
    }
    if (cupon.length > CliSiTefConstants.MAX_CUPOM_LENGTH) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Número do cupom fiscal excede o tamanho máximo',
      );
    }
    if (!RegExp(r'^\d+$').hasMatch(cupon)) {
      throw CliSiTefException.fromCode(
        CliSiTefConstants.ERROR_INVALID_PARAMETER,
        details: 'Número do cupom fiscal deve conter apenas dígitos',
      );
    }
  }
}
