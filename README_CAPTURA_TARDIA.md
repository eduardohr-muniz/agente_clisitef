# CliSiTefServiceCapturaTardia - Guia Completo

## Visão Geral

O `CliSiTefServiceCapturaTardia` é um serviço especializado para transações pendentes de confirmação no sistema CliSiTef. Ele permite iniciar uma transação e decidir posteriormente se confirmar ou cancelar, oferecendo maior flexibilidade no controle do fluxo de transações.

## Características Principais

- ✅ **Transações Pendentes**: Inicia transações sem finalização automática
- ✅ **Controle Manual**: Permite confirmar ou cancelar transações posteriormente
- ✅ **Gestão de Sessão**: Gerencia sessões automaticamente
- ✅ **Tratamento de Erros**: Sistema robusto de tratamento de exceções
- ✅ **Logs Detalhados**: Rastreamento completo das operações
- ✅ **Validação**: Validação automática de configurações e dados

## Estrutura do Serviço

```dart
class CliSiTefServiceCapturaTardia {
  // Inicialização
  Future<bool> initialize()
  
  // Transações pendentes
  Future<PendingTransaction?> startPendingTransaction(TransactionData data)
  
  // Utilitários
  bool get isInitialized
  String? get currentSessionId
  Future<bool> checkConnectivity()
  Future<void> dispose()
}
```

## Configuração Inicial

### 1. Criar Configuração

```dart
import 'package:agente_clisitef/src/models/clisitef_config.dart';
import 'package:agente_clisitef/src/services/clisitef_service_captura_tardia.dart';

// Configuração para desenvolvimento
final config = CliSiTefConfig.development(
  sitefIp: '192.168.1.100',
  storeId: '00000001',
  terminalId: '00000001',
  cashierOperator: 'OPERADOR',
);

// Configuração para produção
final config = CliSiTefConfig.production(
  sitefIp: '10.0.0.50',
  storeId: '12345678',
  terminalId: '87654321',
  baseUrl: 'https://agente-clisitef.com',
  timeout: Duration(seconds: 60),
);
```

### 2. Instanciar o Serviço

```dart
final service = CliSiTefServiceCapturaTardia(config: config);
```

### 3. Inicializar o Serviço

```dart
try {
  final isInitialized = await service.initialize();
  if (isInitialized) {
    print('Serviço inicializado com sucesso!');
    print('SessionId: ${service.currentSessionId}');
  }
} catch (e) {
  print('Erro ao inicializar: $e');
}
```

## Uso Básico

### Exemplo 1: Transação de Pagamento Simples

```dart
import 'package:agente_clisitef/src/models/transaction_data.dart';

// Criar dados da transação
final transactionData = TransactionData.payment(
  functionId: 110, // Código da função (pagamento)
  trnAmount: '10,50', // Valor no formato "0,00"
  taxInvoiceNumber: '123456', // Número do cupom
  taxInvoiceDate: '20241201', // Data no formato AAAAMMDD
  taxInvoiceTime: '143000', // Hora no formato HHMMSS
  cashierOperator: 'OPERADOR',
);

// Iniciar transação pendente
try {
  final pendingTransaction = await service.startPendingTransaction(transactionData);
  
  if (pendingTransaction != null) {
    print('Transação pendente criada!');
    print('SessionId: ${pendingTransaction.sessionId}');
    
    // Aguardar decisão do usuário...
    // (aqui você pode mostrar uma interface para o usuário decidir)
    
    // Confirmar a transação
    final result = await pendingTransaction.confirm();
    if (result.isServiceSuccess) {
      print('Transação confirmada com sucesso!');
    }
  }
} catch (e) {
  print('Erro na transação: $e');
}
```

### Exemplo 2: Transação com Parâmetros Adicionais

```dart
final transactionData = TransactionData.payment(
  functionId: 110,
  trnAmount: '25,00',
  taxInvoiceNumber: '789012',
  taxInvoiceDate: '20241201',
  taxInvoiceTime: '150000',
  trnAdditionalParameters: {
    'cardBrand': 'VISA',
    'installments': '1',
    'captureType': 'AUTHORIZATION',
  },
  trnInitParameters: {
    'timeout': '60',
    'autoConfirm': 'false',
  },
);

final pendingTransaction = await service.startPendingTransaction(transactionData);
```

### Exemplo 3: Transação Gerencial

