<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# CliSiTef SDK para Flutter

SDK Flutter para integração com o AgenteCliSiTef via REST API, baseado na especificação oficial CliSiTef versão 253.

## Características

- ✅ **Comunicação via REST API** com AgenteCliSiTef
- ✅ **Parâmetros em inglês** conforme especificação atualizada
- ✅ **Logs detalhados** via Talker
- ✅ **Chamadas HTTP reais** via Dio
- ✅ **Gerenciamento de sessões** automático
- ✅ **Fluxo iterativo** de transações
- ✅ **Operações com PinPad** integradas
- ✅ **Tratamento de erros** robusto
- ✅ **Validações** completas

## Instalação

Adicione a dependência ao seu `pubspec.yaml`:

```yaml
dependencies:
  agente_clisitef: ^1.0.0
```

## Configuração

### 1. Configuração Básica

```dart
import 'package:agente_clisitef/agente_clisitef.dart';

final config = CliSiTefConfig(
  sitefIp: '127.0.0.1',
  storeId: '00000000',
  terminalId: 'PD000001',
  enableLogs: true,
);
```

### 2. Inicialização do Serviço

```dart
final service = CliSiTefServiceAgente(config: config);
final initialized = await service.initialize();

if (initialized) {
  print('Serviço inicializado com sucesso');
} else {
  print('Erro ao inicializar serviço');
}
```

## Uso

### Executar Transação de Pagamento

```dart
// Data e hora atual
final now = DateTime.now();
final fiscalDate = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
final fiscalTime = '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';

final result = await service.executePayment(
  functionId: 3, // Crédito
  amount: '10,00',
  taxInvoiceNumber: '000001',
  taxInvoiceDate: fiscalDate,
  taxInvoiceTime: fiscalTime,
  cashierOperator: 'OPERADOR',
);

if (result.isSuccess) {
  print('Transação aprovada: ${result.statusCode}');
} else {
  print('Transação rejeitada: ${result.message}');
}
```

### Executar Transação Gerencial

```dart
final result = await service.executeAdministrative(
  functionId: 100, // Telemarketing
  taxInvoiceNumber: '000001',
  taxInvoiceDate: fiscalDate,
  taxInvoiceTime: fiscalTime,
  cashierOperator: 'OPERADOR',
);
```

### Operações com PinPad

```dart
// Verificar presença do PinPad
final isPresent = await service.pinpadService.checkPresence();

if (isPresent) {
  // Definir mensagem no PinPad
  await service.pinpadService.setMessage('Aguardando cartão...');
  
  // Ler cartão
  final cardResult = await service.pinpadService.readCardSecure('Insira o cartão');
  
  if (cardResult.isSuccess) {
    print('Cartão lido: ${cardResult.cardData}');
  }
}
```

### Verificar Estado do Serviço

```dart
final stateResponse = await service.getState();
print('Estado: ${stateResponse.serviceState}');
```

### Obter Versão

```dart
final versionResponse = await service.getVersion();
print('Versão: ${versionResponse.additionalData}');
```

## Códigos de Função

| Código | Descrição |
|--------|-----------|
| 0 | Pagamento Genérico |
| 1 | Cheque |
| 2 | Débito |
| 3 | Crédito |
| 4 | Fininvest |
| 5 | Vale |
| 6 | Crédito Centralizado |
| 7 | Cartão Combustível |
| 8 | Parcele Mais |
| 10 | Vale Refeição |
| 11 | Vale Alimentação |
| 12 | Infocard |
| 13 | Pay Pass |
| 15 | Cartão Presente |
| 16 | Débito Parcelado |
| 17 | Crédito Parcelado |
| 28 | Cartão Qualidade |
| 100 | Telemarketing |
| 101 | Cancelamento Cartão Qualidade |

## Estrutura do Projeto

```
lib/
├── agente_clisitef.dart
├── src/
│   ├── core/
│   │   ├── constants/
│   │   │   └── clisitef_constants.dart
│   │   ├── exceptions/
│   │   │   └── clisitef_exception.dart
│   │   └── utils/
│   │       ├── format_utils.dart
│   │       └── validation_utils.dart
│   ├── models/
│   │   ├── clisitef_config.dart
│   │   ├── transaction_data.dart
│   │   └── transaction_response.dart
│   ├── repositories/
│   │   ├── clisitef_repository.dart
│   │   └── clisitef_repository_impl.dart
│   └── services/
│       ├── clisitef_core_service.dart
│       ├── clisitef_pinpad_service.dart
│       └── clisitef_service_agente.dart
```

## Exemplo Completo

Veja o exemplo completo na pasta `example/` que demonstra:

- Inicialização do serviço
- Execução de transações
- Verificação de estado
- Obtenção de versão
- Interface de usuário completa

## Dependências

- `dio: ^5.7.0` - Cliente HTTP
- `talker: ^3.1.0` - Sistema de logs
- `talker_dio_logger: ^3.1.0` - Logger para Dio
- `intl: ^0.20.2` - Formatação internacional

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## Suporte

Para suporte e dúvidas, consulte:

- [Documentação oficial CliSiTef](https://dev.softwareexpress.com.br/docs/clisitef/funcionamento_basico)
- [Especificação AgenteCliSiTef](lib/especificacao_atualizada.md)
- [Issues do projeto](https://github.com/your-username/agente_clisitef/issues)
