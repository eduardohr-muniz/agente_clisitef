import '../../core/utils/format_utils.dart';
import '../../models/clisitef_response.dart';

/// Responde as perguntas do CliSiTef numa venda de crédito parcelado loja e
/// verifica, antes de deixar a transação seguir, que ela realmente saiu parcelada.
///
/// Regra de segurança: se não for possível parcelar, a transação é abortada.
/// Nunca cai silenciosamente em à vista, porque o cliente escolheu parcelar.
class ParceladoLojaInteracao {
  ParceladoLojaInteracao(this.quantidadeParcelas);

  /// Campo do CliSiTef que pergunta o número de parcelas.
  static const int campoNumeroParcelas = 505;

  /// Subgrupo do campo 100 (modalidade, formato `ggss`) para parcelado pelo estabelecimento.
  static const String subgrupoParceladoLoja = '02';

  final int quantidadeParcelas;

  bool _parceladoLojaSelecionado = false;
  bool _numeroParcelasInformado = false;

  /// Resposta para um menu (comando 21).
  ///
  /// - Menu de forma de pagamento com "Parcelado Loja": devolve o índice dessa opção.
  /// - Menu de forma de pagamento sem essa opção: lança [ParceladoLojaIndisponivelException].
  /// - Qualquer outro menu: devolve `null` para seguir o comportamento padrão.
  String? responderMenu(String menu) {
    final opcoes = FormatUtils.parseMenuOptions(menu);
    final ehMenuFormaPagamento = opcoes.any((opcao) => _ehOpcaoFormaPagamento(_normalizar(opcao['text'] ?? '')));
    if (!ehMenuFormaPagamento) return null;

    for (final opcao in opcoes) {
      if (_ehParceladoLoja(_normalizar(opcao['text'] ?? ''))) {
        _parceladoLojaSelecionado = true;
        return opcao['index'];
      }
    }

    throw ParceladoLojaIndisponivelException(
      'Parcelado Loja não disponível no menu de forma de pagamento do CliSiTef ($menu).',
    );
  }

  /// Resposta para coleta de campo. Devolve `null` quando o campo não é do parcelamento.
  String? responderCampo(int? campo) {
    if (campo != campoNumeroParcelas) return null;
    _numeroParcelasInformado = true;
    return quantidadeParcelas.toString();
  }

  /// Motivo para desfazer a transação, ou `null` se ela saiu parcelada como pedido.
  String? motivoParaDesfazer(CliSiTefResponse campos) {
    if (!_parceladoLojaSelecionado) {
      return 'O CliSiTef não apresentou o menu de forma de pagamento para escolher Parcelado Loja.';
    }
    if (!_numeroParcelasInformado) {
      return 'O CliSiTef não perguntou o número de parcelas (campo $campoNumeroParcelas).';
    }

    final modalidade = campos.modalidadePagamento.trim();
    if (modalidade.length >= 4 && modalidade.substring(2, 4) != subgrupoParceladoLoja) {
      return 'O CliSiTef retornou a modalidade $modalidade, que não é crédito parcelado loja.';
    }
    return null;
  }

  static bool _ehOpcaoFormaPagamento(String texto) => texto.contains('VISTA') || texto.contains('PARCELAD');

  static bool _ehParceladoLoja(String texto) =>
      texto.contains('PARCELAD') && (texto.contains('LOJA') || texto.contains('ESTABELECIMENTO'));

  static String _normalizar(String texto) {
    const comAcento = 'ÀÁÂÃÄÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÇ';
    const semAcento = 'AAAAAEEEEIIIIOOOOOUUUUC';
    final maiusculo = texto.toUpperCase();
    final buffer = StringBuffer();
    for (final caractere in maiusculo.split('')) {
      final posicao = comAcento.indexOf(caractere);
      buffer.write(posicao >= 0 ? semAcento[posicao] : caractere);
    }
    return buffer.toString();
  }
}

class ParceladoLojaIndisponivelException implements Exception {
  ParceladoLojaIndisponivelException(this.message);

  final String message;

  @override
  String toString() => message;
}
