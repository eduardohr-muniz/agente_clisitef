/// Classe responsável por manipulação de strings
class StringMapper {
  /// Extrai números de uma string
  static String extractNumbers(String input) {
    return _onlyNumbersRgx(input);
  }

  /// Extrai letras de uma string
  static String extractLetters(String input) {
    return _onlyLettersRgx(input);
  }

  /// Mapeia a função de transação (versão simples)
  static String mapFuncTransacaoSimple(String input) {
    return _onlyNumbersRgx(input);
  }

  /// Mapeia a função de cancelamento (versão simples)
  static String mapFuncCancelarTransacaoSimple(String input) {
    return _onlyNumbersRgx(input);
  }

  /// Extrai apenas números de uma string
  static String _onlyNumbersRgx(String text) {
    return text.replaceAll(RegExp(r'\D'), '');
  }

  /// Extrai apenas letras de uma string
  static String _onlyLettersRgx(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }
}
