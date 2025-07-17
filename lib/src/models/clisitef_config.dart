import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:talker/talker.dart';

/// Configuração do CliSiTef para integração com AgenteCliSiTef
class CliSiTefConfig {
  /// Endereço IP do servidor SiTef (sitefIp)
  final String sitefIp;

  /// Identificação da loja (storeId)
  final String storeId;

  /// Identificação do terminal (terminalId)
  final String terminalId;

  /// Parâmetros adicionais para configuração (sessionParameters)
  final Map<String, String> sessionParameters;

  /// URL base do AgenteCliSiTef
  final String baseUrl;

  /// Timeout para requisições HTTP
  final Duration timeout;

  /// Habilitar logs detalhados
  final bool enableLogs;

  /// Certificado SSL (opcional)
  final String? sslCertificate;

  /// Operador do caixa (cashierOperator)
  final String cashierOperator;

  /// Parâmetros adicionais da transação (trnAdditionalParameters)
  final String trnAdditionalParameters;

  /// Parâmetros de inicialização da transação (trnInitParameters)
  final String trnInitParameters;

  final Talker? talker;

  const CliSiTefConfig({
    required this.sitefIp,
    required this.storeId,
    required this.terminalId,
    this.sessionParameters = const {},
    this.baseUrl = CliSiTefConstants.DEFAULT_BASE_URL,
    this.timeout = const Duration(seconds: 30),
    this.enableLogs = true,
    this.sslCertificate,
    this.cashierOperator = CliSiTefConstants.DEFAULT_OPERATOR,
    this.trnAdditionalParameters = '',
    this.trnInitParameters = '',
    this.talker,
  });

  /// Construtor com valores padrão para desenvolvimento
  factory CliSiTefConfig.development({
    String? sitefIp,
    String? storeId,
    String? terminalId,
    Map<String, String>? sessionParameters,
    String? cashierOperator,
    String? trnAdditionalParameters,
    String? trnInitParameters,
    Talker? talker,
  }) {
    return CliSiTefConfig(
      sitefIp: sitefIp ?? CliSiTefConstants.DEFAULT_SITEF_IP,
      storeId: storeId ?? CliSiTefConstants.DEFAULT_STORE_ID,
      terminalId: terminalId ?? CliSiTefConstants.DEFAULT_TERMINAL_ID,
      sessionParameters: sessionParameters ?? {},
      cashierOperator: cashierOperator ?? CliSiTefConstants.DEFAULT_OPERATOR,
      trnAdditionalParameters: trnAdditionalParameters ?? '',
      trnInitParameters: trnInitParameters ?? '',
      enableLogs: true,
      talker: talker,
    );
  }

  /// Construtor para produção
  factory CliSiTefConfig.production({
    required String sitefIp,
    required String storeId,
    required String terminalId,
    Map<String, String>? sessionParameters,
    String? baseUrl,
    Duration? timeout,
    String? sslCertificate,
    String? cashierOperator,
    String? trnAdditionalParameters,
    String? trnInitParameters,
    Talker? talker,
  }) {
    return CliSiTefConfig(
      sitefIp: sitefIp,
      storeId: storeId,
      terminalId: terminalId,
      sessionParameters: sessionParameters ?? {},
      baseUrl: baseUrl ?? CliSiTefConstants.DEFAULT_BASE_URL,
      timeout: timeout ?? const Duration(seconds: 30),
      enableLogs: false,
      sslCertificate: sslCertificate,
      cashierOperator: cashierOperator ?? CliSiTefConstants.DEFAULT_OPERATOR,
      trnAdditionalParameters: trnAdditionalParameters ?? '',
      trnInitParameters: trnInitParameters ?? '',
      talker: talker,
    );
  }

