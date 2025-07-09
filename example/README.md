# CliSiTef SDK - Exemplos Flutter

Este projeto contém exemplos práticos de como usar o CliSiTef SDK em aplicações Flutter, com foco em boas práticas de desenvolvimento e arquitetura SOLID.

## 🚀 Como Executar

1. **Clone o repositório:**
   ```bash
   git clone <repository-url>
   cd agente_clisitef/example
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

## 📱 Exemplos Disponíveis

### 1. Transação Normal
- **Descrição**: Fluxo tradicional com finalização automática
- **Funcionalidades**: 
  - Inicialização do serviço
  - Execução de transações completas
  - Interface de interação em tempo real
  - Finalização automática

### 2. Transação Pendente ⭐ **REFATORADO COM SOLID**
- **Descrição**: Controle manual de confirmação/cancelamento com arquitetura SOLID
- **Funcionalidades**:
  - Início de transação pendente
  - Emissão de cupom fiscal
  - Confirmação/cancelamento manual
  - **Arquitetura SOLID aplicada**
  - **Controller separado da UI**
  - **Widgets reutilizáveis**
  - **Código mais legível e testável**

### 3. Tratamento Preventivo de Exceções
- **Descrição**: Exceções de cancelamento tratadas preventivamente
- **Funcionalidades**:
  - Detecção de diferentes tipos de cancelamento
  - Ações preventivas específicas por tipo
  - Logs detalhados de auditoria
  - Interface visual para testes

## 🏗️ Arquitetura SOLID Aplicada

### Estrutura Refatorada
```
example/lib/src/pages/
├── pending_transaction_page.dart          # Página principal (UI)
├── controllers/
│   └── pending_transaction_controller.dart # Lógica de negócio
└── widgets/
    ├── status_card.dart                   # Status do serviço
    ├── transaction_fields_card.dart       # Campos da transação
    ├── configuration_card.dart            # Configurações
    ├── transaction_data_card.dart         # Dados da transação
    ├── action_buttons_card.dart           # Botões de ação
    └── interaction_dialog.dart            # Diálogos de interação
```

### Princípios SOLID Implementados

#### 1. **S** - Single Responsibility Principle
- **Controller**: Responsável apenas pela lógica de negócio
- **Widgets**: Cada um com responsabilidade específica
- **Página**: Responsável apenas pela UI

#### 2. **O** - Open/Closed Principle
- Fácil extensão para novos tipos de transação
- Widgets reutilizáveis e extensíveis

#### 3. **L** - Liskov Substitution Principle
- Implementações corretas de interfaces
- Substituição segura de componentes

#### 4. **I** - Interface Segregation Principle
- Interfaces específicas para cada responsabilidade
- Props específicas para cada widget

#### 5. **D** - Dependency Inversion Principle
- Dependências invertidas através de abstrações
- Baixo acoplamento entre componentes

## 🔧 Configuração

### Parâmetros de Conexão
- **IP do Servidor**: Configurado para ambiente de teste
- **Store ID**: Identificação da loja
- **Terminal ID**: Identificação do terminal
- **Operador**: Identificação do operador

### Tipos de Transação Suportados
- **PIX**: Carteira Digital (código 122)
- **Crédito**: Venda a crédito (código 3)
- **Débito**: Venda a débito (código 4)

## 📋 Funcionalidades Demonstradas

### Integração com AgenteCliSiTef
- Inicialização e configuração do serviço
- Execução de transações
- Tratamento de respostas
- Gerenciamento de sessões

### Interface de Usuário
- Status em tempo real
- Mensagens para operador e cliente
- Controles de interação
- Logs de transação

### Tratamento de Exceções
- Detecção de cancelamentos
- Mensagens legíveis para usuário e operador
- Cores diferenciadas por tipo de cancelamento
- Tratamento preventivo automático
- Logs de auditoria
- Recuperação de erros

## 🛠️ Estrutura do Projeto

```
example/
├── lib/
│   ├── main.dart                    # Aplicação principal
│   └── src/
│       └── pages/
│           ├── pending_transaction_page.dart
│           ├── controllers/
│           │   └── pending_transaction_controller.dart
│           └── widgets/
│               ├── status_card.dart
│               ├── transaction_fields_card.dart
│               ├── configuration_card.dart
│               ├── transaction_data_card.dart
│               ├── action_buttons_card.dart
│               └── interaction_dialog.dart
├── README.md                        # Este arquivo
├── README_PENDING_EXAMPLE.md        # Documentação transação pendente
├── README_REFATORACAO_SOLID.md     # Documentação da refatoração SOLID
└── README_PREVENTIVE_EXCEPTION.md   # Documentação tratamento preventivo
```

## 📚 Documentação Detalhada

### Transação Pendente
Veja [README_PENDING_EXAMPLE.md](README_PENDING_EXAMPLE.md) para detalhes sobre:
- Fluxo de transação pendente
- Controle manual de confirmação
- Interface de interação

### Refatoração SOLID ⭐ **NOVO**
Veja [README_REFATORACAO_SOLID.md](README_REFATORACAO_SOLID.md) para detalhes sobre:
- **Aplicação dos princípios SOLID**
- **Separação de responsabilidades**
- **Arquitetura controller/widget**
- **Melhorias de legibilidade e testabilidade**

### Tratamento Preventivo
Veja [README_PREVENTIVE_EXCEPTION.md](README_PREVENTIVE_EXCEPTION.md) para detalhes sobre:
- Códigos de cancelamento (-2, -6, -15)
- Ações preventivas por tipo
- Logs de auditoria
- Casos de uso práticos

## 🎯 Casos de Uso

### Ambiente de Desenvolvimento
- Testes de integração
- Validação de funcionalidades
- Debug de problemas
- **Aprendizado de arquitetura SOLID**

### Ambiente de Produção
- Demonstração para clientes
- Treinamento de operadores
- Validação de configurações

## 🔍 Troubleshooting

### Problemas Comuns
1. **Serviço não inicializa**: Verificar conectividade com servidor
2. **Transação falha**: Verificar parâmetros de configuração
3. **Cancelamentos frequentes**: Verificar logs de auditoria

### Logs Disponíveis
- Logs de inicialização do serviço
- Logs de transação em tempo real
- Logs de tratamento preventivo com mensagens legíveis
- Logs de auditoria

## 🎨 Cores de Cancelamento

| Cor | Tipo | Código | Significado |
|-----|------|--------|-------------|
| 🟠 Laranja | Operador | -2 | Ação do operador do sistema |
| 🔵 Azul | Usuário | -6 | Ação do cliente no pinpad |
| 🟣 Roxo | Automação | -15 | Ação automática do sistema |
| 🔴 Vermelho | Erro/Desconhecido | -99 | Problema técnico ou não mapeado |

## 📈 Próximos Passos

1. **Integração com sistemas reais**
2. **Implementação de métricas**
3. **Dashboard de monitoramento**
4. **Automação de testes**
5. **Aplicação de SOLID em outras páginas**

## 🏆 Benefícios da Refatoração SOLID

### Antes da Refatoração
- ❌ Classe monolítica com 690+ linhas
- ❌ Mistura de responsabilidades
- ❌ Dificuldade de teste
- ❌ Código duplicado
- ❌ Alto acoplamento

### Após a Refatoração
- ✅ **Separação clara de responsabilidades**
- ✅ **Código mais legível e organizado**
- ✅ **Facilidade de teste unitário**
- ✅ **Reutilização de componentes**
- ✅ **Manutenibilidade melhorada**
- ✅ **Extensibilidade para novas funcionalidades**

---

Para mais informações sobre o SDK, consulte a documentação principal do projeto.
