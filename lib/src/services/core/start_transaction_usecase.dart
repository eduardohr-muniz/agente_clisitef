import 'package:talker/talker.dart';

import '../../core/services/message_manager.dart';
import '../../core/utils/format_utils.dart';
import '../../models/transaction_data.dart';
import '../../models/transaction_response.dart';
import '../../models/clisitef_response.dart';
import '../../repositories/clisitef_repository.dart';

/// Use case para iniciar transações CliSiTef
/// Pode ser usado tanto pelo serviço normal quanto pelo pendente
class StartTransactionUseCase {
  final CliSiTefRepository _repository;
  final AgenteClisitefMessageManager _messageManager = AgenteClisitefMessageManager.instance;
  final bool _useSmartPixSelection;
  final Talker? _talker;

  StartTransactionUseCase(this._repository, {bool useSmartPixSelection = false, Talker? talker})
      : _useSmartPixSelection = useSmartPixSelection,
        _talker = talker;

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
      // Iniciar transação
      final startResponse = await _repository.startTransaction(data);
      _preencherCampos(cliSiTefFields, startResponse);

      if (!startResponse.isServiceSuccess) {
        return StartTransactionResult.error(startResponse, clisitefFields: cliSiTefFields);
      }

      // Se não precisa continuar, retorna imediatamente
      if (!startResponse.shouldContinue) {
        return StartTransactionResult.completed(startResponse, clisitefFields: cliSiTefFields);
      }

      // Se não deve processar automaticamente, retorna para processamento manual
      if (!autoProcess) {
        return StartTransactionResult.pending(startResponse, clisitefFields: cliSiTefFields);
      }

      // Processar fluxo iterativo
      final iterativeResult = await _processIterativeFlow(startResponse, stopBeforeFinish, cliSiTefFields);

      return iterativeResult;
    } catch (e) {
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

      // Loop de processamento iterativo [CONTINUE]
      while (currentResponse.shouldContinue) {
        // Preencher campos da resposta atual
        _preencherCampos(cliSiTefFields, currentResponse);

        // Se não há comando específico, continuar sem dados
        if (currentResponse.command == null) {
          currentResponse = await _repository.continueTransaction(
            sessionId: sessionId,
            command: 0,
          );
        }

        // Processar comando específico
        final commandResult = await _processCommand(currentResponse);

        // Se o comando foi processado, continuar com os dados coletados
        if (commandResult != null) {
          currentResponse = await _repository.continueTransaction(
            sessionId: sessionId,
            command: currentResponse.command!,
            data: commandResult,
          );
        }

        // Se o comando não foi processado, continuar sem dados
        if (commandResult == null) {
          currentResponse = await _repository.continueTransaction(
            sessionId: sessionId,
            command: currentResponse.command!,
          );
        }

        // Verificar se a resposta indica erro baseado nos códigos
        if (_isErrorInClisistefStatus(currentResponse.clisitefStatus)) {
          return StartTransactionResult.error(currentResponse, clisitefFields: cliSiTefFields);
        }

        if (!currentResponse.isServiceSuccess) {
          return StartTransactionResult.error(currentResponse, clisitefFields: cliSiTefFields);
        }
      }

      // Preencher campos da resposta final
      _preencherCampos(cliSiTefFields, currentResponse);

      // Se deve parar antes da finalização (transação pendente)
      if (stopBeforeFinish) {
        return StartTransactionResult.pending(currentResponse, clisitefFields: cliSiTefFields);
      }

      // Finalizar transação (transação normal)
      final finishResponse = await _repository.finishTransaction(
        sessionId: sessionId,
        confirm: true,
      );

      if (!finishResponse.isServiceSuccess) {
        return StartTransactionResult.error(finishResponse, clisitefFields: cliSiTefFields);
      }

      return StartTransactionResult.completed(finishResponse, clisitefFields: cliSiTefFields);
    } catch (e) {
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

  /// Verifica se a resposta indica um erro baseado nos códigos
  bool _isErrorInClisistefStatus(int clisitefStatus) {
    if (clisitefStatus != 0 && clisitefStatus != 10000) {
      _talker?.error('_isErrorResponse: clisitefStatus: $clisitefStatus');
      return true;
    }

    return false;
  }

  /// Processa um comando específico
  Future<String?> _processCommand(TransactionResponse response) async {
    try {
      // Se não há comando, não há nada para processar
      if (response.command == null) {
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
          return '10,00'; // Mock - em produção seria input do usuário

        case 2: // COMMAND_COLLECT_OPERATOR
          return 'CAIXA'; // Mock - em produção seria input do usuário

        case 3: // COMMAND_COLLECT_CUPOM
          return '123456'; // Mock - em produção seria input do usuário

        case 4: // COMMAND_COLLECT_DATE
          return '20241201'; // Mock - em produção seria input do usuário

        case 5: // COMMAND_COLLECT_TIME
          return '1430'; // Mock - em produção seria input do usuário

        case 6: // COMMAND_COLLECT_PASSWORD
          return '1234'; // Mock - em produção seria input do usuário

        case 7: // COMMAND_COLLECT_CARD
          return null; // Não precisa retornar dados

        case 20: // COMMAND_COLLECT_YES_NO
          return 'S'; // Mock - em produção seria seleção do usuário

        case 21: // COMMAND_COLLECT_MENU
          if (_useSmartPixSelection) {
            // SELEÇÃO AUTOMÁTICA INTELIGENTE DE PIX (apenas para fluxo automático)
            final menuData = response.buffer ?? '';
            final selectedOption = FormatUtils.selectPixOption(menuData);

            // Log da seleção automática para debug
            final options = FormatUtils.parseMenuOptions(menuData);
            final selectedText = options.firstWhere((opt) => opt['index'] == selectedOption,
                orElse: () => {'index': selectedOption, 'text': 'Opção $selectedOption'})['text'];

            _messageManager.processCommand(1, message: 'Seleção automática PIX: $selectedText (opção $selectedOption)');

            return selectedOption;
          } else {
            // Fluxo manual - retorna "1" como padrão (para manter compatibilidade)
            return '1'; // Mock - em produção seria seleção do usuário via diálogo
          }

        case 22: // COMMAND_COLLECT_FLOAT
          return '10.50'; // Mock - em produção seria input do usuário

        case 23: // COMMAND_COLLECT_CARD_READER
          return null; // Não precisa retornar dados

        case 24: // COMMAND_COLLECT_YES_NO_EXTENDED
          return 'S'; // Mock - em produção seria seleção do usuário

        default:
          return null; // Comando não reconhecido
      }
    } catch (e) {
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
