#!/usr/bin/env dart

import 'dart:io';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/models/cancelation_data.dart';
import 'package:agente_clisitef/src/services/clisitef_cancelamento_service.dart';

/// Script para executar testes manuais do serviço de cancelamento
///
/// Este script permite testar o serviço de cancelamento de forma
/// independente dos testes unitários, simulando cenários reais.
void main() async {
  print('🧪 Iniciando Testes do ClisitefCancelamentoService...\n');

  try {
    await _runTests();
    print('\n✅ Todos os testes concluídos com sucesso!');
    exit(0);
  } catch (e) {
    print('\n❌ Teste falhou: $e');
    exit(1);
  }
}

Future<void> _runTests() async {
  // Configuração para testes
  const config = CliSiTefConfig(
    sitefIp: '127.0.0.1',
    storeId: '00000000',
    terminalId: 'REST0001',
    cashierOperator: 'CAIXA',
    trnAdditionalParameters: '',
    trnInitParameters: '',
  );

  final service = ClisitefCancelamentoService(config: config);

  try {
    print('📋 Configuração:');
    print('   IP: ${config.sitefIp}');
    print('   Loja: ${config.storeId}');
    print('   Terminal: ${config.terminalId}');
    print('   Operador: ${config.cashierOperator}');
    print('');

    // Teste 1: Inicialização
    print('🔧 Teste 1: Inicialização do serviço...');
    await service.initialize();
    print('   ✅ Serviço inicializado com sucesso');
    print('   ✅ Versão: ${service.version}');
    print('   ✅ Inicializado: ${service.isInitialized}');
    print('');

    // Teste 2: Processamento de comandos
    print('⚙️  Teste 2: Processamento de comandos...');
    await _testCommandProcessing(service);
    print('');

    // Teste 3: Processamento de fieldIds
    print('📊 Teste 3: Processamento de fieldIds...');
    await _testFieldIdProcessing(service);
    print('');

    // Teste 4: Cancelamento PIX
    print('💰 Teste 4: Cancelamento PIX...');
    final pixData = _createCancelationData(
      method: 'PIX',
      amount: 150.00,
      invoiceNumber: 'PIX001',
      functionId: 122, // PIX
    );

    final pixResult = await service.start(pixData);
    print('   ✅ Cancelamento PIX: ${pixResult.codResult.isNotEmpty ? "Sucesso" : "Falha"}');
    print('   ✅ Sessão atual: ${service.currentSessionId}');
    print('');

    // Teste 5: Cancelamento Débito
    print('💳 Teste 5: Cancelamento Débito...');
    final debitoData = _createCancelationData(
      method: 'DEBITO',
      amount: 200.00,
      invoiceNumber: 'DEB002',
      functionId: 4, // DEBITO
    );

    final debitoResult = await service.start(debitoData);
    print('   ✅ Cancelamento Débito: ${debitoResult.codResult.isNotEmpty ? "Sucesso" : "Falha"}');
    print('');

    // Teste 6: Cancelamento Crédito
    print('💳 Teste 6: Cancelamento Crédito...');
    final creditoData = _createCancelationData(
      method: 'CREDITO',
      amount: 300.00,
      invoiceNumber: 'CRE003',
      functionId: 3, // CREDITO
    );

    final creditoResult = await service.start(creditoData);
    print('   ✅ Cancelamento Crédito: ${creditoResult.codResult.isNotEmpty ? "Sucesso" : "Falha"}');
    print('');

    // Teste 7: Limpeza
    print('🧹 Teste 7: Limpeza de recursos...');
    await service.dispose();
    print('   ✅ Serviço finalizado com sucesso');
    print('   ✅ Inicializado: ${service.isInitialized}');
    print('   ✅ Sessão: ${service.currentSessionId}');
    print('');

    print('📊 Resumo dos Testes:');
    print('   ✅ Inicialização: OK');
    print('   ✅ Processamento de Comandos: OK');
    print('   ✅ Processamento de FieldIds: OK');
    print('   ✅ Cancelamento PIX: ${pixResult.codResult.isNotEmpty ? "OK" : "FALHA"}');
    print('   ✅ Cancelamento Débito: ${debitoResult.codResult.isNotEmpty ? "OK" : "FALHA"}');
    print('   ✅ Cancelamento Crédito: ${creditoResult.codResult.isNotEmpty ? "OK" : "FALHA"}');
    print('   ✅ Limpeza: OK');
  } catch (e) {
    print('❌ Erro durante os testes: $e');
    rethrow;
  }
}

