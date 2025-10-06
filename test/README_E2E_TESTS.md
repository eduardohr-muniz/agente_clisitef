# 🧪 Testes E2E - Serviço de Cancelamento CliSiTef

Este diretório contém os testes end-to-end (E2E) para o serviço de cancelamento do CliSiTef.

## 📋 Visão Geral

Os testes E2E simulam um fluxo completo de cancelamento de transação, incluindo:

- ✅ **Inicialização** do serviço
- ✅ **Criação de sessão** com o CliSiTef
- ✅ **Processamento iterativo** dos comandos
- ✅ **Cancelamento** de diferentes métodos de pagamento
- ✅ **Limpeza** de recursos

## 🚀 Como Executar

### 1. Testes Unitários (Flutter Test)

```bash
# Executar todos os testes E2E
flutter test test/clisitef_cancelamento_service_e2e_test.dart

# Executar com verbose
flutter test test/clisitef_cancelamento_service_e2e_test.dart --verbose

# Executar apenas um grupo específico
flutter test test/clisitef_cancelamento_service_e2e_test.dart --name "Fluxo de Cancelamento E2E"
```

### 2. Teste Manual (Script Dart)

```bash
# Executar script de teste manual
dart test/run_e2e_test.dart

# Executar com permissões
chmod +x test/run_e2e_test.dart
./test/run_e2e_test.dart
```

## 📊 Cenários de Teste

### 🔧 Inicialização e Configuração

- **Inicialização do serviço**: Verifica se o serviço é inicializado corretamente
- **Configuração**: Valida se as configurações são aplicadas adequadamente
- **Sessão**: Testa criação e gerenciamento de sessões

### 💰 Fluxo de Cancelamento

- **Cancelamento PIX**: Testa cancelamento de transação PIX
- **Cancelamento Débito**: Testa cancelamento de cartão de débito
- **Cancelamento Crédito**: Testa cancelamento de cartão de crédito

### 🔄 Processamento de Comandos

- **Comando 21**: Processamento de menus de seleção
- **Comando 34**: Coleta de valores monetários
- **Comando 30**: Coleta de campos genéricos
- **FieldIds**: Processamento de diferentes tipos de campo

### ⚡ Tratamento de Erros

- **Sessão inválida**: Testa comportamento com sessões inválidas
- **Dados inválidos**: Valida tratamento de dados incorretos
- **Timeout**: Testa comportamento em casos de timeout

### 🧹 Limpeza e Dispose

- **Limpeza de recursos**: Verifica se recursos são liberados corretamente
- **Múltiplas inicializações**: Testa reinicialização do serviço

## 🎯 Estrutura dos Testes

```
test/
├── clisitef_cancelamento_service_e2e_test.dart  # Testes unitários E2E
├── run_e2e_test.dart                           # Script de teste manual
├── e2e_config.yaml                             # Configurações dos testes
└── README_E2E_TESTS.md                         # Este arquivo
```

## 📝 Exemplo de Uso

```dart
// Exemplo básico de teste E2E
void main() {
  test('Deve processar cancelamento PIX completo', () async {
    // Arrange
    final service = CliSiTefServiceCapturaTardia(config: config);
    await service.initialize();
    
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

## 🔍 Debugging

### Logs Detalhados

Para habilitar logs detalhados durante os testes:

```bash
# Executar com logs detalhados
flutter test test/clisitef_cancelamento_service_e2e_test.dart --verbose

# Executar script com debug
dart test/run_e2e_test.dart --debug
```

### Configuração de Log

Edite o arquivo `e2e_config.yaml` para ajustar os níveis de log:

```yaml
logging:
  level: "DEBUG"      # DEBUG, INFO, WARN, ERROR
  verbose: true       # Logs detalhados
  save_to_file: true  # Salvar em arquivo
```

## 🚨 Troubleshooting

### Problemas Comuns

1. **Serviço não inicializa**
   - Verifique se o CliSiTef está rodando
   - Confirme as configurações de IP e porta
   - Verifique se o terminal está configurado corretamente

2. **Timeout nos testes**
   - Aumente o timeout na configuração
   - Verifique a conectividade de rede
   - Confirme se o servidor CliSiTef está responsivo

3. **Falha na criação de sessão**
   - Verifique se o storeId está correto
   - Confirme se o terminalId é válido
   - Verifique se não há sessões ativas

### Logs de Erro

Os logs de erro são salvos em:
- **Console**: Durante execução dos testes
- **Arquivo**: `./logs/e2e_test_YYYY-MM-DD.log`

## 📈 Métricas de Performance

Os testes E2E coletam métricas de performance:

- ⏱️ **Tempo de inicialização**
- ⏱️ **Tempo de criação de sessão**
- ⏱️ **Tempo de processamento de comandos**
- ⏱️ **Tempo total de cancelamento**
- 💾 **Uso de memória**

## 🔧 Configuração Avançada

### Variáveis de Ambiente

```bash
# Configurar variáveis de ambiente
export CLISITEF_IP="127.0.0.1"
export CLISITEF_STORE_ID="00000000"
export CLISITEF_TERMINAL_ID="REST0001"
export CLISITEF_OPERATOR="CAIXA"
```

### Configuração Personalizada

Crie um arquivo `test_config.yaml` personalizado:

```yaml
clisitef:
  sitef_ip: "192.168.1.100"  # Seu IP personalizado
  store_id: "12345678"       # Seu store ID
  terminal_id: "TERM001"     # Seu terminal ID
  cashier_operator: "ADMIN"  # Seu operador
```

## 📚 Documentação Relacionada

- [Documentação do CliSiTef](../../docs/)
- [Guia de Configuração](../../README.md)
- [Exemplos de Uso](../../example/)

## 🤝 Contribuindo

Para adicionar novos testes E2E:

1. **Crie o cenário** no arquivo de teste
2. **Adicione dados de teste** no helper `_createTestCancelationData`
3. **Documente o cenário** neste README
4. **Execute os testes** para validar
5. **Faça commit** das alterações

---

**Nota**: Estes testes requerem um servidor CliSiTef ativo e configurado corretamente.
