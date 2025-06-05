import 'package:agente_clisitef/src/models/refund.dart';
import 'package:agente_clisitef/src/models/payment_status.dart';
import 'package:agente_clisitef/src/enums/function_id.dart';
import 'package:agente_clisitef/src/enums/tipo_transacao.dart';
import 'package:intl/intl.dart';
import 'package:agente_clisitef/src/services/mappers/error_mapper.dart';
import 'package:agente_clisitef/src/services/mappers/transaction_function_mapper.dart';
import 'package:agente_clisitef/src/services/mappers/string_mapper.dart';

/// Classe utilitária para mapeamento de funções de transação
class TransactionMappers {
  /// Mapeamento de códigos de erro do CliSiTef
  static const Map<String, String> _errorCodes = {
    // Erros Gerais (0001-0050)
    '0001': 'Erro de comunicação com o SiTef',
    '0002': 'Erro de inicialização do SiTef',
    '0003': 'Erro de configuração do SiTef',
    '0004': 'Erro de operação cancelada',
    '0005': 'Erro de operação não suportada',
    '0006': 'Erro de parâmetro inválido',
    '0007': 'Erro de buffer inválido',
    '0008': 'Erro de timeout',
    '0009': 'Erro de memória insuficiente',
    '0010': 'Erro de arquivo não encontrado',
    '0011': 'Erro de permissão negada',
    '0012': 'Erro de dispositivo não encontrado',
    '0013': 'Erro de dispositivo ocupado',
    '0014': 'Erro de dispositivo não inicializado',
    '0015': 'Erro de dispositivo não configurado',

    // Erros de Cartão (0101-0150)
    '0101': 'Cartão não suportado',
    '0102': 'Cartão com restrição',
    '0103': 'Cartão bloqueado',
    '0104': 'Cartão vencido',
    '0105': 'Cartão com chip danificado',
    '0106': 'Cartão com tarja magnética danificada',
    '0107': 'Cartão com chip não suportado',
    '0108': 'Cartão com tarja magnética não suportada',
    '0109': 'Cartão com chip bloqueado',
    '0110': 'Cartão com tarja magnética bloqueada',

    // Erros de Transação (0201-0250)
    '0201': 'Transação não autorizada',
    '0202': 'Transação cancelada',
    '0203': 'Transação não finalizada',
    '0204': 'Transação com erro',
    '0205': 'Transação não encontrada',
    '0206': 'Transação já finalizada',
    '0207': 'Transação já cancelada',
    '0208': 'Transação já autorizada',
    '0209': 'Transação já negada',
    '0210': 'Transação já estornada',

    // Erros de Comunicação (0301-0350)
    '0301': 'Erro de comunicação com o servidor',
    '0302': 'Erro de comunicação com o PINPAD',
    '0303': 'Erro de comunicação com a rede',
    '0304': 'Erro de comunicação com o banco',
    '0305': 'Erro de comunicação com a operadora',
    '0306': 'Erro de comunicação com o SiTef',
    '0307': 'Erro de comunicação com o terminal',
    '0308': 'Erro de comunicação com o host',
    '0309': 'Erro de comunicação com o gateway',
    '0310': 'Erro de comunicação com o proxy',

    // Erros de Configuração (0401-0450)
    '0401': 'Erro de configuração do terminal',
    '0402': 'Erro de configuração do PINPAD',
    '0403': 'Erro de configuração da rede',
    '0404': 'Erro de configuração do banco',
    '0405': 'Erro de configuração da operadora',
    '0406': 'Erro de configuração do SiTef',
    '0407': 'Erro de configuração do host',
    '0408': 'Erro de configuração do gateway',
    '0409': 'Erro de configuração do proxy',
    '0410': 'Erro de configuração do certificado',
  };

