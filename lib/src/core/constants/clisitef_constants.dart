// ignore_for_file: constant_identifier_names

class CliSiTefConstants {
  // URLs e Endpoints
  static const String DEFAULT_BASE_URL = 'https://127.0.0.1/agente';
  static const String START_TRANSACTION_ENDPOINT = '/clisitef/startTransaction';
  static const String CONTINUE_TRANSACTION_ENDPOINT = '/clisitef/continueTransaction';
  static const String FINISH_TRANSACTION_ENDPOINT = '/clisitef/finishTransaction';
  static const String SESSION_ENDPOINT = '/clisitef/session';
  static const String STATE_ENDPOINT = '/clisitef/state';
  static const String GET_VERSION_ENDPOINT = '/clisitef/getVersion';

  // PinPad Endpoints
  static const String PINPAD_OPEN_ENDPOINT = '/clisitef/pinpad/open';
  static const String PINPAD_CLOSE_ENDPOINT = '/clisitef/pinpad/close';
  static const String PINPAD_IS_PRESENT_ENDPOINT = '/clisitef/pinpad/isPresent';
  static const String PINPAD_READ_YES_NO_ENDPOINT = '/clisitef/pinpad/readYesNo';
  static const String PINPAD_SET_DISPLAY_MESSAGE_ENDPOINT = '/clisitef/pinpad/setDisplayMessage';

  // Valores padrão
  static const String DEFAULT_SITEF_IP = '127.0.0.1';
  static const String DEFAULT_STORE_ID = '00000000';
  static const String DEFAULT_TERMINAL_ID = 'PD000001';
  static const String DEFAULT_OPERATOR = 'CAIXA';

  // Códigos de função (Tabela 5.2.2)
  static const int FUNCTION_GENERIC_PAYMENT = 0;
  static const int FUNCTION_CHECK = 1;
  static const int FUNCTION_DEBIT = 2;
  static const int FUNCTION_CREDIT = 3;
  static const int FUNCTION_FININVEST = 4;
  static const int FUNCTION_BENEFIT_CARD = 5;
  static const int FUNCTION_CENTRALIZED_CREDIT = 6;
  static const int FUNCTION_FUEL_CARD = 7;
  static const int FUNCTION_PARCELE_MAIS = 8;
  static const int FUNCTION_MEAL_BENEFIT = 10;
  static const int FUNCTION_FOOD_BENEFIT = 11;
  static const int FUNCTION_INFOCARD = 12;
  static const int FUNCTION_PAY_PASS = 13;
  static const int FUNCTION_GIFT_CARD = 15;
  static const int FUNCTION_DEBIT_INSTALLMENT = 16;
  static const int FUNCTION_CREDIT_INSTALLMENT = 17;
  static const int FUNCTION_QUALITY_CARD = 28;
  static const int FUNCTION_TELEMARKETING = 100;
  static const int FUNCTION_QUALITY_CARD_CANCEL = 101;

  // Códigos de retorno
  static const int SUCCESS = 0;
  static const int CONTINUE_TRANSACTION = 10000;
  static const int CONFIG_SUCCESS = 0;
  static const int TRANSACTION_NOT_INITIALIZED = -1;
  static const int TRANSACTION_INTERNAL_ERROR = -100;

  // Estados do serviço
  static const int SERVICE_STATUS_OK = 0;
  static const int SERVICE_STATUS_ERROR = 1;

  // Estados do AgenteCliSiTef
  static const int AGENT_STATE_IDLE = 0;
  static const int AGENT_STATE_BUSY = 1;

  // Limites e tamanhos
  static const int MAX_CUPOM_LENGTH = 20;
  static const int MAX_OPERATOR_LENGTH = 20;
  static const int MAX_AMOUNT_LENGTH = 15;
  static const int MAX_SESSION_ID_LENGTH = 32;

  // Timeouts padrão
  static const int DEFAULT_TIMEOUT_SECONDS = 30;
  static const int DEFAULT_PINPAD_TIMEOUT_SECONDS = 60;

  // Formatos de data e hora
  static const String DATE_FORMAT = 'yyyyMMdd';
  static const String TIME_FORMAT = 'HHmmss';
  static const String AMOUNT_FORMAT = '0.00';

  // Mensagens padrão
  static const String MSG_SERVICE_NOT_INITIALIZED = 'Serviço não inicializado';
  static const String MSG_INVALID_CONFIGURATION = 'Configuração inválida';
  static const String MSG_TRANSACTION_ERROR = 'Erro na transação';
  static const String MSG_PINPAD_ERROR = 'Erro no PinPad';
  static const String MSG_NETWORK_ERROR = 'Erro de rede';
  static const String MSG_TIMEOUT_ERROR = 'Timeout na operação';

  // Headers HTTP
  static const String HEADER_CONTENT_TYPE = 'Content-Type';
  static const String HEADER_ACCEPT = 'Accept';
  static const String CONTENT_TYPE_FORM = 'application/x-www-form-urlencoded';
  static const String CONTENT_TYPE_JSON = 'application/json';