  /// Cria uma cópia com novos valores
  CliSiTefConfig copyWith({
    String? sitefIp,
    String? storeId,
    String? terminalId,
    Map<String, String>? sessionParameters,
    String? baseUrl,
    Duration? timeout,
    bool? enableLogs,
    String? sslCertificate,
    String? cashierOperator,
    String? trnAdditionalParameters,
    String? trnInitParameters,
  }) {
    return CliSiTefConfig(
      sitefIp: sitefIp ?? this.sitefIp,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      sessionParameters: sessionParameters ?? this.sessionParameters,
      baseUrl: baseUrl ?? this.baseUrl,
      timeout: timeout ?? this.timeout,
      enableLogs: enableLogs ?? this.enableLogs,
      sslCertificate: sslCertificate ?? this.sslCertificate,
      cashierOperator: cashierOperator ?? this.cashierOperator,
      trnAdditionalParameters: trnAdditionalParameters ?? this.trnAdditionalParameters,
      trnInitParameters: trnInitParameters ?? this.trnInitParameters,
    );
  }

  /// Valida a configuração
  List<String> validate() {
    final errors = <String>[];

    // Validar sitefIp
    if (sitefIp.isEmpty) {
      errors.add('sitefIp é obrigatório');
    } else if (!_isValidIpOrDomain(sitefIp)) {
      errors.add('sitefIp deve ser um endereço IP válido ou domínio');
    }

    // Validar storeId
    if (storeId.isEmpty) {
      errors.add('storeId é obrigatório');
    } else if (storeId.length != 8) {
      errors.add('storeId deve ter 8 dígitos');
    }

    // else if (!RegExp(r'^\d{8}$').hasMatch(storeId)) {
    //   errors.add('storeId deve conter apenas dígitos');
    // }

    // Validar terminalId
    if (terminalId.isEmpty) {
      errors.add('terminalId é obrigatório');
    } else if (terminalId.length != 8) {
      errors.add('terminalId deve ter 8 caracteres');
    }

    // Validar baseUrl
    if (baseUrl.isEmpty) {
      errors.add('baseUrl é obrigatório');
    } else {
      final uri = Uri.tryParse(baseUrl);
      if (uri == null || !uri.hasScheme) {
        errors.add('baseUrl deve ser uma URL válida');
      }
    }

    return errors;
  }

  /// Verifica se a configuração é válida
  bool get isValid => validate().isEmpty;

  /// Converte para Map para requisições HTTP
  Map<String, String> toMap() {
    return {
      'sitefIp': sitefIp,
      'storeId': storeId,
      'terminalId': terminalId,
      'cashierOperator': cashierOperator,
      'trnAdditionalParameters': trnAdditionalParameters,
      'trnInitParameters': trnInitParameters,
      ...sessionParameters,
    };
  }

  /// Valida se é um IP válido ou domínio
  bool _isValidIpOrDomain(String value) {
    // Aceita localhost e IPs locais
    if (value == 'localhost' || value == '127.0.0.1') return true;

    // Verifica se é um IP válido
    final parts = value.split('.');
    if (parts.length == 4) {
      for (final part in parts) {
        final num = int.tryParse(part);
        if (num == null || num < 0 || num > 255) return false;
      }
      return true;
    }

    // Verifica se é um domínio válido
    final domainRegex = RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*$');
    return domainRegex.hasMatch(value);
  }

  @override
  String toString() {
    return 'CliSiTefConfig('
        'sitefIp: $sitefIp, '
        'storeId: $storeId, '
        'terminalId: $terminalId, '
        'baseUrl: $baseUrl, '
        'timeout: $timeout, '
        'enableLogs: $enableLogs, '
        'cashierOperator: $cashierOperator, '
        'trnAdditionalParameters: $trnAdditionalParameters, '
        'trnInitParameters: $trnInitParameters'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CliSiTefConfig &&
        other.sitefIp == sitefIp &&
        other.storeId == storeId &&
        other.terminalId == terminalId &&
        other.baseUrl == baseUrl &&
        other.timeout == timeout &&
        other.enableLogs == enableLogs &&
        other.cashierOperator == cashierOperator &&
        other.trnAdditionalParameters == trnAdditionalParameters &&
        other.trnInitParameters == trnInitParameters;
  }

  @override
  int get hashCode {
    return Object.hash(
      sitefIp,
      storeId,
      terminalId,
      baseUrl,
      timeout,
      enableLogs,
      cashierOperator,
      trnAdditionalParameters,
      trnInitParameters,
    );
  }
}