```dart
final transactionData = TransactionData.administrative(
  functionId: 200, // Código para função gerencial
  taxInvoiceNumber: 'ADMIN001',
  taxInvoiceDate: '20241201',
  taxInvoiceTime: '160000',
  trnAdditionalParameters: {
    'operation': 'REPORT',
    'reportType': 'DAILY',
  },
);

final pendingTransaction = await service.startPendingTransaction(transactionData);
```

## Controle de Transações Pendentes

### Confirmar Transação

```dart
// Confirmar com dados fiscais
final result = await pendingTransaction.confirm(
  taxInvoiceNumber: '123456',
  taxInvoiceDate: '20241201',
  taxInvoiceTime: '143000',
);

if (result.isServiceSuccess) {
  print('Transação confirmada!');
  print('Status: ${result.clisitefStatus}');
  print('Mensagem: ${result.errorMessage}');
}
```

### Cancelar Transação

```dart
// Cancelar transação
final result = await pendingTransaction.cancel(
  taxInvoiceNumber: '123456',
  taxInvoiceDate: '20241201',
  taxInvoiceTime: '143000',
);

if (result.isServiceSuccess) {
  print('Transação cancelada!');
}
```

### Continuar Transação com Dados Específicos

```dart
// Continuar transação com comando específico
final result = await pendingTransaction.continueWithData(
  command: 100, // Código do comando
  data: 'dados_adicionais',
);
```

## Tratamento de Erros

### Tipos de Exceções

```dart
import 'package:agente_clisitef/src/core/exceptions/clisitef_exception.dart';

try {
  final pendingTransaction = await service.startPendingTransaction(transactionData);
} on CliSiTefException catch (e) {
  switch (e.code) {
    case -2:
      print('Operador cancelou a operação');
      break;
    case -6:
      print('Usuário cancelou no pinpad');
      break;
    case -15:
      print('Sistema cancelou automaticamente');
      break;
    default:
      print('Erro desconhecido: ${e.message}');
  }
} catch (e) {
  print('Erro inesperado: $e');
}
```

### Verificação de Conectividade

```dart
// Verificar conectividade antes de iniciar transação
final isConnected = await service.checkConnectivity();
if (!isConnected) {
  print('Sem conectividade com o servidor');
  return;
}
```

## Exemplo Completo de Implementação

```dart
class PaymentService {
  late CliSiTefServiceCapturaTardia _service;
  bool _isInitialized = false;

  Future<void> initialize() async {
    final config = CliSiTefConfig.production(
      sitefIp: '192.168.1.100',
      storeId: '12345678',
      terminalId: '87654321',
    );

    _service = CliSiTefServiceCapturaTardia(config: config);
    
    try {
      _isInitialized = await _service.initialize();
      print('Serviço inicializado: $_isInitialized');
    } catch (e) {
      print('Erro na inicialização: $e');
      rethrow;
    }
  }

  Future<TransactionResult> processPayment({
    required String amount,
    required String invoiceNumber,
    required String invoiceDate,
    required String invoiceTime,
  }) async {
    if (!_isInitialized) {
      throw Exception('Serviço não inicializado');
    }

    final transactionData = TransactionData.payment(
      functionId: 110,
      trnAmount: amount,
      taxInvoiceNumber: invoiceNumber,
      taxInvoiceDate: invoiceDate,
      taxInvoiceTime: invoiceTime,
    );

    try {
      final pendingTransaction = await _service.startPendingTransaction(transactionData);
      
      if (pendingTransaction == null) {
        return TransactionResult.failure('Falha ao iniciar transação');
      }

      // Simular interface de usuário para confirmar/cancelar
      final shouldConfirm = await _showConfirmationDialog();
      
      if (shouldConfirm) {
        final result = await pendingTransaction.confirm();
        return TransactionResult.fromResponse(result);
      } else {
        final result = await pendingTransaction.cancel();
        return TransactionResult.fromResponse(result);
      }
    } catch (e) {
      return TransactionResult.failure('Erro na transação: $e');
    }
  }

  Future<bool> _showConfirmationDialog() async {
    // Implementar interface de usuário
    // Retornar true para confirmar, false para cancelar
    return true; // Exemplo
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _service.dispose();
      _isInitialized = false;
    }
  }
}
```

## Propriedades e Métodos Disponíveis

### Propriedades