  // Parâmetros de configuração (novos nomes em inglês)
  static const String PARAM_SITEF_IP = 'sitefIp';
  static const String PARAM_STORE_ID = 'storeId';
  static const String PARAM_TERMINAL_ID = 'terminalId';
  static const String PARAM_FUNCTION_ID = 'functionId';
  static const String PARAM_TRN_AMOUNT = 'trnAmount';
  static const String PARAM_TAX_INVOICE_NUMBER = 'taxInvoiceNumber';
  static const String PARAM_TAX_INVOICE_DATE = 'taxInvoiceDate';
  static const String PARAM_TAX_INVOICE_TIME = 'taxInvoiceTime';
  static const String PARAM_CASHIER_OPERATOR = 'cashierOperator';
  static const String PARAM_TRN_ADDITIONAL_PARAMETERS = 'trnAdditionalParameters';
  static const String PARAM_TRN_INIT_PARAMETERS = 'trnInitParameters';
  static const String PARAM_SESSION_ID = 'sessionId';
  static const String PARAM_SESSION_PARAMETERS = 'sessionParameters';
  static const String PARAM_DISPLAY_MESSAGE = 'displayMessage';
  static const String PARAM_CONTINUE = 'continue';

  // Respostas de serviço
  static const String RESPONSE_SERVICE_STATUS = 'serviceStatus';
  static const String RESPONSE_SERVICE_MESSAGE = 'serviceMessage';
  static const String RESPONSE_CLISITEF_STATUS = 'clisitefStatus';
  static const String RESPONSE_SESSION_ID = 'sessionId';
  static const String RESPONSE_SERVICE_STATE = 'serviceState';

  // Comandos para continueTransaction
  static const int COMMAND_DISPLAY_MESSAGE = 0;
  static const int COMMAND_COLLECT_AMOUNT = 1;
  static const int COMMAND_COLLECT_OPERATOR = 2;
  static const int COMMAND_COLLECT_CUPOM = 3;
  static const int COMMAND_COLLECT_DATE = 4;
  static const int COMMAND_COLLECT_TIME = 5;
  static const int COMMAND_COLLECT_ADDITIONAL = 6;
  static const int COMMAND_COLLECT_PASSWORD = 7;
  static const int COMMAND_COLLECT_CARD = 8;
  static const int COMMAND_COLLECT_YES_NO = 9;
  static const int COMMAND_COLLECT_MENU = 10;
  static const int COMMAND_COLLECT_FLOAT = 30;
  static const int COMMAND_COLLECT_FLOAT_EXTENDED = 34;
  static const int COMMAND_COLLECT_HASH_SEED = 29;
  static const int COMMAND_COLLECT_CARD_READER = 13;
  static const int COMMAND_COLLECT_YES_NO_EXTENDED = 22;

  // Tipos de campo
  static const int FIELD_TYPE_STRING = 0;
  static const int FIELD_TYPE_NUMERIC = 1;
  static const int FIELD_TYPE_AMOUNT = 2;
  static const int FIELD_TYPE_DATE = 3;
  static const int FIELD_TYPE_TIME = 4;
  static const int FIELD_TYPE_PASSWORD = 5;
  static const int FIELD_TYPE_CARD = 6;
  static const int FIELD_TYPE_MENU = 7;
  static const int FIELD_TYPE_YES_NO = 8;
  static const int FIELD_TYPE_FLOAT = 9;
  static const int FIELD_TYPE_HASH = 10;
  static const int FIELD_TYPE_MASKED = 11;
  static const int FIELD_TYPE_ENCRYPTED = 12;

  // Eventos especiais
  static const int EVENT_CARD_INSERTED = 1000;
  static const int EVENT_CARD_REMOVED = 1001;
  static const int EVENT_PINPAD_READY = 1002;
  static const int EVENT_PINPAD_BUSY = 1003;
  static const int EVENT_TRANSACTION_START = 1004;
  static const int EVENT_TRANSACTION_END = 1005;
  static const int EVENT_ERROR = 1006;
  static const int EVENT_TIMEOUT = 1007;
  static const int EVENT_CANCEL = 1008;
  static const int EVENT_CONFIRM = 1009;

  // Códigos de erro específicos
  static const int ERROR_MISSING_PARAMETER = -10;
  static const int ERROR_ITERATIVE_EXECUTION = -12;
  static const int ERROR_DOCUMENT_NOT_FOUND = -13;
  static const int ERROR_OPERATION_CANCELLED = -15;
  static const int ERROR_INVALID_PARAMETER = -20;
  static const int ERROR_FORBIDDEN_WORD = -21;
  static const int ERROR_BANK_CORRESPONDENT = -25;
  static const int ERROR_FILE_ACCESS = -30;
  static const int ERROR_SITEF_DENIED = -40;
  static const int ERROR_INVALID_DATA = -41;
  static const int ERROR_RESERVED = -42;
  static const int ERROR_PINPAD_EXECUTION = -43;
  static const int ERROR_UNSAFE_TRANSACTION = -50;
}
