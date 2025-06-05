import 'package:agente_clisitef/src/models/messages.dart';
import 'package:agente_clisitef/src/repositories/responses/continue_transaction_response.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:agente_clisitef/src/services/mappers/transaction_mappers.dart';
import 'package:agente_clisitef/src/services/transaction_state.dart';
import 'package:agente_clisitef/src/models/refund.dart';
import 'package:agente_clisitef/src/models/clisitef_resp.dart';

/// Código padrão para início de transação
const int kDefaultContinueCode = 0;

/// Serviço responsável pelo fluxo de transações TEF via Pinpad.
/// Gerencia o estado, integra com o repositório e executa o fluxo de pagamento/cancelamento.
class PdvPinpadService {
  final IAgenteClisitefRepository _repository;
  final TransactionState _state;

  /// Cria uma instância do serviço de Pinpad.
  /// [repository] é obrigatório e deve implementar a interface de integração TEF.
  /// [state] pode ser injetado para facilitar testes.
  PdvPinpadService({
    required IAgenteClisitefRepository repository,
    TransactionState? state,
  })  : _repository = repository,
        _state = state ?? TransactionState();

  Stream<PaymentStatus> get paymentStatusStream => _state.paymentStatusStream;
  Stream<Transaction> get transactionStream => _state.transactionStream;
  Transaction? get currentTransaction => _state.currentTransaction;
  ValueNotifier<Messages> get messagesNotifier => _state.messagesNotifier;
  bool get isFinish => _state.isFinish;

  /// Libera recursos e reseta o estado.
  void dispose() {
    _state.reset();
  }

  /// Inicia uma transação de venda ou outro tipo, conforme [functionId] e [tipoTransacao].
  /// Atualiza o status via [updatePaymentStatus].
  Future<void> startTransaction({
    required double amount,
    required FunctionId functionId,
    required TipoTransacao tipoTransacao,
    required Function(PaymentStatus) updatePaymentStatus,
  }) async {
    _state.reset();
    updatePaymentStatus(PaymentStatus.processing);

    try {
      final result = await _repository.startTransaction(
        amount: amount,
        functionId: functionId.value.toString(),
        paymentMethod: functionId,
      );

      // TODO: Ajustar para obter o continueCode e data corretos do fluxo real
      const continueCode = kDefaultContinueCode;
      const data = null;

      final continueCodeStr = continueCode.toString();
      final funcMap = TransactionMappers.mapFuncTransacaoSimple(continueCodeStr);

      if (funcMap.isNotEmpty) {
        await _repository.continueTransaction(
          sessionId: result.sessionId,
          continueCode: continueCode,
          data: data,
        );
      }
    } catch (e) {
      // TODO: Integrar com serviço de log se necessário
      updatePaymentStatus(PaymentStatus.error);
      // print('Erro ao iniciar transação: $e\n$stack');
      rethrow;
    }
  }

  Future<Transaction> refundTransaction({required Refund refund}) async {
    _state.reset();
    _state.setRefund(refund);
    _state.messagesNotifier.value = Messages(message: 'Refunding sale, please wait...', comandEvent: CommandEvents.messageCustomer);
    _state.setTaxInvoiceNumber('');

    final session = await _repository.createSession();
    await _repository.startTransaction(
      paymentMethod: FunctionId.generico,
      sesionId: session.sessionId,
      functionId: "110",
    );
    // Criar um CliSiTefResp padrão
    final cliSiTefRespDefault = CliSiTefResp(
      codResult: {},
    );
    _state.updateTransaction(
      cliSiTefResp: cliSiTefRespDefault,
      event: DataEvents.unknown,
      command: CommandEvents.unknown,
      buffer: '',
      fildId: 0,
      commandId: 0,
    );

    await continueTransaction(continueCode: 0, tipoTransacao: TipoTransacao.estorno);
    while (!_state.isFinish) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return _state.currentTransaction!;
  }

