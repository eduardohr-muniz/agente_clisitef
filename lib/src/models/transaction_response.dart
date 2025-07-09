import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';

/// Resposta de uma transação CliSiTef
class TransactionResponse {
  /// Status do serviço (serviceStatus)
  final int serviceStatus;

  /// Mensagem de erro do serviço (serviceMessage)
  final String? serviceMessage;

  /// Status do CliSiTef (clisitefStatus)
  final int clisitefStatus;

  /// ID da sessão (sessionId)
  final String? sessionId;

  /// Estado do serviço (serviceState)
  final int? serviceState;

  /// Comando a ser executado (command)
  final int? command;

  /// Tipo do campo (fieldType)
  final int? fieldType;

  /// Buffer com dados (buffer)
  final String? buffer;

  /// Mensagem a ser exibida (message)
  final String? message;

  /// Dados adicionais da resposta
  final Map<String, dynamic> additionalData;

  const TransactionResponse({
    required this.serviceStatus,
    this.serviceMessage,
    required this.clisitefStatus,
    this.sessionId,
    this.serviceState,
    this.command,
    this.fieldType,
    this.buffer,
    this.message,
    this.additionalData = const {},
  });

  /// Construtor a partir de JSON
  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      serviceStatus: json[CliSiTefConstants.RESPONSE_SERVICE_STATUS] ?? 1,
      serviceMessage: json[CliSiTefConstants.RESPONSE_SERVICE_MESSAGE],
      clisitefStatus: json[CliSiTefConstants.RESPONSE_CLISITEF_STATUS] ?? -1,
      sessionId: json[CliSiTefConstants.RESPONSE_SESSION_ID],
      serviceState: json[CliSiTefConstants.RESPONSE_SERVICE_STATE],
      command: json['command'] ?? json['commandId'], // Suporta ambos os campos
      fieldType: json['fieldType'] ?? json['fieldId'], // Suporta ambos os campos
      buffer: json['buffer'] ?? json['data'], // Suporta ambos os campos
      message: json['message'] ?? json['data'], // Suporta ambos os campos
      additionalData: Map<String, dynamic>.from(json),
    );
  }

  /// Converte para JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      CliSiTefConstants.RESPONSE_SERVICE_STATUS: serviceStatus,
      CliSiTefConstants.RESPONSE_CLISITEF_STATUS: clisitefStatus,
    };

    if (serviceMessage != null) {
      json[CliSiTefConstants.RESPONSE_SERVICE_MESSAGE] = serviceMessage;
    }

    if (sessionId != null) {
      json[CliSiTefConstants.RESPONSE_SESSION_ID] = sessionId;
    }

    if (serviceState != null) {
      json[CliSiTefConstants.RESPONSE_SERVICE_STATE] = serviceState;
    }

    if (command != null) {
      json['command'] = command;
    }

    if (fieldType != null) {
      json['fieldType'] = fieldType;
    }

    if (buffer != null) {
      json['buffer'] = buffer;
    }

    if (message != null) {
      json['message'] = message;
    }

    json.addAll(additionalData);

    return json;
  }

  /// Verifica se o serviço retornou sucesso
  bool get isServiceSuccess => serviceStatus == CliSiTefConstants.SERVICE_STATUS_OK;

  /// Verifica se a transação foi bem-sucedida
  bool get isTransactionSuccess => clisitefStatus == CliSiTefConstants.SUCCESS;

  /// Verifica se deve continuar a transação
  bool get shouldContinue => clisitefStatus == CliSiTefConstants.CONTINUE_TRANSACTION;

  /// Verifica se há erro no serviço
  bool get hasServiceError => serviceStatus == CliSiTefConstants.SERVICE_STATUS_ERROR;

  /// Verifica se há erro na transação
  bool get hasTransactionError => clisitefStatus < 0;

  /// Obtém a mensagem de erro
  String get errorMessage {
    if (hasServiceError && serviceMessage != null) {
      return serviceMessage!;
    }

    if (hasTransactionError) {
      return _getTransactionErrorMessage(clisitefStatus);
    }

    return 'Erro desconhecido';
  }

  /// Obtém a mensagem de erro da transação baseada no código
  String _getTransactionErrorMessage(int status) {
    switch (status) {
      case CliSiTefConstants.ERROR_MISSING_PARAMETER:
        return 'Parâmetro obrigatório não foi passado';
      case CliSiTefConstants.ERROR_ITERATIVE_EXECUTION:
        return 'Erro na execução da rotina iterativa';
      case CliSiTefConstants.ERROR_DOCUMENT_NOT_FOUND:
        return 'Documento fiscal não encontrado';
      case CliSiTefConstants.ERROR_OPERATION_CANCELLED:
        return 'Operação cancelada pela automação comercial';
      case CliSiTefConstants.ERROR_INVALID_PARAMETER:
        return 'Parâmetro inválido passado para a função';
      case CliSiTefConstants.ERROR_FORBIDDEN_WORD:
        return 'Utilizada uma palavra proibida';
      case CliSiTefConstants.ERROR_BANK_CORRESPONDENT:
        return 'Erro no Correspondente Bancário: Deve realizar sangria';
      case CliSiTefConstants.ERROR_FILE_ACCESS:
        return 'Erro de acesso ao arquivo';
      case CliSiTefConstants.ERROR_SITEF_DENIED:
        return 'Transação negada pelo servidor SiTef';
      case CliSiTefConstants.ERROR_INVALID_DATA:
        return 'Dados inválidos';
      case CliSiTefConstants.ERROR_PINPAD_EXECUTION:
        return 'Problema na execução de alguma das rotinas no pinpad';
      case CliSiTefConstants.ERROR_UNSAFE_TRANSACTION:
        return 'Transação não segura';
      case CliSiTefConstants.TRANSACTION_INTERNAL_ERROR:
        return 'Erro interno do módulo';
      default:
        return 'Erro desconhecido (código: $status)';
    }
  }

  /// Verifica se é necessário coletar dados
  bool get needsDataCollection => shouldContinue && command != null;

  /// Verifica se é necessário exibir mensagem
  bool get needsMessageDisplay => shouldContinue && message != null && message!.isNotEmpty;

  /// Verifica se é necessário coletar valor
  bool get needsAmountCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_AMOUNT;

  /// Verifica se é necessário coletar operador
  bool get needsOperatorCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_OPERATOR;

  /// Verifica se é necessário coletar cupom fiscal
  bool get needsCupomCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_CUPOM;

  /// Verifica se é necessário coletar data
  bool get needsDateCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_DATE;

  /// Verifica se é necessário coletar hora
  bool get needsTimeCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_TIME;

  /// Verifica se é necessário coletar senha
  bool get needsPasswordCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_PASSWORD;

  /// Verifica se é necessário coletar cartão
  bool get needsCardCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_CARD;

  /// Verifica se é necessário coletar confirmação (Sim/Não)
  bool get needsYesNoCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_YES_NO;

  /// Verifica se é necessário coletar menu
  bool get needsMenuCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_MENU;

  /// Verifica se é necessário coletar valor com ponto flutuante
  bool get needsFloatCollection => needsDataCollection && command == CliSiTefConstants.COMMAND_COLLECT_FLOAT;

  @override
  String toString() {
    return 'TransactionResponse('
        'serviceStatus: $serviceStatus, '
        'clisitefStatus: $clisitefStatus, '
        'sessionId: $sessionId, '
        'command: $command, '
        'message: $message'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionResponse &&
        other.serviceStatus == serviceStatus &&
        other.clisitefStatus == clisitefStatus &&
        other.sessionId == sessionId &&
        other.command == command &&
        other.message == message;
  }

  @override
  int get hashCode {
    return Object.hash(
      serviceStatus,
      clisitefStatus,
      sessionId,
      command,
      message,
    );
  }
}
