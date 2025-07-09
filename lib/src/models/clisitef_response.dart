class CliSiTefResponse {
  bool debito = false;
  bool credito = false;
  bool voucher = false;
  bool digitado = false;
  String modalidadePagamento = '';
  String modalidadePagtoExtenso = '';
  String modalidadePagtoDescrita = '';
  String dataHoraTransacao = '';
  String idCarteiraDigital = '';
  String nomeCarteiraDigital = '';
  String modalidadeCancelamento = '';
  String modalidadeCancelamentoExtenso = '';
  String modalidadeCancelamentoDescrita = '';
  String modalidadeAjuste = '';
  String autenticacao = '';
  String viaCliente = '';
  String viaEstabelecimento = '';
  String tipoComprovante = '';
  String codigoVoucher = '';
  double saque = 0.0;
  String instituicao = '';
  String codigoBandeiraPadrao = '';
  String nsuTef = '';
  String nsuHost = '';
  String codigoAutorizacao = '';
  String bin = '';
  double saldoAPagar = 0.0;
  double valorTotalRecebido = 0.0;
  double valorEntrada = 0.0;
  String dataPrimeiraParcela = '';
  double valorGorjeta = 0.0;
  double valorDevolucao = 0.0;
  double valorPagamento = 0.0;
  String valorASerCancelado = '';
  String tipoCartaoBonus = '';
  String nomeInstituicao = '';
  String codigoEstabelecimento = '';
  String codigoRedeAutorizadora = '';
  String numeroCupomOriginal = '';
  String numeroIdentificadorCupomPagamento = '';
  double saldoDisponivel = 0.0;
  double saldoBloqueado = 0.0;
  String tipoDocumentoConsultado = '';
  String numeroDocumento = '';
  double taxaServico = 0.0;
  int numeroParcelas = 0;
  String dataPreDatado = '';
  String primeiraParcela = '';
  int diasEntreParcelas = 0;
  String mesFechado = '';
  String garantia = '';
  int numeroParcelasCDC = 0;
  String numeroCartaoCreditoDigitado = '';
  String dataVencimentoCartao = '';
  String codigoSegurancaCartao = '';
  String dataTransacaoCanceladaReimpressa = '';
  String numeroDocumentoCanceladoReimpresso = '';
  String dadoPinPad = '';
  String cnpjCredenciadoraNFCE = '';
  String bandeiraNFCE = '';
  String numeroAutorizacaoNFCE = '';
  String codigoCredenciadoraSAT = '';
  String dataValidadeCartao = '';
  String nomePortadorCartao = '';
  String ultimosQuatroDigitosCartao = '';
  String nsuHostAutorizadorTransacaoCancelada = '';
  String codigoPSP = '';
  Map<int, String> codResult = {};

  CliSiTefResponse();

  CliSiTefResponse onFieldId({required int fieldId, required String buffer}) {
    if ((fieldId > 0) && (buffer.isNotEmpty)) {
      codResult[fieldId] = buffer;
    }
    switch (fieldId) {
      case 29:
        digitado = true;
        break;
      case 100:
        modalidadePagamento = buffer;
        break;
      case 101:
        modalidadePagtoExtenso = buffer;
        break;
      case 102:
        modalidadePagtoDescrita = buffer;
        break;
      case 105:
        dataHoraTransacao = buffer;
        break;
      case 106:
        idCarteiraDigital = buffer;
        break;
      case 107:
        nomeCarteiraDigital = buffer;
        break;
      case 110:
        modalidadeCancelamento = buffer;
        break;
      case 111:
        modalidadeCancelamentoExtenso = buffer;
        break;
      case 112:
        modalidadeCancelamentoDescrita = buffer;
        break;
      case 120:
        autenticacao = buffer;
        break;
      case 121:
        viaCliente = buffer;
        break;
      case 122:
        viaEstabelecimento = buffer;
        break;
      case 123:
        tipoComprovante = buffer;
        break;
      case 125:
        codigoVoucher = buffer;
        break;
      case 130:
        saque = double.tryParse(buffer) ?? 0.0;
        break;
      case 131:
        instituicao = buffer;
        break;
      case 132:
        codigoBandeiraPadrao = buffer;
        break;
      case 133:
        nsuTef = buffer;
        break;
      case 134:
        nsuHost = buffer;
        break;
      case 135:
        codigoAutorizacao = buffer;
        break;
      case 136:
        bin = buffer;
        break;
      case 137:
        saldoAPagar = double.tryParse(buffer) ?? 0.0;
        break;
      case 138:
        valorTotalRecebido = double.tryParse(buffer) ?? 0.0;
        break;
      case 139:
        valorEntrada = double.tryParse(buffer) ?? 0.0;
        break;
      case 140:
        dataPrimeiraParcela = buffer;
        break;
      case 143:
        valorGorjeta = double.tryParse(buffer) ?? 0.0;
        break;
      case 144:
        valorDevolucao = double.tryParse(buffer) ?? 0.0;
        break;
      case 145:
        valorPagamento = double.tryParse(buffer) ?? 0.0;
        break;
      case 146:
        valorASerCancelado = buffer;
        break;
      case 155:
        tipoCartaoBonus = buffer;
        break;
      case 156:
        nomeInstituicao = buffer;
        break;
      case 157:
        codigoEstabelecimento = buffer;
        break;
      case 158:
        codigoRedeAutorizadora = buffer;
        break;
      case 160:
        numeroCupomOriginal = buffer;
        break;
      case 161:
        numeroIdentificadorCupomPagamento = buffer;
        break;
      case 200:
        saldoDisponivel = double.tryParse(buffer) ?? 0.0;
        break;
      case 201:
        saldoBloqueado = double.tryParse(buffer) ?? 0.0;
        break;
      case 501:
        tipoDocumentoConsultado = buffer;
        break;
      case 502:
        numeroDocumento = buffer;
        break;
      case 504:
        taxaServico = double.tryParse(buffer) ?? 0.0;
        break;
      case 505:
        numeroParcelas = int.tryParse(buffer) ?? 0;
        break;
      case 506:
        dataPreDatado = buffer;
        break;
      case 507:
        primeiraParcela = buffer;
        break;
      case 508:
        diasEntreParcelas = int.tryParse(buffer) ?? 0;
        break;
      case 509:
        mesFechado = buffer;
        break;
      case 510:
        garantia = buffer;
        break;
      case 511:
        numeroParcelasCDC = int.tryParse(buffer) ?? 0;
        break;
      case 512:
        numeroCartaoCreditoDigitado = buffer;
        break;
      case 513:
        dataVencimentoCartao = buffer;
        break;
      case 514:
        codigoSegurancaCartao = buffer;
        break;
      case 515:
        dataTransacaoCanceladaReimpressa = buffer;
        break;
      case 516:
        numeroDocumentoCanceladoReimpresso = buffer;
        break;
      case 670:
        dadoPinPad = buffer;
        break;
      case 950:
        cnpjCredenciadoraNFCE = buffer;
        break;
      case 951:
        bandeiraNFCE = buffer;
        break;
      case 952:
        numeroAutorizacaoNFCE = buffer;
        break;
      case 953:
        codigoCredenciadoraSAT = buffer;
        break;
      case 1002:
        dataValidadeCartao = buffer;
        break;
      case 1003:
        nomePortadorCartao = buffer;
        break;
      case 1190:
        ultimosQuatroDigitosCartao = buffer;
        break;
      case 1321:
        nsuHostAutorizadorTransacaoCancelada = buffer;
        break;
      case 4153:
        codigoPSP = buffer;
        break;
    }
    return this;
  }

  /// Mostra um resumo dos campos preenchidos
  void debugCamposPreenchidos() {
    print('[CliSiTefResponse] === CAMPOS PREENCHIDOS ===');
    print('[CliSiTefResponse] Total de campos: ${codResult.length}');

    if (codResult.isEmpty) {
      print('[CliSiTefResponse] Nenhum campo foi preenchido');
      return;
    }

    for (final entry in codResult.entries) {
      print('[CliSiTefResponse] Campo ${entry.key}: ${entry.value}');
    }

    // Mostrar campos específicos importantes
    if (nsuTef.isNotEmpty) print('[CliSiTefResponse] NSU TEF: $nsuTef');
    if (nsuHost.isNotEmpty) print('[CliSiTefResponse] NSU Host: $nsuHost');
    if (codigoAutorizacao.isNotEmpty) print('[CliSiTefResponse] Código Autorização: $codigoAutorizacao');
    if (instituicao.isNotEmpty) print('[CliSiTefResponse] Instituição: $instituicao');
    if (valorPagamento > 0) print('[CliSiTefResponse] Valor: $valorPagamento');
    if (viaCliente.isNotEmpty) print('[CliSiTefResponse] Via Cliente: $viaCliente');
    if (viaEstabelecimento.isNotEmpty) print('[CliSiTefResponse] Via Estabelecimento: $viaEstabelecimento');

    print('[CliSiTefResponse] === FIM DOS CAMPOS ===');
  }

  /// Obtém um campo específico pelo ID
  String? getField(int fieldId) {
    return codResult[fieldId];
  }

  /// Verifica se um campo existe
  bool hasField(int fieldId) {
    return codResult.containsKey(fieldId);
  }

  /// Obtém o tipo de transação baseado nos flags
  String get tipoTransacao {
    if (debito) return 'Débito';
    if (credito) return 'Crédito';
    if (voucher) return 'Voucher';
    if (digitado) return 'Digitado';
    return 'Desconhecido';
  }

  /// Verifica se a transação foi aprovada
  bool get isAprovada {
    return codigoAutorizacao.isNotEmpty && nsuTef.isNotEmpty;
  }

  /// Obtém informações resumidas da transação
  Map<String, dynamic> get resumo {
    return {
      'tipo': tipoTransacao,
      'valor': valorPagamento,
      'nsuTef': nsuTef,
      'nsuHost': nsuHost,
      'codigoAutorizacao': codigoAutorizacao,
      'instituicao': instituicao,
      'bandeira': codigoBandeiraPadrao,
      'dataHora': dataHoraTransacao,
      'aprovada': isAprovada,
    };
  }
}
