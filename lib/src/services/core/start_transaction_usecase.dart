import '../../core/services/message_manager.dart';
import '../../models/transaction_data.dart';
import '../../models/transaction_response.dart';
import '../../models/clisitef_response.dart';
import '../../repositories/clisitef_repository.dart';

/// Use case para iniciar transações CliSiTef
/// Pode ser usado tanto pelo serviço normal quanto pelo pendente
class StartTransactionUseCase {
  final CliSiTefRepository _repository;
  final AgenteClisitefMessageManager _messageManager = AgenteClisitefMessageManager.instance;

  StartTransactionUseCase(this._repository);

  /// Executa o use case de iniciar transação
  ///
  /// [data] - Dados da transação
  /// [autoProcess] - Se true, processa automaticamente o fluxo iterativo
  /// [stopBeforeFinish] - Se true, para antes da finalização (para transações pendentes)
  Future<StartTransactionResult> execute({
    required TransactionData data,
    bool autoProcess = true,
    bool stopBeforeFinish = false,
  }) async {
    final cliSiTefFields = CliSiTefResponse();
    try {
      print('[StartTransactionUseCase] Iniciando transação: ${data.functionId}');

      // Iniciar transação
      final startResponse = await _repository.startTransaction(data);
      _preencherCampos(cliSiTefFields, startResponse);

      if (!startResponse.isServiceSuccess) {
        print('[StartTransactionUseCase] Erro ao iniciar transação: ${startResponse.errorMessage}');
        return StartTransactionResult.error(startResponse, clisitefFields: cliSiTefFields);
      }

      // Se não precisa continuar, retorna imediatamente
      if (!startResponse.shouldContinue) {
        print('[StartTransactionUseCase] Transação concluída sem processamento iterativo');
        return StartTransactionResult.completed(startResponse, clisitefFields: cliSiTefFields);
      }

      // Se não deve processar automaticamente, retorna para processamento manual
      if (!autoProcess) {
        print('[StartTransactionUseCase] Transação iniciada, aguardando processamento manual');
        return StartTransactionResult.pending(startResponse, clisitefFields: cliSiTefFields);
      }

      // Processar fluxo iterativo
      print('[StartTransactionUseCase] Processando fluxo iterativo...');
      final iterativeResult = await _processIterativeFlow(startResponse, stopBeforeFinish, cliSiTefFields);

      return iterativeResult;
    } catch (e) {
      print('[StartTransactionUseCase] Erro inesperado: $e');
      return StartTransactionResult.error(
        TransactionResponse(
          serviceStatus: 0, // SERVICE_STATUS_ERROR
          serviceMessage: 'Erro interno: $e',
          clisitefStatus: -100,
        ),
        clisitefFields: cliSiTefFields,
      );
    }
  }

