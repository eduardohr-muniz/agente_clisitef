# Exemplo de Transações Pendentes - CliSiTef SDK

## 📱 Como Executar o Exemplo

### 1. Pré-requisitos

- Flutter SDK instalado
- AgenteCliSiTef rodando localmente (127.0.0.1:8080)
- Dispositivo/emulador para testar

### 2. Executar o Projeto

```bash
cd example
flutter pub get
flutter run
```

### 3. Navegação

Ao abrir o app, você verá uma tela inicial com duas opções:

1. **Transação Normal** - Fluxo tradicional
2. **Transação Pendente** - Novo fluxo com controle manual

## 🔄 Fluxo de Transação Pendente

### Passo a Passo:

1. **Inicialização**
   - O serviço é inicializado automaticamente
   - Configurações padrão são carregadas

2. **Configuração (Opcional)**
   - IP do Servidor: 127.0.0.1 (padrão)
   - ID da Loja: 00000000 (padrão)
   - ID do Terminal: PENDING001 (padrão)

3. **Dados da Transação**
   - Tipo: PIX, Crédito ou Débito
   - Valor: R$ 10,00 (padrão)
   - Cupom Fiscal: PEND001 (padrão)
   - Operador: CAIXA (padrão)

4. **Execução do Fluxo**

   **Botão 1: Iniciar Transação Pendente**
   - Inicia a transação mas NÃO finaliza
   - Processa o fluxo iterativo (cartão, senha, etc.)
   - Retorna um `PendingTransaction` para controle manual

   **Botão 2: Simular Emissão de Cupom**
   - Simula o processo de emissão do cupom fiscal
   - Aguarda 2 segundos (simula tempo de impressão)
   - Habilita os botões de confirmação/cancelamento

   **Botão 3: Confirmar Transação**
   - Confirma a transação com os dados do cupom fiscal
   - Finaliza a transação com sucesso
   - Desabilita futuras ações

   **Botão 4: Cancelar Transação**
   - Cancela a transação
   - Finaliza a transação com cancelamento
   - Desabilita futuras ações

## 🎯 Casos de Uso Demonstrados

### 1. Fluxo de Sucesso
```
1. Iniciar Transação Pendente
2. Simular Emissão de Cupom ✅
3. Confirmar Transação ✅
→ Resultado: Transação confirmada com sucesso
```

### 2. Fluxo de Cancelamento
```
1. Iniciar Transação Pendente
2. Simular Emissão de Cupom ❌ (erro na impressora)
3. Cancelar Transação ✅
→ Resultado: Transação cancelada com sucesso
```

### 3. Fluxo com Erro
```
1. Iniciar Transação Pendente
2. Erro durante processamento
3. Cancelar Transação (automático)
→ Resultado: Transação cancelada devido ao erro
```

## 🔧 Configurações

### Servidor Local
```dart
final config = CliSiTefConfig.development(
  sitefIp: '127.0.0.1',
  storeId: '00000000',
  terminalId: 'PENDING001',
  cashierOperator: 'CAIXA',
);
```

### Dados de Teste
```dart
final transactionData = TransactionData.payment(
  functionId: 122, // PIX
  trnAmount: '10,00',
  taxInvoiceNumber: 'PEND001',
  taxInvoiceDate: '20241201',
  taxInvoiceTime: '1430',
  cashierOperator: 'CAIXA',
);
```

## 📊 Status e Feedback

### Indicadores Visuais
- ✅ **Verde**: Sucesso
- ❌ **Vermelho**: Erro
- ⚠️ **Laranja**: Aviso
- 🔄 **Azul**: Processando

### Mensagens de Status
- `Serviço pendente inicializado com sucesso`
- `Transação pendente iniciada com sucesso!`
- `Cupom fiscal emitido com sucesso!`
- `Transação confirmada com sucesso!`
- `Transação cancelada com sucesso!`

## 🛠️ Tratamento de Erros

### Erros Comuns
1. **Serviço não inicializado**
   - Verificar se o AgenteCliSiTef está rodando
   - Verificar configurações de IP e porta

2. **Erro ao iniciar transação**
   - Verificar dados da transação
   - Verificar conectividade com servidor

3. **Transação já finalizada**
   - Uma transação só pode ser confirmada/cancelada uma vez
   - Iniciar nova transação se necessário

### Recuperação de Erros
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
}
```

## 🔍 Debug e Logs

### Logs do Console
O exemplo exibe logs detalhados no console:
```
[CliSiTefPending] Inicializando serviço...
[CliSiTefPending] Serviço inicializado com sucesso. SessionId: abc123
[CliSiTefPending] Iniciando transação pendente: 122
[PendingTransaction] Confirmando transação: abc123
[PendingTransaction] Transação confirmada com sucesso
```

### Informações na Tela
- Status do serviço
- SessionId da transação
- Status de finalização
- Mensagens de erro detalhadas

## 🚀 Próximos Passos

### Para Produção
1. Substituir simulações por chamadas reais
2. Implementar validações de negócio
3. Adicionar tratamento de timeout
4. Implementar retry automático
5. Adicionar logs estruturados

### Melhorias Sugeridas
1. Interface para entrada de dados do usuário
2. Validação de campos em tempo real
3. Histórico de transações
4. Configurações persistentes
5. Testes automatizados

## 📚 Documentação Relacionada

- [README_PENDING_SERVICE.md](../lib/src/README_PENDING_SERVICE.md) - Documentação do service
- [example_pending_transaction.dart](../lib/src/example_pending_transaction.dart) - Exemplos em código
- [pending_transaction.dart](../lib/src/models/pending_transaction.dart) - Modelo de transação pendente 