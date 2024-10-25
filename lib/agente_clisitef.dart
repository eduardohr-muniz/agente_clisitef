library agente_clisitef;

import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/models/agente_clisitef_config.dart';
import 'package:agente_clisitef/src/repositories/agente_clisitef_repository.dart';
import 'package:agente_clisitef/src/repositories/i_agente_clisitef_repository.dart';
import 'package:agente_clisitef/src/services/client/clien_exports.dart';
import 'package:dio/dio.dart';

AgenteClisitefConfig? _agenteClisitefConfig;
IClient? _clisitefClient;
IAgenteClisitefRepository? _agenteClisitefRepository;

class AgenteClisitef {
  static initialize(AgenteClisitefConfig config) {
    _agenteClisitefConfig = config;
    _clisitefClient = ClientDio(baseOptions: BaseOptions(baseUrl: _agenteClisitefConfig!.agenteIp));
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

  static IAgenteClisitefRepository get instance {
    assert(_agenteClisitefRepository != null, 'Call AgenteClisitef.initialize(AgenteClisitefConfig) before using agenteClisitefRepository');
    return _agenteClisitefRepository!;
  }
}
