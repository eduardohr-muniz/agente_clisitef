import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:agente_clisitef/src/core/constants/clisitef_constants.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_exception.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_error_codes.dart';
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/models/transaction_data.dart';
import 'package:agente_clisitef/src/models/transaction_response.dart';
import 'package:agente_clisitef/src/repositories/clisitef_repository.dart';

/// Implementação do repositório CliSiTef usando Dio
class CliSiTefRepositoryImpl implements CliSiTefRepository {
  final CliSiTefConfig _config;
  late final Dio _dio;
  late final Talker _talker;
  String? _currentSessionId;
  bool _isInitialized = false;

  CliSiTefRepositoryImpl({required CliSiTefConfig config}) : _config = config {
    _initializeDio();
  }

  /// Inicializa o Dio com configurações
  void _initializeDio() {
    _talker = Talker();

    _dio = Dio(BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: _config.timeout,
      receiveTimeout: _config.timeout,
      sendTimeout: _config.timeout,
      headers: {
        CliSiTefConstants.HEADER_CONTENT_TYPE: CliSiTefConstants.CONTENT_TYPE_FORM,
        CliSiTefConstants.HEADER_ACCEPT: CliSiTefConstants.CONTENT_TYPE_JSON,
      },
    ));

    // Adiciona interceptor de logs se habilitado
    if (_config.enableLogs) {
      _dio.interceptors.add(TalkerDioLogger(
        talker: _talker,
        settings: const TalkerDioLoggerSettings(
          printRequestData: true,
          printResponseData: true,
          printResponseMessage: true,
        ),
      ));
    }