  /// Processa o fluxo iterativo da transação
  Future<StartTransactionResult> _processIterativeFlow(
    TransactionResponse initialResponse,
    bool stopBeforeFinish,
    CliSiTefResponse cliSiTefFields,
  ) async {
    try {
      TransactionResponse currentResponse = initialResponse;
      String? sessionId = currentResponse.sessionId;

      if (sessionId == null) {
        return StartTransactionResult.error(
          const TransactionResponse(
            serviceStatus: 0, // SERVICE_STATUS_ERROR
            serviceMessage: 'SessionId não encontrado',
            clisitefStatus: -10,
          ),
          clisitefFields: cliSiTefFields,
        );
      }

      // Loop de processamento iterativo
      while (currentResponse.shouldContinue) {
        print('[StartTransactionUseCase] Processando comando: ${currentResponse.command}');

        // Preencher campos da resposta atual
        _preencherCampos(cliSiTefFields, currentResponse);

        // Se não há comando específico, continuar sem dados
        if (currentResponse.command == null) {
          print('[StartTransactionUseCase] Continuando transação sem comando específico...');
          currentResponse = await _repository.continueTransaction(
            sessionId: sessionId,
            command: 0, // COMMAND_DISPLAY_MESSAGE
          );
        } else {
          // Processar comando específico
          final commandResult = await _processCommand(currentResponse);

          if (commandResult != null) {
            // Enviar dados coletados
            currentResponse = await _repository.continueTransaction(
              sessionId: sessionId,
              command: currentResponse.command!,
              data: commandResult,
            );
          } else {
            // Comando não processado, continuar sem dados
            currentResponse = await _repository.continueTransaction(
              sessionId: sessionId,
              command: currentResponse.command!,
            );
          }
        }

        if (!currentResponse.isServiceSuccess) {
          print('[StartTransactionUseCase] Erro no fluxo iterativo: ${currentResponse.errorMessage}');
          return StartTransactionResult.error(currentResponse, clisitefFields: cliSiTefFields);
        }
      }

      // Preencher campos da resposta final
      _preencherCampos(cliSiTefFields, currentResponse);

      // Se deve parar antes da finalização (transação pendente)
      if (stopBeforeFinish) {
        print('[StartTransactionUseCase] Transação processada, aguardando confirmação');
        return StartTransactionResult.pending(currentResponse, clisitefFields: cliSiTefFields);
      }

      // Finalizar transação (transação normal)
      print('[StartTransactionUseCase] Finalizando transação...');
      final finishResponse = await _repository.finishTransaction(
        sessionId: sessionId,
        confirm: true,
      );

      if (!finishResponse.isServiceSuccess) {
        print('[StartTransactionUseCase] Erro ao finalizar transação: ${finishResponse.errorMessage}');
        return StartTransactionResult.error(finishResponse, clisitefFields: cliSiTefFields);
      }

      print('[StartTransactionUseCase] Transação finalizada com sucesso');
      return StartTransactionResult.completed(finishResponse, clisitefFields: cliSiTefFields);
    } catch (e) {
      print('[StartTransactionUseCase] Erro no fluxo iterativo: $e');
      return StartTransactionResult.error(
        TransactionResponse(
          serviceStatus: 0, // SERVICE_STATUS_ERROR
          serviceMessage: 'Erro no fluxo iterativo: $e',
          clisitefStatus: -12,
        ),
        clisitefFields: cliSiTefFields,
      );
    }
  }

  /// Processa um comando específico
  Future<String?> _processCommand(TransactionResponse response) async {
    try {
      // Se não há comando, não há nada para processar
      if (response.command == null) {
        print('[StartTransactionUseCase] Nenhum comando para processar');
        return null;
      }

      // Processar mensagens do MessageManager
      if (response.command == 1 || response.command == 2 || response.command == 3) {
        _messageManager.processCommand(response.command!, message: response.message);
        return null; // Comandos de mensagem não precisam retornar dados
      }

      switch (response.command) {
        case 0: // COMMAND_DISPLAY_MESSAGE
          // Mensagem processada pelo MessageManager
          return null; // Não precisa retornar dados

        case 1: // COMMAND_COLLECT_AMOUNT
          print('[StartTransactionUseCase] Coletando valor monetário: ${response.message}');
          return '10,00'; // Mock - em produção seria input do usuário

        case 2: // COMMAND_COLLECT_OPERATOR
          print('[StartTransactionUseCase] Coletando operador: ${response.message}');
          return 'CAIXA'; // Mock - em produção seria input do usuário

        case 3: // COMMAND_COLLECT_CUPOM
          print('[StartTransactionUseCase] Coletando cupom fiscal: ${response.message}');
          return '123456'; // Mock - em produção seria input do usuário

        case 4: // COMMAND_COLLECT_DATE
          print('[StartTransactionUseCase] Coletando data: ${response.message}');
          return '20241201'; // Mock - em produção seria input do usuário

        case 5: // COMMAND_COLLECT_TIME
          print('[StartTransactionUseCase] Coletando hora: ${response.message}');
          return '1430'; // Mock - em produção seria input do usuário

        case 6: // COMMAND_COLLECT_PASSWORD
          print('[StartTransactionUseCase] Coletando senha: ${response.message}');
          return '1234'; // Mock - em produção seria input do usuário

        case 7: // COMMAND_COLLECT_CARD
          print('[StartTransactionUseCase] Coletando cartão: ${response.message}');
          return null; // Não precisa retornar dados

        case 20: // COMMAND_COLLECT_YES_NO
          print('[StartTransactionUseCase] Coletando confirmação: ${response.message}');
          return 'S'; // Mock - em produção seria seleção do usuário

        case 21: // COMMAND_COLLECT_MENU
          print('[StartTransactionUseCase] Coletando opção do menu: ${response.message}');
          return '1'; // Mock - em produção seria seleção do usuário

        case 22: // COMMAND_COLLECT_FLOAT
          print('[StartTransactionUseCase] Coletando valor com ponto flutuante: ${response.message}');
          return '10.50'; // Mock - em produção seria input do usuário

        case 23: // COMMAND_COLLECT_CARD_READER
          print('[StartTransactionUseCase] Coletando dados do leitor de cartão: ${response.message}');
          return null; // Não precisa retornar dados

        case 24: // COMMAND_COLLECT_YES_NO_EXTENDED
          print('[StartTransactionUseCase] Coletando confirmação estendida: ${response.message}');
          return 'S'; // Mock - em produção seria seleção do usuário

        default:
          print('[StartTransactionUseCase] Comando desconhecido: ${response.command}');
          return null; // Comando não reconhecido
      }
    } catch (e) {
      print('[StartTransactionUseCase] Erro ao processar comando: $e');
      return null; // Indica erro no processamento
    }
  }