  /// Mapeamento de mensagens de erro por categoria
  static const Map<String, Map<String, String>> _errorMessages = {
    'cartao': {
      'CARTÃO BLOQUEADO': 'Cartão bloqueado. Por favor, utilize outro cartão.',
      'CARTÃO NÃO SUPORTADO': 'Este cartão não é aceito. Por favor, utilize outro cartão.',
      'CARTÃO VENCIDO': 'Cartão vencido. Por favor, utilize outro cartão.',
      'CARTÃO COM CHIP DANIFICADO': 'Chip do cartão danificado. Por favor, utilize outro cartão.',
      'CARTÃO COM RESTRIÇÃO': 'Cartão com restrição. Por favor, utilize outro cartão.',
      'CARTÃO COM TARJA DANIFICADA': 'Tarja magnética danificada. Por favor, utilize outro cartão.',
      'CARTÃO COM CHIP BLOQUEADO': 'Chip do cartão bloqueado. Por favor, utilize outro cartão.',
      'CARTÃO COM TARJA BLOQUEADA': 'Tarja magnética bloqueada. Por favor, utilize outro cartão.',
    },
    'transacao': {
      'TRANSAÇÃO NÃO AUTORIZADA': 'Transação não autorizada. Por favor, tente novamente.',
      'TRANSAÇÃO CANCELADA': 'Transação cancelada pelo usuário.',
      'TRANSAÇÃO NÃO FINALIZADA': 'Transação não finalizada. Por favor, tente novamente.',
      'TRANSAÇÃO COM ERRO': 'Erro na transação. Por favor, tente novamente.',
      'TRANSAÇÃO NÃO ENCONTRADA': 'Transação não encontrada. Por favor, tente novamente.',
      'TRANSAÇÃO JÁ FINALIZADA': 'Transação já finalizada anteriormente.',
      'TRANSAÇÃO JÁ CANCELADA': 'Transação já cancelada anteriormente.',
      'TRANSAÇÃO JÁ AUTORIZADA': 'Transação já autorizada anteriormente.',
      'TRANSAÇÃO JÁ NEGADA': 'Transação já negada anteriormente.',
      'TRANSAÇÃO JÁ ESTORNADA': 'Transação já estornada anteriormente.',
    },
    'conexao': {
      'ERRO DE COMUNICAÇÃO': 'Erro de comunicação. Verifique a conexão e tente novamente.',
      'ERRO DE REDE': 'Erro de rede. Verifique a conexão e tente novamente.',
      'ERRO DE SERVIDOR': 'Erro de servidor. Tente novamente mais tarde.',
      'ERRO DE PINPAD': 'Erro no PINPAD. Verifique a conexão e tente novamente.',
      'ERRO DE BANCO': 'Erro de comunicação com o banco. Tente novamente mais tarde.',
      'ERRO DE SITEF': 'Erro de comunicação com o SiTef. Tente novamente mais tarde.',
      'ERRO DE TERMINAL': 'Erro de comunicação com o terminal. Tente novamente mais tarde.',
      'ERRO DE HOST': 'Erro de comunicação com o host. Tente novamente mais tarde.',
      'ERRO DE GATEWAY': 'Erro de comunicação com o gateway. Tente novamente mais tarde.',
      'ERRO DE PROXY': 'Erro de comunicação com o proxy. Tente novamente mais tarde.',
    },
    'configuracao': {
      'ERRO DE CONFIGURAÇÃO': 'Erro de configuração. Verifique as configurações do sistema.',
      'ERRO DE TERMINAL': 'Erro de configuração do terminal. Verifique as configurações.',
      'ERRO DE PINPAD': 'Erro de configuração do PINPAD. Verifique as configurações.',
      'ERRO DE REDE': 'Erro de configuração da rede. Verifique as configurações.',
      'ERRO DE BANCO': 'Erro de configuração do banco. Verifique as configurações.',
      'ERRO DE SITEF': 'Erro de configuração do SiTef. Verifique as configurações.',
      'ERRO DE HOST': 'Erro de configuração do host. Verifique as configurações.',
      'ERRO DE GATEWAY': 'Erro de configuração do gateway. Verifique as configurações.',
      'ERRO DE PROXY': 'Erro de configuração do proxy. Verifique as configurações.',
      'ERRO DE CERTIFICADO': 'Erro de configuração do certificado. Verifique as configurações.',
    },
    'generico': {
      'ERRO': 'Ocorreu um erro. Por favor, tente novamente.',
      'ERRO INESPERADO': 'Ocorreu um erro inesperado. Por favor, tente novamente.',
      'ERRO DE SISTEMA': 'Erro no sistema. Por favor, tente novamente.',
      'ERRO DE OPERAÇÃO': 'Erro na operação. Por favor, tente novamente.',
      'ERRO DE PROCESSAMENTO': 'Erro no processamento. Por favor, tente novamente.',
      'ERRO DE MEMÓRIA': 'Erro de memória insuficiente. Por favor, tente novamente.',
      'ERRO DE ARQUIVO': 'Erro de arquivo não encontrado. Por favor, tente novamente.',
      'ERRO DE PERMISSÃO': 'Erro de permissão negada. Por favor, tente novamente.',
      'ERRO DE DISPOSITIVO': 'Erro de dispositivo não encontrado. Por favor, tente novamente.',
      'ERRO DE TIMEOUT': 'Erro de timeout. Por favor, tente novamente.',
    },
  };