  Future<void> continueTransaction({String? data, required int continueCode, required TipoTransacao tipoTransacao}) async {
    if (_state.isFinish) return;

    final response = await _repository.continueTransaction(
      sessionId: _state.currentTransaction?.startTransactionResponse?.sessionId ?? '',
      continueCode: continueCode,
      data: data?.toString() ?? '',
    );

    _updateMessage(response: response);
    _updateTransaction(response: response);

    if (continueCode == -1) {
      _state.setFinish(true);
      return;
    }

    if (response != null) {
      if (tipoTransacao == TipoTransacao.venda) {
        final continueCodeStr = continueCode.toString();
        final map = TransactionMappers.mapFuncTransacaoSimple(continueCodeStr);

        if (map.isNotEmpty) {
          await continueTransaction(
            continueCode: continueCode,
            data: response.data,
            tipoTransacao: tipoTransacao,
          );
          return;
        }

        final customComand = _customComandId(response.fieldId, response.clisitefStatus);
        if (customComand != null && continueCode == 0) {
          final customComandStr = customComand.toString();
          final mappedFunction = TransactionMappers.mapFuncTransacaoSimple(customComandStr);

          if (mappedFunction.isNotEmpty) {
            await continueTransaction(
              continueCode: continueCode,
              data: response.data,
              tipoTransacao: tipoTransacao,
            );
            return;
          }
        }
      }

      if (tipoTransacao == TipoTransacao.estorno) {
        if (response.fieldId == 121) {
          Future.delayed(const Duration(seconds: 3), () {
            if (!_state.isFinish) {
              _handleFinalizarEstorno(response.fieldId, response.clisitefStatus);
            }
          });
        }
        final func = _mapFuncCancelarContains(response.data ?? '');
        if (func != null) {
          await func();
          return;
        }
        _handleFinalizarEstorno(response.fieldId, response.clisitefStatus);
      }

      if (response.serviceMessage != null) {
        _state.setFinish(true);
        return;
      }
    }

    // Continua a transação com o mesmo código e tipo
    await continueTransaction(
      continueCode: continueCode,
      tipoTransacao: tipoTransacao,
    );
  }

  Future<void> finishTransaction() async {
    await _repository.finishTransaction(
      sessionId: _state.currentTransaction?.startTransactionResponse?.sessionId ?? '',
      taxInvoiceNumber: _state.taxInvoiceNumber,
      confirm: 1,
    );
    _state.updatePaymentStatus(PaymentStatus.done);
    _state.setFinish(true);
    if (_state.currentTransaction != null) {
      _state.completeTransaction(_state.currentTransaction!);
    }
  }

  void _updateMessage({ContinueTransactionResponse? response}) {
    if (response != null) {
      final command = CommandEvents.fromCommandId(response.commandId);
      if (command == CommandEvents.messageCustomer) {
        _state.messagesNotifier.value = Messages(message: response.data ?? '', comandEvent: command);
      }
    }
  }

  void _updateTransaction({ContinueTransactionResponse? response}) {
    final cliSiTefRespDefault = CliSiTefResp(
      codResult: {},
    );
    if (response != null) {
      const event = DataEvents.unknown;
      final command = CommandEvents.fromCommandId(response.commandId);
      _state.updateTransaction(
        cliSiTefResp: cliSiTefRespDefault,
        event: event,
        command: command,
        buffer: response.data ?? '',
        fildId: response.fieldId,
        commandId: response.commandId,
      );
    }
  }

  /// Inicia o fluxo de estorno/cancelamento de uma transação.
  Future<void> cancelTransaction({
    required Refund refund,
    required Function(PaymentStatus) updatePaymentStatus,
  }) async {
    _state.reset();
    updatePaymentStatus(PaymentStatus.processing);

    try {
      final result = await _repository.startTransaction(
        amount: refund.amount,
        functionId: FunctionId.generico.value.toString(),
        paymentMethod: FunctionId.generico,
      );

      const data = '';

      final mappedFunction = TransactionMappers.mapFuncCancelarTransacaoSimple(data.toLowerCase());

      if (mappedFunction.isNotEmpty) {
        await _repository.continueTransaction(
          sessionId: result.sessionId,
          continueCode: 0,
          data: data,
        );
      }
    } catch (e) {
      updatePaymentStatus(PaymentStatus.error);

      rethrow;
    }
  }