/// Configuração do PinPad
class PinPadConfig {
  /// Porta do PinPad
  final String port;

  /// Mensagem padrão do PinPad
  final String defaultMessage;

  /// Habilitar confirmação do valor no PinPad
  final bool enableAmountConfirmation;

  /// Configuração de segundo PinPad
  final String? secondPinPadPort;

  const PinPadConfig({
    required this.port,
    this.defaultMessage = 'Aguarde...',
    this.enableAmountConfirmation = false,
    this.secondPinPadPort,
  });

  /// Converte para string no formato da documentação
  String toConfigString() {
    final buffer = StringBuffer();
    buffer.write('PortaPinPad=$port;');
    buffer.write('MensagemPadrao=$defaultMessage');

    if (enableAmountConfirmation) {
      buffer.write(';ConfirmaValor=1');
    }

    if (secondPinPadPort != null) {
      buffer.write(';PortaPinPad2=$secondPinPadPort');
    }

    return buffer.toString();
  }

  @override
  String toString() {
    return 'PinPadConfig('
        'port: $port, '
        'defaultMessage: $defaultMessage, '
        'enableAmountConfirmation: $enableAmountConfirmation, '
        'secondPinPadPort: $secondPinPadPort'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PinPadConfig &&
        other.port == port &&
        other.defaultMessage == defaultMessage &&
        other.enableAmountConfirmation == enableAmountConfirmation &&
        other.secondPinPadPort == secondPinPadPort;
  }

  @override
  int get hashCode {
    return Object.hash(port, defaultMessage, enableAmountConfirmation, secondPinPadPort);
  }
}

/// Configuração de rede
class NetworkConfig {
  /// Endereços IP adicionais
  final List<String> additionalIPs;

  /// Porta do servidor SiTef
  final int? serverPort;

  /// Obrigatoriedade de conexão
  final bool connectionRequired;

  /// Manter conexão ativa
  final bool keepAlive;

  /// Mostrador de comunicação
  final bool showCommunication;

  const NetworkConfig({
    this.additionalIPs = const [],
    this.serverPort,
    this.connectionRequired = true,
    this.keepAlive = false,
    this.showCommunication = false,
  });

  /// Converte para string no formato da documentação
  String toConfigString() {
    final buffer = StringBuffer();

    if (additionalIPs.isNotEmpty) {
      buffer.write('IPsAdicionais=${additionalIPs.join(',')};');
    }

    if (serverPort != null) {
      buffer.write('PortaServidor=$serverPort;');
    }

    if (connectionRequired) {
      buffer.write('ConexaoObrigatoria=1;');
    }

    if (keepAlive) {
      buffer.write('ManterConexao=1;');
    }

    if (showCommunication) {
      buffer.write('MostrarComunicacao=1');
    }

    return buffer.toString();
  }

  @override
  String toString() {
    return 'NetworkConfig('
        'additionalIPs: $additionalIPs, '
        'serverPort: $serverPort, '
        'connectionRequired: $connectionRequired, '
        'keepAlive: $keepAlive, '
        'showCommunication: $showCommunication'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NetworkConfig &&
        other.additionalIPs == additionalIPs &&
        other.serverPort == serverPort &&
        other.connectionRequired == connectionRequired &&
        other.keepAlive == keepAlive &&
        other.showCommunication == showCommunication;
  }

  @override
  int get hashCode {
    return Object.hash(additionalIPs, serverPort, connectionRequired, keepAlive, showCommunication);
  }
}

/// Configuração de trace/log
class TraceConfig {
  /// Habilitar histórico
  final bool enableHistory;

  /// Diretório de logs
  final String? logDirectory;

  /// Trace por terminal
  final bool perTerminalTrace;

  /// Trace rotativo
  final bool rotatingTrace;

  /// Tamanho máximo dos arquivos (em MB)
  final int? maxFileSize;

  /// Enviar logs para servidor
  final bool sendToServer;