| Propriedade | Tipo | Descrição |
|-------------|------|-----------|
| `isInitialized` | `bool` | Indica se o serviço está inicializado |
| `currentSessionId` | `String?` | ID da sessão atual |
| `config` | `CliSiTefConfig` | Configuração do serviço |
| `coreService` | `CliSiTefCoreService` | Serviço core para operações básicas |
| `pinpadService` | `CliSiTefPinPadService` | Serviço para operações do pinpad |
| `version` | `String` | Versão do SDK |
| `repository` | `CliSiTefRepository` | Repositório para controle manual |

### Métodos Principais

| Método | Retorno | Descrição |
|--------|---------|-----------|
| `initialize()` | `Future<bool>` | Inicializa o serviço |
| `startPendingTransaction(data)` | `Future<PendingTransaction?>` | Inicia transação pendente |
| `checkConnectivity()` | `Future<bool>` | Verifica conectividade |
| `dispose()` | `Future<void>` | Finaliza o serviço |

## Boas Práticas

### 1. Sempre Inicializar o Serviço

```dart
// ✅ Correto
await service.initialize();

// ❌ Incorreto
final pendingTransaction = await service.startPendingTransaction(data);
```

### 2. Tratar Exceções Adequadamente

```dart
try {
  final pendingTransaction = await service.startPendingTransaction(data);
  // Processar transação
} on CliSiTefException catch (e) {
  // Tratar erros específicos do CliSiTef
  _handleCliSiTefError(e);
} catch (e) {
  // Tratar erros genéricos
  _handleGenericError(e);
}
```

### 3. Verificar Conectividade

```dart
final isConnected = await service.checkConnectivity();
if (!isConnected) {
  // Mostrar mensagem de erro para o usuário
  _showConnectionError();
  return;
}
```

### 4. Finalizar o Serviço

```dart
@override
void dispose() {
  service.dispose();
  super.dispose();
}
```

### 5. Validar Dados Antes de Usar

```dart
final errors = transactionData.validate();
if (errors.isNotEmpty) {
  print('Erros de validação: ${errors.join(', ')}');
  return;
}
```

## Códigos de Erro Comuns

| Código | Descrição | Ação Recomendada |
|--------|-----------|------------------|
| -2 | Operador cancelou | Verificar se o operador realmente cancelou |
| -6 | Usuário cancelou no pinpad | Verificar se o usuário cancelou no dispositivo |
| -15 | Sistema cancelou automaticamente | Verificar timeout ou configurações |
| -1 | Erro de comunicação | Verificar conectividade e configurações |
| -3 | Erro de configuração | Verificar parâmetros do serviço |

## Logs e Debug

O serviço gera logs detalhados para facilitar o debug:

```
[CliSiTefCapturaTardia] Inicializando serviço...
[CliSiTefCapturaTardia] Criando sessão...
[CliSiTefCapturaTardia] Serviço inicializado com sucesso. SessionId: abc123
[CliSiTefCapturaTardia] Iniciando transação pendente: 110
[CliSiTefCapturaTardia] Transação pendente criada com sucesso
```

Para desabilitar logs em produção:

```dart
final config = CliSiTefConfig.production(
  // ... outros parâmetros
  enableLogs: false,
);
```

## Considerações de Performance

1. **Reutilizar Sessões**: O serviço mantém uma sessão ativa, evite criar múltiplas instâncias
2. **Timeout Adequado**: Configure timeout apropriado para seu ambiente
3. **Dispose**: Sempre finalize o serviço quando não for mais necessário
4. **Conectividade**: Verifique conectividade antes de iniciar transações

## Suporte e Troubleshooting

### Problemas Comuns

1. **Serviço não inicializa**
   - Verificar configuração (IP, storeId, terminalId)
   - Verificar conectividade de rede
   - Verificar logs para detalhes do erro

2. **Transação falha ao iniciar**
   - Verificar dados da transação (formato de valores, datas)
   - Verificar se o serviço está inicializado
   - Verificar conectividade

3. **Erro de cancelamento inesperado**
   - Verificar timeout da transação
   - Verificar se o pinpad está funcionando
   - Verificar configurações do servidor

### Logs de Debug

Para obter logs mais detalhados, configure:

```dart
final config = CliSiTefConfig.development(
  // ... outros parâmetros
  enableLogs: true,
);
```

## Conclusão

O `CliSiTefServiceCapturaTardia` oferece uma solução robusta e flexível para transações pendentes no sistema CliSiTef. Com sua API intuitiva e tratamento de erros abrangente, é ideal para aplicações que precisam de controle manual sobre o fluxo de transações.

Para mais informações, consulte a documentação completa da API e os exemplos de implementação. 