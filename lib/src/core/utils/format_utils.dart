import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';

/// Utilitários de formatação para o CliSiTef
class FormatUtils {
  /// Formata valor monetário para o padrão CliSiTef (com vírgula como separador decimal)
  static String formatAmount(double amount) {
    final int amountInt = (amount * 100).toInt();
    return amountInt.toString();
  }

  /// Formata valor monetário para o padrão CliSiTef (com vírgula como separador decimal)
  static String formatAmountString(String amount) {
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d,\.]'), '');
    if (cleanAmount.contains('.')) {
      final parts = cleanAmount.split('.');
      if (parts.length == 2) {
        return '${parts[0]},${parts[1].padRight(2, '0').substring(0, 2)}';
      }
    }
    if (cleanAmount.contains(',')) {
      final parts = cleanAmount.split(',');
      if (parts.length == 2) {
        return '${parts[0]},${parts[1].padRight(2, '0').substring(0, 2)}';
      }
    }
    return '$cleanAmount,00';
  }

  /// Formata data para o padrão CliSiTef (AAAAMMDD)
  static String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Formata horário para o padrão CliSiTef (HHMMSS)
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}'
        '${time.minute.toString().padLeft(2, '0')}'
        '${time.second.toString().padLeft(2, '0')}';
  }

  /// Converte string de data do padrão CliSiTef (AAAAMMDD) para DateTime
  /// Retorna null se a string não estiver no formato correto
  static DateTime? parseDate(String dateString) {
    try {
      if (dateString.length != 8) return null;

      final year = int.parse(dateString.substring(0, 4));
      final month = int.parse(dateString.substring(4, 6));
      final day = int.parse(dateString.substring(6, 8));

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  /// Converte string de horário do padrão CliSiTef (HHMMSS) para DateTime
  /// Retorna null se a string não estiver no formato correto
  static DateTime? parseTime(String timeString) {
    try {
      if (timeString.length != 6) return null;

      final hour = int.parse(timeString.substring(0, 2));
      final minute = int.parse(timeString.substring(2, 4));
      final second = int.parse(timeString.substring(4, 6));

      // Validação básica dos valores
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
        return null;
      }

      return DateTime(2000, 1, 1, hour, minute, second);
    } catch (e) {
      return null;
    }
  }

  /// Converte string de data e hora do padrão CliSiTef para DateTime
  /// Combina parseDate e parseTime em um único DateTime
  static DateTime? parseDateTime(String dateString, String timeString) {
    final date = parseDate(dateString);
    final time = parseTime(timeString);

    if (date == null || time == null) return null;

    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );
  }

  /// Formata número do cupom fiscal (máximo 20 caracteres)
  static String formatFiscalCupon(String cupon) {
    if (cupon.length > CliSiTefConstants.MAX_CUPOM_LENGTH) {
      return cupon.substring(0, CliSiTefConstants.MAX_CUPOM_LENGTH);
    }
    return cupon.padLeft(CliSiTefConstants.MAX_CUPOM_LENGTH, '0');
  }

  /// Formata identificação do operador (máximo 20 caracteres)
  static String formatOperator(String operator) {
    if (operator.length > CliSiTefConstants.MAX_OPERATOR_LENGTH) {
      return operator.substring(0, CliSiTefConstants.MAX_OPERATOR_LENGTH);
    }
    return operator;
  }

  /// Seleciona automaticamente a opção PIX de um menu baseado no texto das opções
  ///
  /// Analisa uma string de menu no formato "1:Pix;2:Pix Troco;" ou "1:Ticket;2:PIX;"
  /// e retorna o índice da opção que contém "PIX" (case insensitive)
  ///
  /// Parâmetros:
  /// - [menuData]: String com as opções no formato "1:texto;2:texto;..."
  ///
  /// Retorna:
  /// - String com o índice da opção PIX (ex: "1", "2")
  /// - "1" como fallback se não encontrar PIX
  static String selectPixOption(String menuData) {
    try {
      // Divide as opções por ponto e vírgula
      final options = menuData.split(';');

      for (final option in options) {
        if (option.trim().isEmpty) continue;

        // Separa índice do texto (formato "1:Pix")
        final colonIndex = option.indexOf(':');
        if (colonIndex > 0) {
          final index = option.substring(0, colonIndex).trim();
          final text = option.substring(colonIndex + 1).trim();

          // Verifica se o texto contém "PIX" (case insensitive)
          if (text.toUpperCase().contains('PIX')) {
            return index;
          }
        }
      }

      // Fallback: se não encontrar PIX, retorna "1"
      return '1';
    } catch (e) {
      // Em caso de erro no parsing, retorna "1" como padrão
      return '1';
    }
  }

  /// Analisa as opções de um menu e retorna uma lista estruturada
  ///
  /// Parâmetros:
  /// - [menuData]: String com as opções no formato "1:texto;2:texto;..."
  ///
  /// Retorna:
  /// - List<Map<String, String>> com 'index' e 'text' de cada opção
  static List<Map<String, String>> parseMenuOptions(String menuData) {
    final options = <Map<String, String>>[];

    try {
      final parts = menuData.split(';');

      for (final part in parts) {
        if (part.trim().isEmpty) continue;

        final colonIndex = part.indexOf(':');
        if (colonIndex > 0) {
          final index = part.substring(0, colonIndex).trim();
          final text = part.substring(colonIndex + 1).trim();

          options.add({
            'index': index,
            'text': text,
          });
        }
      }
    } catch (e) {
      // Em caso de erro, retorna lista vazia
    }

    return options;
  }
}