  /// Mapeamento de códigos de status para mensagens amigáveis
  static const Map<int, String> _statusMessages = {
    0: 'Operação realizada com sucesso',
    1: 'Erro de comunicação',
    2: 'Erro de configuração',
    3: 'Erro de operação',
    4: 'Erro de processamento',
    5: 'Erro de sistema',
    6: 'Erro de rede',
    7: 'Erro de PINPAD',
    8: 'Erro de banco',
    9: 'Erro de operadora',
  };

  /// Obtém uma mensagem de erro amigável baseada na mensagem recebida
  static String getErrorMessage(String message) {
    return ErrorMapper.getErrorMessage(message);
  }

  /// Obtém uma mensagem amigável para um código de status
  static String getStatusMessage(int statusCode) {
    return ErrorMapper.getStatusMessage(statusCode);
  }

  /// Verifica se a mensagem contém um erro conhecido
  static bool hasKnownError(String message) {
    return ErrorMapper.hasKnownError(message);
  }

  /// Identifica a categoria do erro baseado na mensagem
  static String getErrorCategory(String message) {
    return ErrorMapper.getErrorCategory(message);
  }

  /// Verifica se um status indica erro
  static bool isErrorStatus(int statusCode) {
    return ErrorMapper.isErrorStatus(statusCode);
  }

  /// Obtém o tipo de erro baseado no status
  static String getErrorType(int statusCode) {
    return ErrorMapper.getErrorType(statusCode);
  }

  /// Obtém o código de erro da mensagem
  static String? getErrorCode(String message) {
    return ErrorMapper.getErrorCode(message);
  }

  /// Verifica se é um erro interno do sistema
  static bool isInternalError(String message) {
    return ErrorMapper.isInternalError(message);
  }

  /// Obtém uma mensagem de erro interno amigável
  static String getInternalErrorMessage(String message) {
    return ErrorMapper.getInternalErrorMessage(message);
  }

  /// Extrai números de uma string
  static String extractNumbers(String input) {
    return StringMapper.extractNumbers(input);
  }

  /// Extrai letras de uma string
  static String extractLetters(String input) {
    return StringMapper.extractLetters(input);
  }

  /// Mapeia a função de transação (versão simples)
  static String mapFuncTransacaoSimple(String input) {
    return StringMapper.mapFuncTransacaoSimple(input);
  }

  /// Mapeia a função de cancelamento (versão simples)
  static String mapFuncCancelarTransacaoSimple(String input) {
    return StringMapper.mapFuncCancelarTransacaoSimple(input);
  }

  /// Mapeia funções de continuação de transação conforme o código e tipo.
  static Map<int, Future<void> Function()> mapFuncTransacao({
    required int continueCode,
    required TipoTransacao tipoTransacao,
    String? data,
    required Function(int, String?) continueTransaction,
    required Function(PaymentStatus) updatePaymentStatus,
  }) {
    return TransactionFunctionMapper.mapFuncTransacao(
      continueCode: continueCode,
      tipoTransacao: tipoTransacao,
      data: data,
      continueTransaction: continueTransaction,
      updatePaymentStatus: updatePaymentStatus,
    );
  }

  /// Mapeia funções de continuação para cancelamento/estorno.
  static Map<String, Future<void> Function()> mapFuncCancelarTransacao({
    required String data,
    required Refund refund,
    required Function(int, String?) continueTransaction,
    required Function(Exception) completeError,
    required Function() setIsFinish,
  }) {
    return TransactionFunctionMapper.mapFuncCancelarTransacao(
      data: data,
      refund: refund,
      continueTransaction: continueTransaction,
      completeError: completeError,
      setIsFinish: setIsFinish,
    );
  }

  /// Mapeia funções de finalização de fluxo, como erro inesperado ou término.
  static Map<String, void Function()> handleFinish({
    required Function() setIsFinish,
    required Function(PaymentStatus) updatePaymentStatus,
    required Function(Exception) completeError,
  }) {
    return TransactionFunctionMapper.handleFinish(
      setIsFinish: setIsFinish,
      updatePaymentStatus: updatePaymentStatus,
      completeError: completeError,
    );
  }

  /// Busca chave Pix em um dado de entrada.
  static String? whenPix(String? data) {
    return TransactionFunctionMapper.whenPix(data);
  }
}
