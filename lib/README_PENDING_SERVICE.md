# CliSiTefServicePending - Transações Pendentes

## Visão Geral

O `CliSiTefServicePending` é um serviço especializado que permite iniciar transações TEF mas **não as finaliza automaticamente**. Em vez disso, retorna um modelo `PendingTransaction` com métodos para confirmar ou cancelar a transação posteriormente.

Este padrão é especialmente útil em cenários onde você precisa:
- Emitir um cupom fiscal antes de confirmar a transação
- Aguardar confirmação do usuário
- Implementar lógica de negócio entre a autorização e a confirmação

## Diferenças do CliSiTefServiceAgente

| Aspecto | CliSiTefServiceAgente | CliSiTefServicePending |
|---------|----------------------|------------------------|
| Finalização | Automática | Manual (confirmar/cancelar) |
| Retorno | `TransactionResult` | `PendingTransaction` |
| Controle | Limitado | Total sobre confirmação |
| Caso de uso | Transações simples | Transações com lógica de negócio |

## Estrutura

### PendingTransaction

```dart
class PendingTransaction {
  final String sessionId;
  final TransactionResponse response;
  final CliSiTefRepository repository;
  
  // Métodos principais
  Future<TransactionResponse> confirm({...});
  Future<TransactionResponse> cancel();
  Future<TransactionResponse> continueWithData({...});
  
  // Propriedades
  bool get isFinalized;
  String get sessionIdValue;
  TransactionResponse get originalResponse;
}
```

## Exemplo de Uso

### 1. Configuração Básica

```dart
final config = CliSiTefConfig.development(
  sitefIp: '127.0.0.1',
  storeId: '00000000',
  terminalId: 'T001',
);

final service = CliSiTefServicePending(config: config);
await service.initialize();
```

### 2. Iniciar Transação Pendente

```dart
final transactionData = TransactionData.payment(
  functionId: 1,
  trnAmount: '10,00',
  taxInvoiceNumber: '123456',
  taxInvoiceDate: '20241201',
  taxInvoiceTime: '1430',
  cashierOperator: 'CAIXA',
);

final pendingTransaction = await service.startPendingTransaction(transactionData);

if (pendingTransaction == null) {
  print('Erro ao iniciar transação');
  return;
}
```

### 3. Processar Lógica de Negócio

```dart
// Simular emissão de cupom fiscal
print('Emitindo cupom fiscal...');
await emitirCupomFiscal();

// Verificar se cupom foi emitido com sucesso
final cupomEmitido = await verificarCupomFiscal();
```

### 4. Confirmar ou Cancelar

```dart
if (cupomEmitido) {
  // Confirmar transação
  final result = await pendingTransaction.confirm(
    taxInvoiceNumber: '123456',
    taxInvoiceDate: '20241201',
    taxInvoiceTime: '1430',
  );
  
  if (result.isServiceSuccess) {
    print('✅ Transação confirmada!');
  }
} else {
  // Cancelar transação
  final result = await pendingTransaction.cancel();
  
  if (result.isServiceSuccess) {
    print('❌ Transação cancelada!');
  }
}
```

## Fluxo Completo

```dart
class PDVService {
  final CliSiTefServicePending _tefService;
  
  Future<void> processarVenda(Venda venda) async {
    try {
      // 1. Iniciar transação pendente
      final transacaoPendente = await _tefService.startPendingTransaction(
        TransactionData.payment(
          functionId: 1,
          trnAmount: venda.valor.toString(),
          taxInvoiceNumber: venda.cupomFiscal,
          taxInvoiceDate: venda.dataFiscal,
          taxInvoiceTime: venda.horaFiscal,
          cashierOperator: venda.operador,
        ),
      );
      
      if (transacaoPendente == null) {
        throw Exception('Falha ao iniciar transação TEF');
      }
      
      // 2. Processar pagamento (cartão, senha, etc.)
      await processarPagamento();
      
      // 3. Emitir cupom fiscal
      final cupomEmitido = await emitirCupomFiscal(venda);
      
      // 4. Decidir sobre a transação
      if (cupomEmitido) {
        await transacaoPendente.confirm(
          taxInvoiceNumber: venda.cupomFiscal,
          taxInvoiceDate: venda.dataFiscal,
          taxInvoiceTime: venda.horaFiscal,
        );
        print('Venda finalizada com sucesso!');
      } else {
        await transacaoPendente.cancel();
        print('Venda cancelada - erro na emissão do cupom');
      }
      
    } catch (e) {
      print('Erro no processamento: $e');
      // Tentar cancelar transação em caso de erro
      if (transacaoPendente != null && !transacaoPendente.isFinalized) {
        await transacaoPendente.cancel();
      }
    }
  }
}
```

## Casos de Uso Típicos

### 1. PDV com Cupom Fiscal
- Inicia transação TEF
- Processa pagamento
- Emite cupom fiscal
- Confirma transação apenas se cupom for emitido

### 2. Totem de Autoatendimento
- Inicia transação
- Aguarda confirmação do usuário
- Confirma ou cancela baseado na escolha

### 3. Venda com Validações
- Inicia transação
- Executa validações de negócio
- Confirma apenas se todas as validações passarem

### 4. Transação com Múltiplos Passos
- Inicia transação
- Executa processo em etapas
- Confirma apenas no final do processo

## Tratamento de Erros

```dart
try {
  final pendingTransaction = await service.startPendingTransaction(data);
  
  // ... lógica de negócio ...
  
  await pendingTransaction.confirm();
} catch (e) {
  // Sempre tentar cancelar em caso de erro
  if (pendingTransaction != null && !pendingTransaction.isFinalized) {
    await pendingTransaction.cancel();
  }
  rethrow;
}
```

## Vantagens

1. **Controle Total**: Você decide quando confirmar ou cancelar
2. **Flexibilidade**: Permite lógica de negócio entre autorização e confirmação
3. **Segurança**: Evita confirmações automáticas indesejadas
4. **Auditoria**: Rastreamento completo do processo
5. **Recuperação**: Possibilidade de cancelar em caso de erro

## Considerações

- **Timeout**: Transações pendentes podem expirar
- **Recursos**: Manter transações pendentes consome recursos
- **Limpeza**: Sempre finalizar transações (confirmar ou cancelar)
- **Sessão**: Uma sessão por vez no AgenteCliSiTef

## Integração com Documentação

Este service implementa o padrão descrito na documentação do AgenteCliSiTef, especificamente:

- **startTransaction**: Inicia a transação
- **continueTransaction**: Processa fluxo iterativo
- **finishTransaction**: Confirma ou cancela (manual)

Conforme especificado na seção 6.1.3 da documentação atualizada. 