  Future<void> Function()? _mapFuncCancelarContains(String data) {
    final mappedFunction = TransactionMappers.mapFuncCancelarTransacao(
      data: data,
      refund: _state.refund!,
      continueTransaction: (code, data) async {
        await continueTransaction(
          continueCode: code,
          data: data,
          tipoTransacao: TipoTransacao.estorno,
        );
      },
      completeError: (error) {
        _state.completeError(error);
      },
      setIsFinish: () {
        _state.setFinish(true);
      },
    );
    if (mappedFunction.isNotEmpty) {
      return mappedFunction.values.first;
    }
    return null;
  }

  int? _customComandId(int fieldId, int clisitefStatus) {
    if (fieldId == 0 && clisitefStatus == 0) {
      return -11;
    }
    return null;
  }

  void _handleFinalizarEstorno(int fieldId, int clisitefStatus) {
    if (fieldId == 0 && clisitefStatus == 0) {
      _state.updatePaymentStatus(PaymentStatus.sucess);
      _state.setFinish(true);
      if (_state.currentTransaction != null) {
        _state.completeTransaction(_state.currentTransaction!);
      }
    }
  }

  /// Continua uma transação em andamento
  Future<void> continueTransactionFlow(
    String sessionId,
    Function(String) onErrorToBack,
    Function(String) onErrorToFront,
    Function(String) onSuccess,
    Function(String) onFinish,
  ) async {
    try {
      final response = await _repository.continueTransaction(
        sessionId: sessionId,
        continueCode: 0,
        data: null,
      );

      if (response == null) {
        onErrorToBack('Resposta inválida do servidor');
        return;
      }

      // Verifica se é um erro conhecido
      if (TransactionMappers.hasKnownError(response.data ?? '')) {
        final errorMessage = TransactionMappers.getErrorMessage(response.data ?? '');
        onErrorToBack(errorMessage);
        return;
      }

      // Verifica se é um erro interno
      if (TransactionMappers.isErrorStatus(response.clisitefStatus)) {
        final errorMessage = TransactionMappers.getStatusMessage(response.clisitefStatus);
        onErrorToBack(errorMessage);
        return;
      }

      // Verifica se é uma mensagem de finalização
      if (response.data?.contains('FINALIZAR') ?? false) {
        onFinish(response.data ?? '');
        return;
      }

      // Se chegou aqui, é uma mensagem de sucesso
      onSuccess(response.data ?? '');
    } catch (e) {
      onErrorToBack('Erro ao continuar transação: ${e.toString()}');
    }
  }

  /// Finaliza uma transação
  Future<void> finishTransactionFlow(
    String sessionId,
    Function(String) onErrorToBack,
    Function(String) onErrorToFront,
    Function(String) onSuccess,
  ) async {
    try {
      final response = await _repository.finishTransaction(
        sessionId: sessionId,
        taxInvoiceNumber: null,
        confirm: 1,
      );

      // Verifica se é um erro conhecido
      if (TransactionMappers.hasKnownError(response.sessionId)) {
        final errorMessage = TransactionMappers.getErrorMessage(response.sessionId);
        onErrorToBack(errorMessage);
        return;
      }

      // Verifica se é um erro interno
      if (TransactionMappers.isErrorStatus(response.clisitefStatus)) {
        final errorMessage = TransactionMappers.getStatusMessage(response.clisitefStatus);
        onErrorToBack(errorMessage);
        return;
      }

      // Se chegou aqui, é uma mensagem de sucesso
      onSuccess('Transação finalizada com sucesso');
    } catch (e) {
      onErrorToBack('Erro ao finalizar transação: ${e.toString()}');
    }
  }
}
