/// SDK CliSiTef para totem de auto atendimento
/// Baseado na especificação oficial CliSiTef versão 248
library agente_clisitef;

// Core
export 'src/core/constants/clisitef_constants.dart';
export 'src/core/exceptions/clisitef_exception.dart';
export 'src/core/services/message_manager.dart';

// Models
export 'src/models/clisitef_config.dart';
export 'src/models/transaction_data.dart';
export 'src/models/transaction_response.dart';
export 'src/models/transaction_result.dart';
export 'src/models/captura_tardia_transaction.dart';
export 'src/models/cancelation_data.dart';
export 'src/models/clisitef_response.dart';

// Repositories
export 'src/repositories/clisitef_repository.dart';
export 'src/repositories/clisitef_repository_impl.dart';

// Services
export 'src/services/clisitef_core_service.dart';
export 'src/services/clisitef_pinpad_service.dart' hide CardReadResult, PasswordReadResult;
export 'src/services/clisitef_service_agente.dart';
export 'src/services/clisitef_service_captura_tardia.dart';
export 'src/services/clisitef_cancelamento_service.dart';
export 'src/services/pinpad_service.dart' show PinPadService, CardReadResult, PasswordReadResult;
export 'src/services/core/start_transaction_usecase.dart';
