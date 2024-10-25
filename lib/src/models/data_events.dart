enum DataEvents {
  menuTitle,
  messageCashier,
  messageCustomer,
  messageCashierCustomer,
  messageQrCode,
  showQrCodeField,
  removeQrCodeField,
  confirmation,
  confirmGoBack,
  pressAnyKey,
  abortRequest,
  menuOptions,
  getFieldInternal,
  getField,
  getFieldBarCode,
  getFieldCheque,
  getFieldTrack,
  getFieldPassword,
  getFieldCurrency,
  getMaskedField,
  headerShow,
  getPinPadConfirmation,
  unknown,
  data;

  static Map<int, DataEvents> fildIdToDataEvent = {
    -1: DataEvents.unknown, // Informação não tratável
    0: DataEvents.data, // Início da interação com SiTef
    1: DataEvents.confirmation, // Confirmação da transação
    2: DataEvents.data, // Código da função SiTef
    10: DataEvents.menuOptions, // Opções de menu de navegação
    100: DataEvents.getFieldCurrency, // Modalidade de pagamento
    5000: DataEvents.getField, // Aguardando leitura do cartão
    5001: DataEvents.getFieldPassword, // Aguardando senha
    5002: DataEvents.messageCashier, // Mensagem para o operador
    5003: DataEvents.messageCustomer, // Mensagem para o cliente
    5004: DataEvents.messageCashierCustomer, // Mensagem para ambos
    5005: DataEvents.data, // Transação finalizada
    5006: DataEvents.confirmation, // Confirmação de dados
    5007: DataEvents.data, // Conectado ao SiTef
    5008: DataEvents.data, // Conectando ao SiTef
    5009: DataEvents.data, // Consulta realizada com sucesso
    5010: DataEvents.headerShow, // Exibir cabeçalho
    5011: DataEvents.data, // Coleta de novo produto
    5012: DataEvents.removeQrCodeField, // Remove QR Code
    5020: DataEvents.confirmGoBack, // Confirmação de retorno
    5030: DataEvents.getFieldCurrency, // Valor monetário
    5031: DataEvents.getFieldCheque, // Número do cheque
    5034: DataEvents.getFieldBarCode, // Código de barras
    5035: DataEvents.getMaskedField, // Campo mascarado
    5040: DataEvents.pressAnyKey, // Pressione qualquer tecla
    5050: DataEvents.abortRequest, // Cancelamento de transação
    6000: DataEvents.menuTitle, // Título do menu
    6001: DataEvents.showQrCodeField, // Exibir QR Code
    // Adicionar outros mapeamentos conforme identificados
  };
}
