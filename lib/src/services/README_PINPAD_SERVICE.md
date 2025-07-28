# PinPadService - Serviço Unificado de PinPad 🎯

**O PinPadService é agora o serviço único e completo para TODAS as operações de PinPad**, substituindo completamente o `CliSiTefPinPadService` original e concentrando todas as funcionalidades em um só lugar.

## 🚀 Funcionalidades Completas

### 📋 **7 Tipos de Reset Disponíveis**

| Tipo | Ícone | Descrição | Quando Usar |
|------|-------|-----------|-------------|
| **Limited** ⚡ | `⚡` | Apenas operações funcionais | ⭐ **Recomendado** para servidores com endpoints limitados |
| **Basic** 🔄 | `🔄` | Fecha, remove cartão, reabre | Para travamentos gerais |
| **Complete** 🔧 | `🔧` | Reset básico + limpa sessão | Problemas de sessão |
| **Communication** 📡 | `📡` | Apenas fecha/reabre comunicação | Problemas de conectividade |
| **State** 🗑️ | `🗑️` | Limpa estados pendentes | Transações "fantasma" |
| **Emergency** 🚨 | `🚨` | Força reset ignorando erros | Situações críticas |
| **Soft** 🧽 | `🧽` | Remove cartão + mensagem | Limpeza suave |

### 🔧 **Operações Básicas do PinPad**

- ✅ **Abrir/Fechar PinPad**: `openPinPad()`, `closePinPad()`
- ✅ **Verificar Presença**: `isPinPadPresent()`, `checkPresence()`
- ✅ **Gerenciar Mensagens**: `setDisplayMessage()`, `setMessage()`, `clearMessage()`
- ✅ **Inicialização**: `initialize()`

### 💳 **Operações Avançadas de Cartão**

- ✅ **Leitura Segura**: `readCardSecure()`
- ✅ **Cartão com Chip**: `readChipCard()`
- ✅ **Leitura de Senha**: `readPassword()`
- ✅ **Confirmação**: `readConfirmation()`
- ✅ **Remoção de Cartão**: `removeCard()`

### 📊 **Integração com MessageManager**

- ✅ **Feedback em tempo real** para operador e caixa
- ✅ **Logs automáticos** de todas as operações
- ✅ **Tratamento de erros** com mensagens amigáveis

## 💻 Como Usar

### 1. **Uso Direto do PinPadService (Completo)**

```dart
import 'package:agente_clisitef/agente_clisitef.dart';

// Criar o serviço unificado
final pinpadService = PinPadService(
  repository: repository,
  config: config,
);

// ==========================================
// INICIALIZAÇÃO E CONFIGURAÇÃO
// ==========================================

// Inicializar PinPad com MessageManager
await pinpadService.initialize();

// Definir sessão
pinpadService.setCurrentSession(sessionId);

// ==========================================
// OPERAÇÕES BÁSICAS
// ==========================================

// Abrir/Fechar PinPad
await pinpadService.openPinPad();
await pinpadService.closePinPad();

// Verificar presença
final isPresent = await pinpadService.isPinPadPresent();
final isDetected = await pinpadService.checkPresence();

// Gerenciar mensagens
await pinpadService.setDisplayMessage('AGUARDANDO');
await pinpadService.setMessage('Com validação'); // Max 40 chars
await pinpadService.clearMessage();

// ==========================================
// OPERAÇÕES AVANÇADAS
// ==========================================

// Leitura segura de cartão
final cardResult = await pinpadService.readCardSecure('PASSE O CARTÃO');
if (cardResult.isSuccess) {
  print('Cartão lido: ${cardResult.cardData}');
} else {
  print('Erro: ${cardResult.errorMessage}');
}

// Leitura de cartão com chip
final chipResult = await pinpadService.readChipCard('INSIRA O CARTÃO', 1);

// Leitura de senha
final passwordResult = await pinpadService.readPassword('security_key');

// Confirmação do usuário
final confirmed = await pinpadService.readConfirmation('CONFIRMA?');

// Remover cartão
await pinpadService.removeCard();

// ==========================================
// RESET (7 TIPOS DIFERENTES)
// ==========================================

// Reset recomendado para compatibilidade
final success = await pinpadService.resetPinPad(
  resetType: PinPadResetType.limited,
);

// Reset completo para problemas críticos
await pinpadService.resetPinPad(
  resetType: PinPadResetType.emergency,
);
```

### 2. **Uso através do Proxy (CliSiTefServiceCapturaTardia)**

