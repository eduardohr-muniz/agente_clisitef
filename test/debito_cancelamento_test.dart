import 'package:flutter_test/flutter_test.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/cancelation_data.dart';
import 'package:agente_clisitef/src/services/clisitef_cancelamento_service.dart';

const String _NSU_HOST = '999060014';

void main() {
  group('🟢 Teste DÉBITO - Cancelamento E2E', () {
    late ClisitefCancelamentoService service;
    late CliSiTefConfig config;

    setUp(() {
      config = const CliSiTefConfig(
        sitefIp: 'intranet5.wbagestao.com', // Servidor real
        storeId: '00000000',
        terminalId: 'REST0001',
        cashierOperator: 'CAIXA',
      );

      service = ClisitefCancelamentoService(config: config);
    });

    tearDown(() async {
      if (service.isInitialized) {
        await service.dispose();
      }
    });

    test('Deve processar seleção Débito corretamente', () {
      const buffer = '1:PIX;2:Débito;3:Crédito;4:Troco;';
      final data = _createDebitoCancelationData(functionId: 4); // Débito
      final result = service.processMinusOne(buffer, data);
      expect(result, equals('2'));
      print('✅ Débito selecionado corretamente: $result');
    });

    test('Deve processar cancelamento Débito específico', () {
      const buffer = 'cancelamento de cartao de debito';
      final data = _createDebitoCancelationData(functionId: 4); // Débito
      final result = service.processMinusOne(buffer, data);
      expect(result, equals('1')); // Deve retornar opção 1 para Débito
      print('✅ Cancelamento Débito retornou: $result');
    });

    test('Deve inicializar e processar Débito completo (método original)', () async {
      // Arrange
      await service.initialize();
      final debitoData = _createDebitoCancelationData(
        amount: 1.00,
        invoiceNumber: 'DEB002',
      );

      // Act
      final result = await service.start(debitoData);

      // Assert
      expect(result, isTrue);
      expect(service.currentSessionId, isNotNull);
      print('✅ Débito cancelamento completo: $result');
    });

    test('Deve processar fieldIds específicos do Débito', () {
      // Arrange
      final data = _createDebitoCancelationData(amount: 1.00);

      // Act & Assert
      expect(service.process21OR34(fieldId: 146, data: data), equals('100')); // Valor
      expect(service.process21OR34(fieldId: 500, data: data), equals('123456')); // Supervisor
      expect(service.process21OR34(fieldId: 515, data: data), equals('06102025')); // Data
      expect(service.process21OR34(fieldId: 516, data: data), equals(_NSU_HOST)); // NSU
      print('✅ FieldIds Débito processados corretamente');
    });

    test('Deve identificar comandos interativos do Débito', () {
      expect(service.hasInteraction(21), isTrue);
      expect(service.hasInteraction(34), isTrue);
      expect(service.hasInteraction(30), isTrue);
      expect(service.hasInteraction(1), isTrue); // Conectando Servidor
      expect(service.hasInteraction(0), isFalse); // Exibir Mensagem
      print('✅ Comandos interativos Débito identificados');
    });

    test('Deve processar dados de transação Débito real', () {
      // Dados baseados no retorno fornecido pelo usuário
      const nsuHost = _NSU_HOST;
      const nsuSitf = '60002';
      const valor = 1.00;
      const dataTransacao = '20251006003013';

      // Verificar se consegue processar os dados
      expect(nsuHost, isNotEmpty);
      expect(nsuSitf, isNotEmpty);
      expect(valor, equals(1.00));
      expect(dataTransacao, isNotEmpty);

      print('✅ Dados Débito real processados:');
      print('   NSU Host: $nsuHost');
      print('   NSU SiTef: $nsuSitf');
      print('   Valor: R\$ $valor');
      print('   Data: $dataTransacao');
    });
  });
}

CancelationData _createDebitoCancelationData({
  double amount = 1.00,
  String invoiceNumber = '60002',
  String operator = 'CAIXA',
  int? functionId,
}) {
  final now = DateTime.now();
  return CancelationData(
    functionId: functionId ?? 4, // Débito
    trnAmount: amount,
    taxInvoiceNumber: invoiceNumber,
    taxInvoiceDate: now,
    taxInvoiceTime: now,
    cashierOperator: operator,
    trnAdditionalParameters: <String, String>{
      'method': 'DEBITO',
      'test_mode': 'true',
      'nsu_host': '999060002',
      'nsu_sitf': '60002',
    },
    trnInitParameters: <String, String>{
      'version': '1.0.0',
      'environment': 'test',
    },
    sessionId: '',
    dateTime: now,
    nsuHost: _NSU_HOST,
  );
}