  const TraceConfig({
    this.enableHistory = false,
    this.logDirectory,
    this.perTerminalTrace = false,
    this.rotatingTrace = false,
    this.maxFileSize,
    this.sendToServer = false,
  });

  /// Converte para string no formato da documentação
  String toConfigString() {
    final buffer = StringBuffer();

    if (enableHistory) {
      buffer.write('Historico=1;');
    }

    if (logDirectory != null) {
      buffer.write('DiretorioLog=$logDirectory;');
    }

    if (perTerminalTrace) {
      buffer.write('TracePorTerminal=1;');
    }

    if (rotatingTrace) {
      buffer.write('TraceRotativo=1;');
    }

    if (maxFileSize != null) {
      buffer.write('TamanhoMaximoArquivo=$maxFileSize;');
    }

    if (sendToServer) {
      buffer.write('EnviarLogServidor=1');
    }

    return buffer.toString();
  }

  @override
  String toString() {
    return 'TraceConfig('
        'enableHistory: $enableHistory, '
        'logDirectory: $logDirectory, '
        'perTerminalTrace: $perTerminalTrace, '
        'rotatingTrace: $rotatingTrace, '
        'maxFileSize: $maxFileSize, '
        'sendToServer: $sendToServer'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TraceConfig &&
        other.enableHistory == enableHistory &&
        other.logDirectory == logDirectory &&
        other.perTerminalTrace == perTerminalTrace &&
        other.rotatingTrace == rotatingTrace &&
        other.maxFileSize == maxFileSize &&
        other.sendToServer == sendToServer;
  }

  @override
  int get hashCode {
    return Object.hash(enableHistory, logDirectory, perTerminalTrace, rotatingTrace, maxFileSize, sendToServer);
  }
}

/// Configuração de segurança
class SecurityConfig {
  /// Modo seguro
  final bool secureMode;

  /// Caminho do arquivo .cha
  final String? chaFilePath;

  /// Caminho das DLLs
  final String? dllPath;

  const SecurityConfig({
    this.secureMode = false,
    this.chaFilePath,
    this.dllPath,
  });

  /// Converte para string no formato da documentação
  String toConfigString() {
    final buffer = StringBuffer();

    if (secureMode) {
      buffer.write('ModoSeguro=1;');
    }

    if (chaFilePath != null) {
      buffer.write('ArquivoCHA=$chaFilePath;');
    }

    if (dllPath != null) {
      buffer.write('CaminhoDLL=$dllPath');
    }

    return buffer.toString();
  }

  @override
  String toString() {
    return 'SecurityConfig('
        'secureMode: $secureMode, '
        'chaFilePath: $chaFilePath, '
        'dllPath: $dllPath'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SecurityConfig && other.secureMode == secureMode && other.chaFilePath == chaFilePath && other.dllPath == dllPath;
  }

  @override
  int get hashCode {
    return Object.hash(secureMode, chaFilePath, dllPath);
  }
}

/// Configuração de timeout
class TimeoutConfig {
  /// Timeout de conexão (em segundos)
  final int connectionTimeout;

  /// Timeout de resposta (em segundos)
  final int responseTimeout;

  /// Timeout de transação (em segundos)
  final int transactionTimeout;

  const TimeoutConfig({
    this.connectionTimeout = 30,
    this.responseTimeout = 60,
    this.transactionTimeout = 300,
  });

  /// Converte para string no formato da documentação
  String toConfigString() {
    return 'TimeoutConexao=$connectionTimeout;'
        'TimeoutResposta=$responseTimeout;'
        'TimeoutTransacao=$transactionTimeout';
  }

  @override
  String toString() {
    return 'TimeoutConfig('
        'connectionTimeout: $connectionTimeout, '
        'responseTimeout: $responseTimeout, '
        'transactionTimeout: $transactionTimeout'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeoutConfig &&
        other.connectionTimeout == connectionTimeout &&
        other.responseTimeout == responseTimeout &&
        other.transactionTimeout == transactionTimeout;
  }

  @override
  int get hashCode {
    return Object.hash(connectionTimeout, responseTimeout, transactionTimeout);
  }
}
