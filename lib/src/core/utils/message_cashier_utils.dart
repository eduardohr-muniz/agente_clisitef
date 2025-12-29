import 'package:agente_clisitef/agente_clisitef.dart';

class MessageCashierUtils {
  static void parseMessage(int commandId, String message) {
    if (message.isEmpty) return;
    switch (commandId) {
      case 1:
        AgenteClisitefMessageManager.instance.messageOperator.value = message;
        break;
      case 2:
        AgenteClisitefMessageManager.instance.messageCashier.value = message;
        break;
      case 3:
        AgenteClisitefMessageManager.instance.messageCashier.value = message;
        AgenteClisitefMessageManager.instance.messageOperator.value = message;
        break;
      case 11:
        AgenteClisitefMessageManager.instance.messageOperator.value = '';
        break;
      case 12:
        AgenteClisitefMessageManager.instance.messageCashier.value = '';
        break;
      case 13:
        AgenteClisitefMessageManager.instance.messageCashier.value = '';
        AgenteClisitefMessageManager.instance.messageOperator.value = '';
        break;
      default:
        break;
    }
  }
}