    // Adiciona interceptor para tratamento de erros
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        _talker.error('Erro na requisição HTTP: ${error.message}', error);
        handler.next(error);
      },
    ));
  }

  @override
  bool get isInitialized => _isInitialized;

  @override
  Future<TransactionResponse> startTransaction(TransactionData data) async {
    try {
      _talker.info('Iniciando transação: ${data.functionId}');

      // Combina os dados da transação com a configuração
      final body = Map<String, String>.from(data.toMap());
      body.addAll(_config.toMap());

      final response = await _dio.post(
        CliSiTefConstants.START_TRANSACTION_ENDPOINT,
        data: body,
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      // Armazena o sessionId se retornado
      if (transactionResponse.sessionId != null) {
        _currentSessionId = transactionResponse.sessionId;
      }

      _talker.info('Transação iniciada com sucesso. Status: ${transactionResponse.clisitefStatus}');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao iniciar transação', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao iniciar transação: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao iniciar transação', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao iniciar transação: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> continueTransaction({
    required String sessionId,
    required int command,
    String? data,
  }) async {
    try {
      _talker.info('Continuando transação. Comando: $command, Dados: $data');

      // O parâmetro continue deve ser sempre "0" para continuar o fluxo
      // O command é apenas para identificar o tipo de comando
      final body = {
        CliSiTefConstants.PARAM_SESSION_ID: sessionId,
        CliSiTefConstants.PARAM_CONTINUE: '0',
        'data': data ?? '', // Sempre envia 'data', mesmo que vazio
      };

      _talker.info('Dados da requisição continueTransaction: $body');

      final response = await _dio.post(
        CliSiTefConstants.CONTINUE_TRANSACTION_ENDPOINT,
        data: body,
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('Transação continuada. Status: ${transactionResponse.clisitefStatus}');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao continuar transação', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao continuar transação: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao continuar transação', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao continuar transação: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> finishTransaction({
    required String sessionId,
    required bool confirm,
    String? taxInvoiceNumber,
    String? taxInvoiceDate,
    String? taxInvoiceTime,
  }) async {
    try {
      _talker.info('Finalizando transação. Confirmar: $confirm');

      // Conforme sua homologação, o finishTransaction deve enviar todos os parâmetros
      // confirm=1&sessionId=xxx&taxInvoiceNumber=1234&taxInvoiceDate=20180611&taxInvoiceTime=170000
      final body = {
        CliSiTefConstants.PARAM_SESSION_ID: sessionId,
        'confirm': confirm ? '1' : '0',
      };

      // Sempre adiciona dados fiscais se fornecidos
      if (taxInvoiceNumber != null) {
        body[CliSiTefConstants.PARAM_TAX_INVOICE_NUMBER] = taxInvoiceNumber;
        if (taxInvoiceDate != null) {
          body[CliSiTefConstants.PARAM_TAX_INVOICE_DATE] = taxInvoiceDate;
        }
        if (taxInvoiceTime != null) {
          body[CliSiTefConstants.PARAM_TAX_INVOICE_TIME] = taxInvoiceTime;
        }
      }

      _talker.info('Dados da requisição finishTransaction: $body');

      // Envia como dados simples sem FormData
      final response = await _dio.post(
        CliSiTefConstants.FINISH_TRANSACTION_ENDPOINT,
        data: body,
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      // Limpa o sessionId atual
      _currentSessionId = null;

      _talker.info('Transação finalizada. Status: ${transactionResponse.clisitefStatus}');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao finalizar transação', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao finalizar transação: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao finalizar transação', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao finalizar transação: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> createSession() async {
    try {
      _talker.info('Criando sessão...');

      final response = await _dio.post(
        CliSiTefConstants.SESSION_ENDPOINT,
        data: _config.toMap(),
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      if (transactionResponse.isServiceSuccess && transactionResponse.sessionId != null) {
        _currentSessionId = transactionResponse.sessionId;
        _isInitialized = true;
        _talker.info('Sessão criada com sucesso. SessionId: $_currentSessionId');
      } else {
        _talker.error('Erro ao criar sessão: ${transactionResponse.errorMessage}');
      }

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao criar sessão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao criar sessão: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao criar sessão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao criar sessão: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> getSession() async {
    try {
      _talker.info('Consultando sessão...');

      final response = await _dio.get(CliSiTefConstants.SESSION_ENDPOINT);

      final transactionResponse = TransactionResponse.fromJson(response.data);

      if (transactionResponse.isServiceSuccess && transactionResponse.sessionId != null) {
        _currentSessionId = transactionResponse.sessionId;
        _isInitialized = true;
        _talker.info('Sessão consultada com sucesso. SessionId: $_currentSessionId');
      }

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao consultar sessão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao consultar sessão: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao consultar sessão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao consultar sessão: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> deleteSession() async {
    try {
      _talker.info('Excluindo sessão...');

      final response = await _dio.delete(CliSiTefConstants.SESSION_ENDPOINT);

      final transactionResponse = TransactionResponse.fromJson(response.data);

      // Limpa o sessionId atual
      _currentSessionId = null;
      _isInitialized = false;

      _talker.info('Sessão excluída com sucesso');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao excluir sessão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao excluir sessão: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao excluir sessão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao excluir sessão: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> getState() async {
    try {
      _talker.info('Consultando estado do serviço...');

      final response = await _dio.get(CliSiTefConstants.STATE_ENDPOINT);

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('Estado consultado. ServiceState: ${transactionResponse.serviceState}');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao consultar estado', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao consultar estado: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao consultar estado', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao consultar estado: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> getVersion() async {
    try {
      _talker.info('Consultando versão...');

      final response = await _dio.post(
        CliSiTefConstants.GET_VERSION_ENDPOINT,
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('Versão consultada com sucesso');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao consultar versão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao consultar versão: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao consultar versão', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao consultar versão: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> openPinPad({required String sessionId}) async {
    try {
      _talker.info('Abrindo PinPad...');

      final response = await _dio.post(
        CliSiTefConstants.PINPAD_OPEN_ENDPOINT,
        data: {CliSiTefConstants.PARAM_SESSION_ID: sessionId},
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('PinPad aberto com sucesso');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao abrir PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao abrir PinPad: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao abrir PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao abrir PinPad: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> closePinPad({required String sessionId}) async {
    try {
      _talker.info('Fechando PinPad...');

      final response = await _dio.post(
        CliSiTefConstants.PINPAD_CLOSE_ENDPOINT,
        data: {CliSiTefConstants.PARAM_SESSION_ID: sessionId},
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('PinPad fechado com sucesso');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao fechar PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao fechar PinPad: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao fechar PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao fechar PinPad: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> isPinPadPresent({required String sessionId}) async {
    try {
      _talker.info('Verificando presença do PinPad...');

      final response = await _dio.post(
        CliSiTefConstants.PINPAD_IS_PRESENT_ENDPOINT,
        data: {CliSiTefConstants.PARAM_SESSION_ID: sessionId},
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('Presença do PinPad verificada');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao verificar presença do PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao verificar presença do PinPad: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao verificar presença do PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao verificar presença do PinPad: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> readPinPadYesNo({
    required String sessionId,
    required String displayMessage,
  }) async {
    try {
      _talker.info('Lendo confirmação Sim/Não do PinPad...');

      final response = await _dio.post(
        CliSiTefConstants.PINPAD_READ_YES_NO_ENDPOINT,
        data: {
          CliSiTefConstants.PARAM_SESSION_ID: sessionId,
          CliSiTefConstants.PARAM_DISPLAY_MESSAGE: displayMessage,
        },
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('Confirmação Sim/Não lida do PinPad');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao ler confirmação Sim/Não do PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao ler confirmação Sim/Não do PinPad: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao ler confirmação Sim/Não do PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao ler confirmação Sim/Não do PinPad: $e',
        originalError: e,
      );
    }
  }

  @override
  Future<TransactionResponse> setPinPadDisplayMessage({
    required String sessionId,
    required String displayMessage,
  }) async {
    try {
      _talker.info('Definindo mensagem do PinPad: $displayMessage');

      final response = await _dio.post(
        CliSiTefConstants.PINPAD_SET_DISPLAY_MESSAGE_ENDPOINT,
        data: {
          CliSiTefConstants.PARAM_SESSION_ID: sessionId,
          CliSiTefConstants.PARAM_DISPLAY_MESSAGE: displayMessage,
        },
        options: Options(headers: {'Content-Type': 'application/x-www-form-urlencoded'}),
      );

      final transactionResponse = TransactionResponse.fromJson(response.data);

      _talker.info('Mensagem do PinPad definida com sucesso');

      return transactionResponse;
    } on DioException catch (e) {
      _talker.error('Erro ao definir mensagem do PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.fromCode(e.response?.statusCode ?? -1),
        message: 'Erro ao definir mensagem do PinPad: ${e.message}',
        originalError: e,
      );
    } catch (e) {
      _talker.error('Erro inesperado ao definir mensagem do PinPad', e);
      throw CliSiTefException(
        errorCode: CliSiTefErrorCode.unknownError,
        message: 'Erro inesperado ao definir mensagem do PinPad: $e',
        originalError: e,
      );
    }
  }

  @override
  String? get currentSessionId => _currentSessionId;

  @override
  Future<bool> checkPinPadPresence() async {
    try {
      if (!_isInitialized || _currentSessionId == null) {
        return false;
      }

      final response = await isPinPadPresent(sessionId: _currentSessionId!);
      return response.isServiceSuccess && response.clisitefStatus == CliSiTefConstants.SUCCESS;
    } catch (e) {
      _talker.error('Erro ao verificar presença do PinPad', e);
      return false;
    }
  }

  @override
  Future<int> setPinPadMessage(String message) async {
    try {
      if (!_isInitialized || _currentSessionId == null) {
        return -1;
      }

      final response = await setPinPadDisplayMessage(
        sessionId: _currentSessionId!,
        displayMessage: message,
      );

      return response.clisitefStatus;
    } catch (e) {
      _talker.error('Erro ao definir mensagem do PinPad', e);
      return -1;
    }
  }

  @override
  void dispose() {
    _dio.close();
  }
}
