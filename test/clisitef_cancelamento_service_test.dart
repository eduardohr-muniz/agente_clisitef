import 'package:flutter_test/flutter_test.dart';
import 'package:agente_clisitef/agente_clisitef.dart';

/// Testes Unitários e E2E para o ClisitefCancelamentoService
///
/// Este arquivo contém testes completos para validar o funcionamento
/// do serviço de cancelamento, incluindo cenários reais de uso.
void main() {
  group('🧪 ClisitefCancelamentoService Tests', () {
    late ClisitefCancelamentoService service;
    late CliSiTefConfig config;

    setUp(() {
      // Configuração para testes
      config = const CliSiTefConfig(
        sitefIp: '127.0.0.1',
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

    group('🔧 Inicialização e Configuração', () {
      test('Deve criar instância do serviço corretamente', () {
        // Arrange & Act
        final service = ClisitefCancelamentoService(config: config);

        // Assert
        expect(service, isNotNull);
        expect(service.config, equals(config));
        expect(service.version, equals('1.0.0'));
        expect(service.isInitialized, isFalse);
        expect(service.currentSessionId, isNull);
      });

      test('Deve inicializar o serviço corretamente', () async {
        // Arrange & Act
        await service.initialize();

        // Assert
        expect(service.isInitialized, isTrue);
        expect(service.config, equals(config));
        expect(service.version, equals('1.0.0'));
      });

      test('Deve lançar exceção se tentar usar serviço não inicializado', () async {
        // Arrange
        final cancelationData = _createTestCancelationData();

        // Act & Assert
        expect(
          () => service.start(cancelationData),
          throwsA(isA<CliSiTefException>()),
        );
      });
    });

    group('🔄 Processamento de Comandos', () {
      test('Deve processar comando -1 (Menu Principal) corretamente', () {
        // Arrange
        const buffer = '1:Teste de comunicacao;2:Reimpressao de comprovante;3:Cancelamento de transacao;4:Pre-autorizacao;';
        final data = _createTestCancelationData(functionId: 122); // PIX

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('3')); // Deve selecionar cancelamento
      });

      test('Deve processar seleção PIX corretamente', () {
        // Arrange
        const buffer = '1:PIX;2:Débito;3:Crédito;4:Troco;';
        final data = _createTestCancelationData(functionId: 122); // PIX

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('1')); // Deve selecionar PIX
      });

      test('Deve processar seleção Débito corretamente', () {
        // Arrange
        const buffer = '1:PIX;2:Débito;3:Crédito;4:Troco;';
        final data = _createTestCancelationData(functionId: 4); // DEBITO

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('2')); // Deve selecionar Débito
      });

      test('Deve processar seleção Crédito corretamente', () {
        // Arrange
        const buffer = '1:PIX;2:Débito;3:Crédito;4:Troco;';
        final data = _createTestCancelationData(functionId: 3); // CREDITO

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('3')); // Deve selecionar Crédito
      });

      test('Deve processar cancelamento de cartão de débito', () {
        // Arrange
        const buffer = 'cancelamento de cartao de debito';
        final data = _createTestCancelationData(functionId: 4); // DEBITO

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('1')); // Deve retornar opção 1 para débito
      });

      test('Deve processar cancelamento de cartão de crédito', () {
        // Arrange
        const buffer = 'cancelamento de cartao de debito';
        final data = _createTestCancelationData(functionId: 3); // CREDITO

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('2')); // Deve retornar opção 2 para crédito
      });

      test('Deve processar cancelamento PIX', () {
        // Arrange
        const buffer = 'cancelamento de cartao de debito';
        final data = _createTestCancelationData(functionId: 122); // PIX

        // Act
        final result = service.processMinusOne(buffer, data);

        // Assert
        expect(result, equals('10')); // Deve retornar opção 10 para PIX
      });
    });

    group('📊 Processamento de FieldIds', () {
      test('Deve processar fieldId 146 (Valor) corretamente', () {
        // Act
        final result = service.process21OR34(146);

        // Assert
        expect(result, equals('100'));
      });

      test('Deve processar fieldId 500 (Supervisor) corretamente', () {
        // Act
        final result = service.process21OR34(500);

        // Assert
        expect(result, equals('123456'));
      });

      test('Deve processar fieldId 515 (Data) corretamente', () {
        // Act
        final result = service.process21OR34(515);

        // Assert
        expect(result, equals('20250101'));
      });

      test('Deve processar fieldId 516 (NSU) corretamente', () {
        // Act
        final result = service.process21OR34(516);

        // Assert
        expect(result, equals('NUMERO_DOCUMENTO'));
      });

      test('Deve retornar string vazia para fieldId desconhecido', () {
        // Act
        final result = service.process21OR34(999);

        // Assert
        expect(result, equals(''));
      });
    });

    group('🔍 Validação de Interação', () {
      test('Deve identificar comando 21 como interativo', () {
        // Act
        final result = service.hasInteraction(21);

        // Assert
        expect(result, isTrue);
      });

      test('Deve identificar comando 34 como interativo', () {
        // Act
        final result = service.hasInteraction(34);

        // Assert
        expect(result, isTrue);
      });

      test('Deve identificar comando 30 como interativo', () {
        // Act
        final result = service.hasInteraction(30);

        // Assert
        expect(result, isTrue);
      });

      test('Deve identificar comando 14 como não interativo', () {
        // Act
        final result = service.hasInteraction(14);

        // Assert
        expect(result, isFalse);
      });

      test('Deve identificar comando 0 como não interativo', () {
        // Act
        final result = service.hasInteraction(0);

        // Assert
        expect(result, isFalse);
      });
    });

    group('💰 Fluxo de Cancelamento E2E', () {
      setUp(() async {
        // Inicializar serviço para testes E2E
        await service.initialize();
      });

      test('Deve processar cancelamento PIX completo', () async {
        // Arrange
        final cancelationData = _createTestCancelationData(
          method: 'PIX',
          amount: 150.00,
          invoiceNumber: '123456',
          functionId: 122, // PIX
        );

        // Act
        final result = await service.start(cancelationData);

        // Assert
        expect(result, isTrue);
        expect(service.currentSessionId, isNotNull);
      });

      test('Deve processar cancelamento de cartão de débito', () async {
        // Arrange
        final cancelationData = _createTestCancelationData(
          method: 'DEBITO',
          amount: 200.00,
          invoiceNumber: '789012',
          functionId: 4, // DEBITO
        );

        // Act
        final result = await service.start(cancelationData);

        // Assert
        expect(result, isTrue);
        expect(service.currentSessionId, isNotNull);
      });

      test('Deve processar cancelamento de cartão de crédito', () async {
        // Arrange
        final cancelationData = _createTestCancelationData(
          method: 'CREDITO',
          amount: 300.00,
          invoiceNumber: '345678',
          functionId: 3, // CREDITO
        );

        // Act
        final result = await service.start(cancelationData);

        // Assert
        expect(result, isTrue);
        expect(service.currentSessionId, isNotNull);
      });
    });

    group('⚡ Tratamento de Erros', () {
      setUp(() async {
        await service.initialize();
      });

      test('Deve tratar erro de dados inválidos', () async {
        // Arrange
        final invalidData = CancelationData(
          functionId: 999, // Função inválida
          trnAmount: -100, // Valor negativo
          taxInvoiceNumber: '', // Número vazio
          taxInvoiceDate: DateTime.now(),
          taxInvoiceTime: DateTime.now(),
          cashierOperator: '',
          trnAdditionalParameters: <String, String>{},
          trnInitParameters: <String, String>{},
          sessionId: '',
          dateTime: DateTime.now(),
          docNumber: '',
        );

        // Act & Assert
        expect(
          () => service.start(invalidData),
          throwsA(isA<CliSiTefException>()),
        );
      });

      test('Deve tratar erro de método de pagamento inválido', () async {
        // Arrange
        final invalidData = _createTestCancelationData(
          method: 'INVALID_METHOD',
          amount: 100.00,
          invoiceNumber: 'TEST001',
          functionId: 999, // Código inválido
        );

        // Act & Assert
        expect(
          () => service.start(invalidData),
          throwsA(isA<CliSiTefException>()),
        );
      });
    });

    group('🧹 Limpeza e Dispose', () {
      test('Deve limpar recursos corretamente', () async {
        // Arrange
        await service.initialize();
        // Simular sessão ativa para teste

        // Act
        await service.dispose();

        // Assert
        expect(service.isInitialized, isFalse);
        expect(service.currentSessionId, isNull);
      });

      test('Deve permitir múltiplas inicializações/disposes', () async {
        // Arrange & Act
        await service.initialize();
        expect(service.isInitialized, isTrue);

        await service.dispose();
        expect(service.isInitialized, isFalse);

        await service.initialize();

        // Assert
        expect(service.isInitialized, isTrue);
      });
    });

    group('📊 Cenários de Integração', () {
      setUp(() async {
        await service.initialize();
      });

      test('Deve processar sequência completa de cancelamento', () async {
        // Arrange
        final testCases = [
          {'method': 'PIX', 'amount': 50.00, 'invoice': '001', 'functionId': 122},
          {'method': 'DEBITO', 'amount': 75.00, 'invoice': '002', 'functionId': 4},
          {'method': 'CREDITO', 'amount': 100.00, 'invoice': '003', 'functionId': 3},
        ];

        // Act & Assert
        for (final testCase in testCases) {
          final data = _createTestCancelationData(
            method: testCase['method'] as String,
            amount: testCase['amount'] as double,
            invoiceNumber: testCase['invoice'] as String,
            functionId: testCase['functionId'] as int,
          );

          final result = await service.start(data);
          expect(result, isTrue, reason: 'Falha no método ${testCase['method']}');
        }
      });

      test('Deve manter estado consistente entre transações', () async {
        // Arrange
        final data1 = _createTestCancelationData(invoiceNumber: 'TEST001');
        final data2 = _createTestCancelationData(invoiceNumber: 'TEST002');

        // Act
        final result1 = await service.start(data1);
        final result2 = await service.start(data2);

        // Assert
        expect(result1, isTrue);
        expect(result2, isTrue);
        expect(service.isInitialized, isTrue);
        expect(service.currentSessionId, isNotNull);
      });
    });

    group('🎯 Testes de Performance', () {
      setUp(() async {
        await service.initialize();
      });

      test('Deve processar cancelamento dentro do tempo limite', () async {
        // Arrange
        final cancelationData = _createTestCancelationData();

        // Act
        final stopwatch = Stopwatch()..start();
        final result = await service.start(cancelationData);
        stopwatch.stop();

        // Assert
        expect(result, isTrue);
        expect(stopwatch.elapsedMilliseconds, lessThan(30000)); // 30 segundos
      });

      test('Deve processar múltiplos cancelamentos eficientemente', () async {
        // Arrange
        final cancelationData = _createTestCancelationData();
        final stopwatch = Stopwatch()..start();

        // Act
        for (int i = 0; i < 3; i++) {
          await service.start(cancelationData);
        }
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(90000)); // 90 segundos para 3 transações
      });
    });
  });
}

/// Helper para criar dados de teste de cancelamento
CancelationData _createTestCancelationData({
  String method = 'PIX',
  double amount = 100.00,
  String invoiceNumber = '123456',
  String operator = 'CAIXA',
  int? functionId,
}) {
  final now = DateTime.now();

  return CancelationData(
    functionId: functionId ?? 101, // Cancelamento de venda com cartão Qualidade
    trnAmount: amount,
    taxInvoiceNumber: invoiceNumber,
    taxInvoiceDate: now,
    taxInvoiceTime: now,
    cashierOperator: operator,
    trnAdditionalParameters: <String, String>{
      'method': method,
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
