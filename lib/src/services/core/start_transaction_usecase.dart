import 'package:talker/talker.dart';

import '../../core/constants/clisitef_constants.dart';

import '../../core/services/message_manager.dart';
import '../../core/utils/format_utils.dart';
import '../../models/transaction_data.dart';
import '../../models/transaction_response.dart';
import '../../models/clisitef_response.dart';
import '../../repositories/clisitef_repository.dart';
import 'parcelado_loja_interacao.dart';

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
      final parceladoLoja = data.installments == null ? null : ParceladoLojaInteracao(data.installments!);
      final iterativeResult = await _processIterativeFlow(startResponse, stopBeforeFinish, cliSiTefFields, parceladoLoja);

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
    ParceladoLojaInteracao? parceladoLoja,
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

        // Processar comando específico
        final String? commandResult;
        try {
          commandResult = _responderParceladoLoja(parceladoLoja, currentResponse) ?? await _processCommand(currentResponse);
        } on ParceladoLojaIndisponivelException catch (erro) {
          _talker?.error(erro.message);
          await _repository.continueTransaction(
            sessionId: sessionId,
            command: currentResponse.command ?? 0,
            continueCode: _abortarFluxo,
            data: '',
          );
          return StartTransactionResult.error(_erroParceladoLoja(erro.message), clisitefFields: cliSiTefFields);
        }

        currentResponse = await _repository.continueTransaction(
          sessionId: sessionId,
          command: currentResponse.command ?? 0,
          data: commandResult,
        );

        // Verificar se a resposta indica erro baseado nos códigos
        if (_hasError(currentResponse)) {
          return StartTransactionResult.error(currentResponse, clisitefFields: cliSiTefFields);
        }
      }

      // Preencher campos da resposta final
      _preencherCampos(cliSiTefFields, currentResponse);

      // Parcelado loja: só segue se a transação realmente saiu parcelada
      final motivoParaDesfazer = parceladoLoja?.motivoParaDesfazer(cliSiTefFields);
      if (motivoParaDesfazer != null) {
        _talker?.error(motivoParaDesfazer);
        await _desfazerTransacao(sessionId);
        return StartTransactionResult.error(_erroParceladoLoja(motivoParaDesfazer), clisitefFields: cliSiTefFields);
      }

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

  /// Valor de `continue` que interrompe o fluxo iterativo do CliSiTef.
  static const int _abortarFluxo = -1;

  /// Comandos de coleta de campo em que o CliSiTef pergunta o número de parcelas.
  static const Set<int> _comandosColetaCampo = {29, 30};

  /// Resposta do crédito parcelado loja, ou `null` para seguir o comportamento padrão.
  String? _responderParceladoLoja(ParceladoLojaInteracao? parceladoLoja, TransactionResponse response) {
    if (parceladoLoja == null) return null;
    if (response.command == 21) return parceladoLoja.responderMenu(response.buffer ?? '');
    if (_comandosColetaCampo.contains(response.command)) return parceladoLoja.responderCampo(response.fieldType);
    return null;
  }

  Future<void> _desfazerTransacao(String sessionId) async {
    try {
      await _repository.finishTransaction(sessionId: sessionId, confirm: false);
    } catch (erro) {
      _talker?.error('Falha ao desfazer transação parcelada: $erro');
    }
  }

  TransactionResponse _erroParceladoLoja(String mensagem) {
    return TransactionResponse(
      serviceStatus: CliSiTefConstants.SERVICE_STATUS_ERROR,
      serviceMessage: mensagem,
      clisitefStatus: CliSiTefConstants.TRANSACTION_INTERNAL_ERROR,
    );
  }

  /// Verifica se a resposta indica um erro baseado nos códigos
  bool _hasError(TransactionResponse response) {
    if (response.clisitefStatus != 0 && response.clisitefStatus != 10000) {
      _talker?.error('_isErrorResponse: clisitefStatus: ${response.clisitefStatus}');
      return true;
    }

    if (!response.isServiceSuccess) {
      _talker?.error('_isErrorResponse: isServiceSuccess: ${response.isServiceSuccess}');
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
