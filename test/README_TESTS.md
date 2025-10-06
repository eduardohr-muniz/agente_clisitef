# 🧪 Testes do ClisitefCancelamentoService

Este diretório contém os testes unitários e E2E para o serviço de cancelamento do CliSiTef.

## 📋 Visão Geral

Os testes cobrem:

- ✅ **Inicialização** e configuração do serviço
- ✅ **Processamento de comandos** CliSiTef
- ✅ **Processamento de fieldIds** específicos
- ✅ **Fluxo completo** de cancelamento
- ✅ **Tratamento de erros** e validações
- ✅ **Limpeza de recursos** e dispose

## 🚀 Como Executar

### 1. Testes Unitários (Flutter Test)

```bash
# Executar todos os testes
flutter test test/clisitef_cancelamento_service_test.dart

# Executar com verbose
flutter test test/clisitef_cancelamento_service_test.dart --verbose

# Executar apenas um grupo específico
flutter test test/clisitef_cancelamento_service_test.dart --name "Processamento de Comandos"
```

### 2. Teste Manual (Script Dart)

```bash
# Executar script de teste manual
dart test/run_tests.dart

# Executar com permissões (Linux/Mac)
chmod +x test/run_tests.dart
./test/run_tests.dart
```

## 📊 Estrutura dos Testes

### 🔧 Inicialização e Configuração

- **Criação de instância**: Valida se o serviço é criado corretamente
- **Inicialização**: Testa o processo de inicialização
- **Configuração**: Verifica se as configurações são aplicadas

### 🔄 Processamento de Comandos

- **Comando -1**: Processamento de menus e seleções
- **Comando 21**: Menus de opções
- **Comando 30**: Coleta de campos genéricos
- **Comando 34**: Coleta de valores monetários

### 📊 Processamento de FieldIds

- **FieldId 146**: Valor da transação
- **FieldId 500**: Código do supervisor
- **FieldId 515**: Data da transação
- **FieldId 516**: Número do documento/NSU

### 💰 Fluxo de Cancelamento E2E

- **Cancelamento PIX**: Testa cancelamento de transação PIX
- **Cancelamento Débito**: Testa cancelamento de cartão de débito
- **Cancelamento Crédito**: Testa cancelamento de cartão de crédito

### ⚡ Tratamento de Erros

- **Dados inválidos**: Valida tratamento de dados incorretos
- **Método inválido**: Testa comportamento com métodos não suportados
- **Sessão inválida**: Verifica tratamento de sessões inválidas

### 🧹 Limpeza e Dispose

- **Limpeza de recursos**: Verifica se recursos são liberados
- **Múltiplas inicializações**: Testa reinicialização do serviço

## 🎯 Exemplo de Uso

```dart
// Exemplo básico de teste
void main() {
  test('Deve processar cancelamento PIX', () async {
    // Arrange
    final service = ClisitefCancelamentoService(config: config);
    await service.coreService.initialize();
    service._isInitialized = true;
    
    final cancelationData = CancelationData(
      functionId: 101,
      trnAmount: 150.00,
      taxInvoiceNumber: '123456',
      taxInvoiceDate: DateTime.now(),
      taxInvoiceTime: DateTime.now(),
      cashierOperator: 'CAIXA',
      trnAdditionalParameters: {'method': 'PIX'},
      trnInitParameters: {},
      sessionId: '',
      dateTime: DateTime.now(),
      docNumber: '123456',
    );

    // Act
    final result = await service.start(cancelationData);

    // Assert
    expect(result, isTrue);
    expect(service.currentSessionId, isNotNull);
    
    // Cleanup
    await service.dispose();
  });
}
```

## 🔍 Cenários de Teste

### Testes Unitários

1. **Criação de Instância**
   - Valida criação correta do serviço
   - Verifica configurações iniciais

2. **Processamento de Comandos**
   - Testa `_processMinusOne()` com diferentes buffers
   - Valida seleção de métodos de pagamento

3. **Processamento de FieldIds**
   - Testa `_process21OR34()` com diferentes fieldIds
   - Verifica retorno correto de valores

4. **Validação de Interação**
   - Testa `_hasInteraction()` com diferentes commandIds
   - Verifica identificação de comandos interativos

### Testes E2E

1. **Fluxo Completo de Cancelamento**
   - Inicialização do serviço
   - Criação de sessão
   - Processamento iterativo
   - Finalização da transação

2. **Diferentes Métodos de Pagamento**
   - PIX
   - Cartão de Débito
   - Cartão de Crédito

3. **Cenários de Erro**
   - Dados inválidos
   - Métodos não suportados
   - Falhas de sessão

## 📝 Dados de Teste

Os testes utilizam dados de exemplo configurados no helper `_createTestCancelationData()`:

```dart
CancelationData _createTestCancelationData({
  String method = 'PIX',
  double amount = 100.00,
  String invoiceNumber = '123456',
  String operator = 'CAIXA',
}) {
  // Cria dados de teste com valores padrão
  // que podem ser sobrescritos conforme necessário
}
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Serviço não inicializa**
   - Verifique se o CliSiTef está rodando
   - Confirme as configurações de IP e porta

2. **Timeout nos testes**
   - Aumente o timeout se necessário
   - Verifique a conectividade de rede

3. **Falha na criação de sessão**
   - Verifique se o storeId está correto
   - Confirme se o terminalId é válido

### Logs de Debug

Para habilitar logs detalhados:

```bash
# Executar com logs detalhados
flutter test test/clisitef_cancelamento_service_test.dart --verbose

# Executar script com debug
dart test/run_tests.dart
```

## 📈 Métricas de Performance

Os testes incluem validações de performance:

- ⏱️ **Tempo de processamento** < 30 segundos
- 💾 **Uso de memória** controlado
- 🔄 **Múltiplas transações** eficientes

## 🔧 Configuração

### Configurações de Teste

```dart
final config = CliSiTefConfig(
  sitefIp: '127.0.0.1',
  storeId: '00000000',
  terminalId: 'REST0001',
  cashierOperator: 'CAIXA',
  trnAdditionalParameters: {},
  trnInitParameters: {},
);
```

### Variáveis de Ambiente

```bash
# Configurar variáveis de ambiente (opcional)
export CLISITEF_IP="127.0.0.1"
export CLISITEF_STORE_ID="00000000"
export CLISITEF_TERMINAL_ID="REST0001"
export CLISITEF_OPERATOR="CAIXA"
```

## 📚 Documentação Relacionada

- [Documentação do CliSiTef](../../docs/)
- [Guia de Configuração](../../README.md)
- [Exemplos de Uso](../../example/)

## 🤝 Contribuindo

Para adicionar novos testes:

1. **Identifique o cenário** a ser testado
2. **Crie o teste** no grupo apropriado
3. **Use dados de teste** consistentes
4. **Execute os testes** para validar
5. **Documente** o novo teste

---

**Nota**: Estes testes requerem um servidor CliSiTef ativo e configurado corretamente para os testes E2E.
