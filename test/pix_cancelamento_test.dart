import 'package:flutter_test/flutter_test.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/cancelation_data.dart';

/// Teste focado apenas no cancelamento PIX
void main() {
  group('🔵 Teste PIX - Cancelamento Simples', () {
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

    test('Deve processar seleção PIX corretamente', () {
      // Arrange
      const buffer = '1:PIX;2:Débito;3:Crédito;4:Troco;';
      final data = _createPixCancelationData();

      // Act
      final result = service.processMinusOne(buffer, data);

      // Assert
      expect(result, equals('1')); // Deve selecionar PIX (opção 1)
      print('✅ PIX selecionado corretamente: $result');
    });

    test('Deve processar cancelamento PIX específico', () {
      // Arrange
      const buffer = 'cancelamento de cartao de debito';
      final data = _createPixCancelationData();

      // Act
      final result = service.processMinusOne(buffer, data);

      // Assert
      expect(result, equals('10')); // Deve retornar opção 10 para PIX
      print('✅ Cancelamento PIX retornou: $result');
    });

    test('Deve inicializar e processar PIX completo (método original)', () async {
      // Arrange
      await service.initialize();
      final pixData = _createPixCancelationData(
        amount: 50.00,
        invoiceNumber: 'PIX002',
      );

      // Act
      final result = await service.start(pixData);

      // Assert
      expect(result, isTrue);
      expect(service.currentSessionId, isNotNull);
      print('✅ PIX cancelamento completo: $result');
    });

    test('Deve processar fieldIds específicos do PIX', () {
      // Act & Assert
      expect(service.process21OR34(146), equals('100')); // Valor
      expect(service.process21OR34(500), equals('123456')); // Supervisor
      expect(service.process21OR34(515), equals('20250101')); // Data
      expect(service.process21OR34(516), equals('NUMERO_DOCUMENTO')); // NSU

      print('✅ FieldIds PIX processados corretamente');
    });

    test('Deve identificar comandos interativos do PIX', () {
      // Act & Assert
      expect(service.hasInteraction(21), isTrue); // Menu
      expect(service.hasInteraction(34), isTrue); // Valor Monetário
      expect(service.hasInteraction(30), isTrue); // Campo Genérico
      expect(service.hasInteraction(14), isFalse); // Aguardar
      expect(service.hasInteraction(0), isFalse); // Exibir Mensagem

      print('✅ Comandos interativos PIX identificados');
    });
  });
}

/// Helper específico para dados PIX
CancelationData _createPixCancelationData({
  double amount = 100.00,
  String invoiceNumber = 'PIX123456',
  String operator = 'CAIXA',
}) {
  final now = DateTime.now();

  return CancelationData(
    functionId: 122, // PIX específico
    trnAmount: amount,
    taxInvoiceNumber: invoiceNumber,
    taxInvoiceDate: now,
    taxInvoiceTime: now,
    cashierOperator: operator,
    trnAdditionalParameters: <String, String>{
      'method': 'PIX',
      'test_mode': 'true',
    },
    trnInitParameters: <String, String>{
      'version': '1.0.0',
      'environment': 'test',
    },
    sessionId: '', // Será preenchido automaticamente
    dateTime: now,
    docNumber: invoiceNumber,
  );
}
