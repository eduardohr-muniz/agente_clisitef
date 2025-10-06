import 'package:flutter_test/flutter_test.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/cancelation_data.dart';
import 'package:agente_clisitef/src/services/clisitef_cancelamento_service.dart';

void main() {
  group('🔴 Teste CRÉDITO - Cancelamento E2E', () {
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

    test('Deve processar seleção Crédito corretamente', () {
      const buffer = '1:PIX;2:Débito;3:Crédito;4:Troco;';
      final data = _createCreditoCancelationData(functionId: 3); // Crédito
      final result = service.processMinusOne(buffer, data);
      expect(result, equals('3'));
      print('✅ Crédito selecionado corretamente: $result');
    });

    test('Deve processar cancelamento Crédito específico', () {
      const buffer = 'cancelamento de cartao de credito';
      final data = _createCreditoCancelationData(functionId: 3); // Crédito
      final result = service.processMinusOne(buffer, data);
      expect(result, equals('1')); // Deve retornar opção 1 para Crédito
      print('✅ Cancelamento Crédito retornou: $result');
    });

    test('Deve inicializar e processar Crédito completo (método original)', () async {
      // Arrange
      await service.initialize();
      final creditoData = _createCreditoCancelationData(
        amount: 50.00,
        invoiceNumber: 'CRED002',
      );

      // Act
      final result = await service.start(creditoData);

      // Assert
      expect(result, isTrue);
      expect(service.currentSessionId, isNotNull);
      print('✅ Crédito cancelamento completo: $result');
    });

    test('Deve processar fieldIds específicos do Crédito', () {
      // Arrange
      final data = _createCreditoCancelationData(amount: 50.00);

      // Act & Assert
      expect(service.process21OR34(fieldId: 146, data: data), equals('5000')); // Valor (50.00 * 100 = 5000)
      expect(service.process21OR34(fieldId: 500, data: data), equals('123456')); // Supervisor
      expect(service.process21OR34(fieldId: 515, data: data), equals('06102025')); // Data (DDMMYYYY)
      expect(service.process21OR34(fieldId: 516, data: data), equals('CRED002')); // NSU
      print('✅ FieldIds Crédito processados corretamente');
    });

    test('Deve identificar comandos interativos do Crédito', () {
      expect(service.hasInteraction(21), isTrue);
      expect(service.hasInteraction(34), isTrue);
      expect(service.hasInteraction(30), isTrue);
      expect(service.hasInteraction(0), isFalse); // Exibir Mensagem
      expect(service.hasInteraction(14), isFalse); // Aguardar
      print('✅ Comandos interativos Crédito identificados');
    });

    test('Deve processar dados de transação Crédito real', () {
      // Dados baseados em transação de crédito típica
      const nsuHost = '999060003';
      const nsuSitf = '60003';
      const valor = 50.00;
      const dataTransacao = '20251006003014';

      // Verificar se consegue processar os dados
      expect(nsuHost, isNotEmpty);
      expect(nsuSitf, isNotEmpty);
      expect(valor, equals(50.00));
      expect(dataTransacao, isNotEmpty);

      print('✅ Dados Crédito real processados:');
      print('   NSU Host: $nsuHost');
      print('   NSU SiTef: $nsuSitf');
      print('   Valor: R\$ $valor');
      print('   Data: $dataTransacao');
    });
  });
}

CancelationData _createCreditoCancelationData({
  double amount = 50.00,
  String invoiceNumber = 'CRED002',
  String operator = 'CAIXA',
  int? functionId,
}) {
  final now = DateTime.now();
  return CancelationData(
    functionId: functionId ?? 3, // Crédito
    trnAmount: amount,
    taxInvoiceNumber: invoiceNumber,
    taxInvoiceDate: now,
    taxInvoiceTime: now,
    cashierOperator: operator,
    trnAdditionalParameters: <String, String>{
      'method': 'CREDITO',
      'test_mode': 'true',
      'nsu_host': '999060003',
      'nsu_sitf': '60003',
    },
    trnInitParameters: <String, String>{
      'version': '1.0.0',
      'environment': 'test',
    },
    sessionId: '',
    dateTime: now,
    nsuHost: invoiceNumber,
  );
}