```dart
// ==========================================
// TODOS OS MÉTODOS DISPONÍVEIS VIA PROXY
// ==========================================

final service = CliSiTefServiceCapturaTardia(config: config);
await service.initialize();

// Operações básicas (proxy)
await service.openPinPad();
await service.closePinPad();
await service.isPinPadPresent();
await service.setPinPadMessage('MENSAGEM');

// Operações específicas (proxy)
await service.initializePinPad();
await service.checkPinPadPresence();
await service.setPinPadMessageValidated('MSG');
await service.clearPinPadMessage();

// Operações avançadas (proxy)
final cardResult = await service.readCardSecure('PASSE CARTÃO');
final chipResult = await service.readChipCard('INSIRA CARTÃO', 1);
final passwordResult = await service.readPassword('key');
final confirmed = await service.readConfirmation('CONFIRMA?');
await service.removeCard();

// Reset (proxy)
await service.resetPinPad(resetType: PinPadResetType.limited);

// Acesso direto ao serviço unificado
final pinpadService = service.pinpadService; // OU service.pinpadResetService
await pinpadService.anyMethod();
```

## 🏗️ **Arquitetura Unificada**

```
CliSiTefServiceCapturaTardia
├── PinPadService (🎯 ÚNICO SERVIÇO COMPLETO)
│   ├── 🔄 Reset Operations (7 tipos)
│   ├── 🔧 Basic Operations (open, close, presence)
│   ├── 💬 Message Management (set, clear, validate)
│   ├── 💳 Card Operations (secure, chip, password)
│   ├── 🎮 User Interaction (confirmation, removal)
│   ├── 📊 MessageManager Integration
│   └── 🛡️ Error Handling & Logging
├── CliSiTefCoreService
└── CliSiTefRepository
```

## 🔄 **Migração do CliSiTefPinPadService**

### ❌ **Antes (Duplicado)**
```dart
// Dois serviços separados 😫
final oldPinpadService = CliSiTefPinPadService(...);
final resetService = PinPadService(...);

// Funcionalidades espalhadas
await oldPinpadService.initialize();
await resetService.resetPinPad();
```

### ✅ **Agora (Unificado)**
```dart
// UM único serviço completo! 🎉
final pinpadService = PinPadService(...);

// TODAS as funcionalidades em um lugar
await pinpadService.initialize();
await pinpadService.readCardSecure('MSG');
await pinpadService.resetPinPad();
await pinpadService.setMessage('PRONTO');
```

## 🎯 **Vantagens da Unificação**

### **🏆 Benefícios Técnicos:**
- ✅ **Single Source of Truth** para PinPad
- ✅ **Zero duplicação** de funcionalidades
- ✅ **API consistente** em todo o sistema
- ✅ **Manutenibilidade** drasticamente melhorada
- ✅ **Testabilidade** unificada
- ✅ **Performance** otimizada

### **👨‍💻 Benefícios para Desenvolvedor:**
- ✅ **Uma única classe** para memorizar
- ✅ **Documentação centralizada**
- ✅ **Debugging simplificado**
- ✅ **Imports limpos**
- ✅ **IntelliSense melhorado**

### **🚀 Benefícios de Compatibilidade:**
- ✅ **100% backward compatible**
- ✅ **Proxy transparente** no CliSiTefServiceCapturaTardia
- ✅ **Migração gradual** possível
- ✅ **Detecção automática** de endpoints limitados

## 📚 **Classes de Resultado**

### **CardReadResult**
```dart
class CardReadResult {
  final bool isSuccess;
  final String? cardData;
  final String? errorMessage;

  // Factories
  CardReadResult.success(String cardData);
  CardReadResult.error(String errorMessage);
}
```

### **PasswordReadResult**
```dart
class PasswordReadResult {
  final bool isSuccess;
  final String? password;
  final String? errorMessage;

  // Factories
  PasswordReadResult.success(String password);
  PasswordReadResult.error(String errorMessage);
}
```

## 🔧 **Estados e Propriedades**

```dart
// Estados do serviço
pinpadService.isInitialized;        // bool
pinpadService.hasActiveSession;     // bool
pinpadService.pinPadDetected;       // bool
pinpadService.currentSessionId;     // String?
pinpadService.currentMessage;       // String
pinpadService.messageManager;       // AgenteClisitefMessageManager
```

---

> 💡 **Resumo**: O PinPadService é agora a **única fonte da verdade** para TODAS as operações de PinPad. Não é mais necessário usar o `CliSiTefPinPadService` - tudo está unificado! 🎯 