  void _preencherCampos(CliSiTefResponse cliSiTefFields, TransactionResponse response) {
    if (response.fieldType != null && response.buffer != null) {
      cliSiTefFields.onFieldId(fieldId: response.fieldType!, buffer: response.buffer!);
    }

    // Verificar se há campos nos dados adicionais
    for (final entry in response.additionalData.entries) {
      final key = entry.key;
      final value = entry.value?.toString() ?? '';

      // Se o campo parece ser um fieldId (número)
      if (key.startsWith('field') || RegExp(r'^\d+$').hasMatch(key)) {
        final fieldId = int.tryParse(key.replaceAll('field', ''));
        if (fieldId != null && value.isNotEmpty) {
          cliSiTefFields.onFieldId(fieldId: fieldId, buffer: value);
        }
      }
    }
  }
}

/// Resultado do use case de iniciar transação
class StartTransactionResult {
  final bool isSuccess;
  final bool isCompleted;
  final bool isPending;
  final TransactionResponse response;
  final CliSiTefResponse? clisitefFields;
  final String? errorMessage;

  StartTransactionResult._({
    required this.isSuccess,
    required this.isCompleted,
    required this.isPending,
    required this.response,
    this.clisitefFields,
    this.errorMessage,
  });

  /// Transação concluída com sucesso
  factory StartTransactionResult.completed(TransactionResponse response, {CliSiTefResponse? clisitefFields}) {
    return StartTransactionResult._(
      isSuccess: true,
      isCompleted: true,
      isPending: false,
      response: response,
      clisitefFields: clisitefFields,
    );
  }

  /// Transação pendente (aguardando confirmação)
  factory StartTransactionResult.pending(TransactionResponse response, {CliSiTefResponse? clisitefFields}) {
    return StartTransactionResult._(
      isSuccess: true,
      isCompleted: false,
      isPending: true,
      response: response,
      clisitefFields: clisitefFields,
    );
  }

  /// Erro na transação
  factory StartTransactionResult.error(TransactionResponse response, {CliSiTefResponse? clisitefFields}) {
    return StartTransactionResult._(
      isSuccess: false,
      isCompleted: false,
      isPending: false,
      response: response,
      clisitefFields: clisitefFields,
      errorMessage: response.errorMessage,
    );
  }
}
