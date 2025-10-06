import 'dart:async';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/utils/format_utils.dart';
import 'package:agente_clisitef/src/core/utils/payment_method.dart';
import 'package:flutter/foundation.dart';

/// Serviço para transações pendentes de confirmação
/// Permite iniciar uma transação e decidir posteriormente se confirmar ou cancelar
class ClisitefCancelamentoService {
  late final CliSiTefRepository _repository;
  late final CliSiTefCoreService _coreService;
  late final PinPadService _pinpadService;

  final CliSiTefConfig _config;
  bool _isInitialized = false;
  String? _currentSessionId;

  ClisitefCancelamentoService({
    required CliSiTefConfig config,
    CliSiTefRepository? repository,
  }) : _config = config {
    _repository = repository ?? CliSiTefRepositoryImpl(config: config);
    _coreService = CliSiTefCoreService(
      repository: _repository,
      config: config,
    );
    _pinpadService = PinPadService(
      repository: _repository,
      config: config,
    );
  }

  final ValueNotifier<String> _messageDisplay = ValueNotifier('');
  ValueNotifier<String> get messageDisplay => _messageDisplay;

  Future<String> _createSession() async {
    await _deleteSession();
    final sessionResponse = await _repository.createSession();

    if (!sessionResponse.isServiceSuccess) {
      throw CliSiTefException.fromCode(
        sessionResponse.clisitefStatus,
        details: 'Erro ao criar sessão: ${sessionResponse.errorMessage}',
        originalError: sessionResponse,
      );
    }

    _currentSessionId = sessionResponse.sessionId;
    return _currentSessionId!;
  }

  Future<void> _deleteSession() async {
    if (_currentSessionId == null) return;

    await _repository.deleteSession();
    _currentSessionId = null;
  }

  /// Inicializa o serviço
  Future<void> initialize() async {
    if (_isInitialized) return;

    await _coreService.configure();
    _isInitialized = true;
  }

  @visibleForTesting
  bool hasInteraction(int commandId) {
    return commandId == 21 || commandId == 34 || commandId == 30;
  }

  /// Inicia uma transação e retorna um modelo pendente
  /// A transação NÃO é finalizada automaticamente
  Future<bool> start(CancelationData data) async {
    if (!_isInitialized) {
      throw CliSiTefException.serviceNotInitialized(
        details: 'Serviço não foi inicializado antes de iniciar transação',
      );
    }

    try {
      final sessionId = await _createSession();

      final dataWithSessionId = data.copyWith(sessionId: sessionId, functionId: 110);

      await _repository.startTransaction(dataWithSessionId);

      String responseData = '';
      int commandId = 0;
      int fieldId = 1000000000;

      // Primeira chamada continueTransaction para iniciar o fluxo
      final firstResponse = await _repository.continueTransaction(
        sessionId: sessionId,
        command: 0,
        data: '',
      );

      commandId = firstResponse.command ?? -1;
      fieldId = firstResponse.fieldType ?? 1000000000;
      responseData = '';

      while (commandId != 0 && fieldId != 0) {
        final response = await _repository.continueTransaction(sessionId: sessionId, command: commandId, data: responseData);

        commandId = response.command ?? -10;
        fieldId = response.fieldType ?? -10;
        print('commandId: $commandId\nfieldId: $fieldId');

        if (fieldId == -1) {
          _messageDisplay.value = response.buffer ?? '';
        }

        final hasInteraction0 = hasInteraction(commandId);
        if (hasInteraction0) {
          if (commandId == 21 && fieldId == -1) {
            responseData = processMinusOne(response.buffer ?? '', data);
          } else {
            responseData = process21OR34(fieldId: fieldId, data: data);
          }
        } else {
          responseData = '';
        }
      }

      await _repository.finishTransaction(
        sessionId: sessionId,
        confirm: false, // false = cancelar, true = confirmar
        taxInvoiceNumber: data.taxInvoiceNumber,
        taxInvoiceDate: data.taxInvoiceDate.toString().replaceAll('-', '').substring(0, 8), // YYYYMMDD
        taxInvoiceTime: data.taxInvoiceTime.toString().substring(11, 17).replaceAll(':', ''), // HHMMSS
      );

      return true;
    } catch (e) {
      throw CliSiTefException.internalError(
        details: 'Erro ao iniciar transação: $e',
        originalError: e,
      );
    }
  }

  @visibleForTesting
  String processMinusOne(String buffer, CancelationData data) {
    buffer = buffer.toLowerCase().trim();

    if (buffer.contains("teste de comunicacao")) {
      //21;-1 1:Teste de comunicacao;2:Reimpressao de comprovante;3:Cancelamento de transacao;4:Pre-autorizacao;5:Consulta parcelas CDC;6:Consulta Private Label;7:Consulta saque e saque Fininvest;8:Consulta Saldo Debito;9:Consulta Saldo Credito;10:Outros Cielo;11:Carga forcada de tabelas no pinpad (Servidor);12:Consulta Saque Parcelado;13:Consulta Parcelas Cred. Conductor;14:Consulta Parcelas Cred. MarketPay;15:Saque Carteira Digital;16:Recarga Carteira Digital;17:Consulta Saldo Carteira Dig
      return '3';
    }
    if (buffer.contains('magnetico')) {
      return '1';
    }

    if (buffer.contains("pix")) {
      final options = buffer.split(';');
      final option = options.firstWhere(
        (e) => !e.contains('troco'),
        orElse: () => options.isNotEmpty ? options.first : '',
      );
      final onlyNumber = RegExp(r'\d+').firstMatch(option)?.group(0);
      return onlyNumber ?? '1';
    }

    if (buffer.contains("cancelamento de cartao de debito")) {
      final method = PaymentMethod.fromCode(data.functionId);
      if (method == PaymentMethod.DEBITO) {
        return '1';
      }
      if (method == PaymentMethod.CREDITO) {
        return '2';
      }
      if (method == PaymentMethod.PIX) {
        return '10';
      }
    }

    return '';
  }

  @visibleForTesting
  String process21OR34({required int fieldId, required CancelationData data}) {
    switch (fieldId) {
      case 500:
        // Código do supervisor
        return "123456";
      case 516:
        // NSU host
        return data.nsuHost;
      case 515:
        // Data da transação (ddmmaaaa)
        return FormatUtils.formatDate(data.dateTime);
      case 146:
        // Valor da transação
        return FormatUtils.formatAmount(data.trnAmount);
      default:
        return "";
    }
  }

  /// Verifica se o serviço está inicializado
  bool get isInitialized => _isInitialized;

  /// Obtém o ID da sessão atual
  String? get currentSessionId => _currentSessionId;

  /// Obtém a configuração
  CliSiTefConfig get config => _config;

  /// Obtém o serviço core
  CliSiTefCoreService get coreService => _coreService;

  /// Obtém o serviço PinPad
  PinPadService get pinpadService => _pinpadService;

  /// Obtém a versão do SDK
  String get version => '1.0.0';

  /// Obtém o repositório (para controle manual do fluxo)
  CliSiTefRepository get repository => _repository;

  /// Obtém o serviço de PinPad (para operações avançadas)
  PinPadService get pinpadResetService => _pinpadService;

  Future<void> dispose() async {
    try {
      if (_currentSessionId != null) {
        await _repository.deleteSession();
        _currentSessionId = null;
      }

      _isInitialized = false;
    } catch (e) {
      throw CliSiTefException.internalError(
        details: 'Erro ao finalizar serviço: $e',
        originalError: e,
      );
    }
  }
}
