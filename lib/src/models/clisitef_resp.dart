class CliSiTefResp {
  bool debito;
  bool credito;
  bool voucher;
  bool digitado;
  String modalidadePagamento;
  String modalidadePagtoExtenso;
  String modalidadePagtoDescrita;
  String dataHoraTransacao;
  String idCarteiraDigital;
  String nomeCarteiraDigital;
  String modalidadeCancelamento;
  String modalidadeCancelamentoExtenso;
  String modalidadeCancelamentoDescrita;
  String modalidadeAjuste;
  String autenticacao;
  String viaCliente;
  String viaEstabelecimento;
  String tipoComprovante;
  String codigoVoucher;
  double saque;
  String instituicao;
  String codigoBandeiraPadrao;
  String nsuTef;
  String nsuHost;
  String codigoAutorizacao;
  String bin;
  double saldoAPagar;
  double valorTotalRecebido;
  double valorEntrada;
  String dataPrimeiraParcela;
  double valorGorjeta;
  double valorDevolucao;
  double valorPagamento;
  double valorASerCancelado;
  String tipoCartaoBonus;
  String nomeInstituicao;
  String codigoEstabelecimento;
  String codigoRedeAutorizadora;
  String numeroCupomOriginal;
  String numeroIdentificadorCupomPagamento;
  double saldoDisponivel;
  double saldoBloqueado;
  String tipoDocumentoConsultado;
  String numeroDocumento;
  double taxaServico;
  int numeroParcelas;
  String dataPreDatado;
  String primeiraParcela;
  int diasEntreParcelas;
  String mesFechado;
  String garantia;
  int numeroParcelasCDC;
  String numeroCartaoCreditoDigitado;
  String dataVencimentoCartao;
  String codigoSegurancaCartao;
  String dataTransacaoCanceladaReimpressa;
  String numeroDocumentoCanceladoReimpresso;
  String dadoPinPad;
  String cnpjCredenciadoraNFCE;
  String bandeiraNFCE;
  String numeroAutorizacaoNFCE;
  String codigoCredenciadoraSAT;
  String dataValidadeCartao;
  String nomePortadorCartao;
  String ultimosQuatroDigitosCartao;
  String nsuHostAutorizadorTransacaoCancelada;
  String codigoPSP;
  Map<int, String> codResult;

  CliSiTefResp({
    this.debito = false,
    this.credito = false,
    this.voucher = false,
    this.digitado = false,
    this.modalidadePagamento = '',
    this.modalidadePagtoExtenso = '',
    this.modalidadePagtoDescrita = '',
    this.dataHoraTransacao = '',
    this.idCarteiraDigital = '',
    this.nomeCarteiraDigital = '',
    this.modalidadeCancelamento = '',
    this.modalidadeCancelamentoExtenso = '',
    this.modalidadeCancelamentoDescrita = '',
    this.modalidadeAjuste = '',
    this.autenticacao = '',
    this.viaCliente = '',
    this.viaEstabelecimento = '',
    this.tipoComprovante = '',
    this.codigoVoucher = '',
    this.saque = 0.0,
    this.instituicao = '',
    this.codigoBandeiraPadrao = '',
    this.nsuTef = '',
    this.nsuHost = '',
    this.codigoAutorizacao = '',
    this.bin = '',
    this.saldoAPagar = 0.0,
    this.valorTotalRecebido = 0.0,
    this.valorEntrada = 0.0,
    this.dataPrimeiraParcela = '',
    this.valorGorjeta = 0.0,
    this.valorDevolucao = 0.0,
    this.valorPagamento = 0.0,
    this.valorASerCancelado = 0.0,
    this.tipoCartaoBonus = '',
    this.nomeInstituicao = '',
    this.codigoEstabelecimento = '',
    this.codigoRedeAutorizadora = '',
    this.numeroCupomOriginal = '',
    this.numeroIdentificadorCupomPagamento = '',
    this.saldoDisponivel = 0.0,
    this.saldoBloqueado = 0.0,
    this.tipoDocumentoConsultado = '',
    this.numeroDocumento = '',
    this.taxaServico = 0.0,
    this.numeroParcelas = 0,
    this.dataPreDatado = '',
    this.primeiraParcela = '',
    this.diasEntreParcelas = 0,
    this.mesFechado = '',
    this.garantia = '',
    this.numeroParcelasCDC = 0,
    this.numeroCartaoCreditoDigitado = '',
    this.dataVencimentoCartao = '',
    this.codigoSegurancaCartao = '',
    this.dataTransacaoCanceladaReimpressa = '',
    this.numeroDocumentoCanceladoReimpresso = '',
    this.dadoPinPad = '',
    this.cnpjCredenciadoraNFCE = '',
    this.bandeiraNFCE = '',
    this.numeroAutorizacaoNFCE = '',
    this.codigoCredenciadoraSAT = '',
    this.dataValidadeCartao = '',
    this.nomePortadorCartao = '',
    this.ultimosQuatroDigitosCartao = '',
    this.nsuHostAutorizadorTransacaoCancelada = '',
    this.codigoPSP = '',
    this.codResult = const {},
  });

  CliSiTefResp onFildid({required int fieldId, required String buffer}) {
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
        saque = double.parse(buffer);
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
        saldoAPagar = double.parse(buffer);
        break;
      case 138:
        valorTotalRecebido = double.parse(buffer);
        break;
      case 139:
        valorEntrada = double.parse(buffer);
        break;
      case 140:
        dataPrimeiraParcela = buffer;
        break;
      case 143:
        valorGorjeta = double.parse(buffer);
        break;
      case 144:
        valorDevolucao = double.parse(buffer);
        break;
      case 145:
        valorPagamento = double.parse(buffer);
        break;
      case 146:
        valorASerCancelado = double.parse(buffer);
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
        saldoDisponivel = double.parse(buffer);
        break;
      case 201:
        saldoBloqueado = double.parse(buffer);
        break;
      case 501:
        tipoDocumentoConsultado = buffer;
        break;
      case 502:
        numeroDocumento = buffer;
        break;
      case 504:
        taxaServico = double.tryParse(buffer) ?? 0;
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
}