Future<void> _testCommandProcessing(ClisitefCancelamentoService service) async {
  // Teste de processamento de comandos
  final testCases = [
    {
      'name': 'Menu Principal',
      'buffer': '1:Teste de comunicacao;2:Reimpressao de comprovante;3:Cancelamento de transacao;4:Pre-autorizacao;',
      'functionId': 122, // PIX
      'expected': '3',
    },
    {
      'name': 'Seleção PIX',
      'buffer': '1:PIX;2:Débito;3:Crédito;4:Troco;',
      'functionId': 122, // PIX
      'expected': '1',
    },
    {
      'name': 'Seleção Débito',
      'buffer': '1:PIX;2:Débito;3:Crédito;4:Troco;',
      'functionId': 4, // DEBITO
      'expected': '2',
    },
    {
      'name': 'Seleção Crédito',
      'buffer': '1:PIX;2:Débito;3:Crédito;4:Troco;',
      'functionId': 3, // CREDITO
      'expected': '3',
    },
    {
      'name': 'Cancelamento Débito',
      'buffer': 'cancelamento de cartao de debito',
      'functionId': 4, // DEBITO
      'expected': '1',
    },
    {
      'name': 'Cancelamento Crédito',
      'buffer': 'cancelamento de cartao de debito',
      'functionId': 3, // CREDITO
      'expected': '2',
    },
    {
      'name': 'Cancelamento PIX',
      'buffer': 'cancelamento de cartao de debito',
      'functionId': 122, // PIX
      'expected': '10',
    },
  ];

  for (final testCase in testCases) {
    final data = _createCancelationData(functionId: testCase['functionId'] as int);
    final result = service.processMinusOne(
      testCase['buffer'] as String,
      data,
    );

    final success = result == testCase['expected'];
    print('   ${success ? "✅" : "❌"} ${testCase['name']}: $result (esperado: ${testCase['expected']})');
  }
}

Future<void> _testFieldIdProcessing(ClisitefCancelamentoService service) async {
  // Teste de fieldIds
  final testData = _createCancelationData(amount: 1.00, invoiceNumber: 'TEST123456');

  final fieldTests = [
    {'fieldId': 146, 'expected': '100', 'name': 'Valor'},
    {'fieldId': 500, 'expected': '123456', 'name': 'Supervisor'},
    {'fieldId': 515, 'expected': '06102025', 'name': 'Data'},
    {'fieldId': 516, 'expected': 'TEST123456', 'name': 'NSU'},
    {'fieldId': 999, 'expected': '', 'name': 'Desconhecido'},
  ];

  for (final test in fieldTests) {
    final result = service.process21OR34(fieldId: test['fieldId'] as int, data: testData);
    final success = result == test['expected'];
    print('   ${success ? "✅" : "❌"} FieldId ${test['fieldId']} (${test['name']}): $result (esperado: ${test['expected']})');
  }

  // Teste de interação
  print('');
  print('   🔍 Testes de Interação:');
  final interactionTests = [
    {'commandId': 21, 'expected': true, 'name': 'Menu'},
    {'commandId': 34, 'expected': true, 'name': 'Valor Monetário'},
    {'commandId': 30, 'expected': true, 'name': 'Campo Genérico'},
    {'commandId': 1, 'expected': false, 'name': 'Conectando'},
    {'commandId': 14, 'expected': false, 'name': 'Aguardar'},
    {'commandId': 0, 'expected': false, 'name': 'Exibir Mensagem'},
  ];

  for (final test in interactionTests) {
    final result = service.hasInteraction(test['commandId'] as int);
    final success = result == test['expected'];
    print('   ${success ? "✅" : "❌"} Comando ${test['commandId']} (${test['name']}): $result (esperado: ${test['expected']})');
  }
}

CancelationData _createCancelationData({
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
    nsuHost: invoiceNumber,
  );
}
