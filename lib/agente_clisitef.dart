library agente_clisitef;

import 'package:agente_clisitef/src/models/agente_clisitef_config.dart';
import 'package:agente_clisitef/src/repositories/agente_clisitef_repository.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:agente_clisitef/src/services/client/clien_exports.dart';
import 'package:agente_clisitef/src/services/pdv_digitado_service.dart';
import 'package:agente_clisitef/src/services/pdv_pinpad_service.dart';
import 'package:dio/dio.dart';
export './src/enums/function_id.dart';
export './src/models/agente_clisitef_config.dart';
export './src/models/data_events.dart';
export './src/models/comand_events.dart';
export './src/services/pdv_pinpad_service.dart';
export './src/models/transaction.dart';
export './src/models/payment_status.dart';

AgenteClisitefConfig? _agenteClisitefConfig;
IClient? _clisitefClient;
IAgenteClisitefRepository? _agenteClisitefRepository;
PdvDigitadoService? _pdvDigitadoService;
PdvPinpadService? _pdvPinpadService;

class AgenteClisitef {
  static initialize(AgenteClisitefConfig config) {
    _agenteClisitefConfig = config;

    _clisitefClient = ClientDio(
      baseOptions: BaseOptions(
        baseUrl: _agenteClisitefConfig!.agenteIp,
      ),
      enableLogs: config.enableLogs,
      clearLogInDays: config.clearLogsInDays,
      saveLogsInDirectory: config.saveLogsInDirectory,
    );

    _agenteClisitefRepository = AgenteClisitefRepository(client: _clisitefClient!);
  }

  static AgenteClisitefConfig get config {
    assert(_agenteClisitefConfig != null, 'Call AgenteClisitef.initialize(AgenteClisitefConfig) before using agenteClisitefConfig');
    return _agenteClisitefConfig!;
  }

  static IClient get client {
    assert(_clisitefClient != null, 'Call AgenteClisitef.initialize(AgenteClisitefConfig) before using clisitefClient');
    return _clisitefClient!;
  }
  //getFild

  static IAgenteClisitefRepository get instance {
    assert(_agenteClisitefRepository != null, 'Call AgenteClisitef.initialize(AgenteClisitefConfig) before using agenteClisitefRepository');
    return _agenteClisitefRepository!;
  }

  static PdvPinpadService get pdvPinpad {
    return _pdvPinpadService ??= PdvPinpadService(agenteClisitefRepository: instance, config: config);
  }

  static PdvDigitadoService get pdvDigitado {
    return _pdvDigitadoService ??= PdvDigitadoService(agenteClisitefRepository: instance, config: config);
  }
}
