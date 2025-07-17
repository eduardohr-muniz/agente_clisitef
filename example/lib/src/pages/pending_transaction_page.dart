import 'package:flutter/material.dart';
import 'package:agente_clisitef/agente_clisitef.dart';
import 'controllers/pending_transaction_controller.dart';
import 'widgets/status_card.dart';
import 'widgets/transaction_fields_card.dart';
import 'widgets/configuration_card.dart';
import 'widgets/transaction_data_card.dart';
import 'widgets/action_buttons_card.dart';
import 'widgets/interaction_dialog.dart';
import 'widgets/message_display_widget.dart';

class PendingTransactionPage extends StatefulWidget {
  const PendingTransactionPage({super.key});

  @override
  State<PendingTransactionPage> createState() => _PendingTransactionPageState();
}

class _PendingTransactionPageState extends State<PendingTransactionPage> {
  late final PendingTransactionController _controller;
  String _selectedTransactionType = 'PIX';

  @override
  void initState() {
    super.initState();
    _controller = PendingTransactionController();
    _controller.addListener(_onControllerChanged);
    _controller.initializeService();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  /// Inicia uma transação pendente
  Future<void> _startTransaction() async {
    try {
      final pendingTransaction = await _controller.startPendingTransaction(_selectedTransactionType);

      if (pendingTransaction != null) {
        _showSuccessSnackbar('🚀 Transação $_selectedTransactionType iniciada!');

        // Verificar se precisa de interação do usuário
        final response = pendingTransaction.originalResponse;
        if (response.command != null && response.shouldContinue) {
          _showInteractionDialog(response);
        }
      } else {
        _showErrorSnackbar('❌ Falha ao iniciar transação');
      }
    } catch (e) {
      _showErrorSnackbar('❌ Erro ao iniciar transação: ${e.toString()}');
    }
  }

  /// Continua a transação com dados do usuário
  Future<void> _continueTransaction(String data) async {
    try {
      final result = await _controller.continueTransaction(data);

      if (result != null) {
        if (result.isServiceSuccess) {
          if (result.shouldContinue) {
            _showInteractionDialog(result);
          }
          // Mensagens tratadas pelo MessageManager
        }
      }
    } catch (e) {
      // Erro tratado pelo MessageManager
    }
  }

  /// Confirma a transação
  Future<void> _confirmTransaction() async {
    try {
      final result = await _controller.confirmTransaction();

      if (result != null && result.isServiceSuccess) {
        _showSuccessSnackbar('✅ Transação confirmada com sucesso!');
      } else {
        _showErrorSnackbar('❌ Erro ao confirmar transação');
      }
    } catch (e) {
      _showErrorSnackbar('❌ Erro ao confirmar: ${e.toString()}');
    }
  }

  /// Cancela a transação
  Future<void> _cancelTransaction() async {
    try {
      final result = await _controller.cancelTransaction();

      if (result != null && result.isServiceSuccess) {
        _showSuccessSnackbar('✅ Transação cancelada com sucesso!');
      } else {
        _showErrorSnackbar('❌ Erro ao cancelar transação');
      }
    } catch (e) {
      _showErrorSnackbar('❌ Erro ao cancelar: ${e.toString()}');
    }
  }

  /// Simula emissão de cupom
  Future<void> _simulateCupom() async {
    try {
      await _controller.simulateCupomEmission();
      _showSuccessSnackbar('📄 Cupom fiscal emitido com sucesso!');
    } catch (e) {
      _showErrorSnackbar('❌ Erro ao emitir cupom: ${e.toString()}');
    }
  }

  /// Cancela operação em progresso pelo operador
  Future<void> _cancelOperationInProgress() async {
    // Confirmar cancelamento com o usuário
    final shouldCancel = await _showCancelConfirmationDialog();
    if (!shouldCancel) return;

    try {
      final result = await _controller.cancelOperationInProgress();

      if (result) {
        _showSuccessSnackbar('🛑 Operação cancelada pelo operador');
      } else {
        _showErrorSnackbar('❌ Falha ao cancelar operação');
      }
    } catch (e) {
      _showErrorSnackbar('❌ Erro ao cancelar: ${e.toString()}');
    }
  }

  /// Exibe diálogo de interação
  void _showInteractionDialog(TransactionResponse response) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => InteractionDialog(
        response: response,
        onContinue: _continueTransaction,
      ),
    );
  }

  /// Mostra diálogo de confirmação para cancelar operação
  Future<bool> _showCancelConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('🛑 Cancelar Operação'),
            content: const Text(
              'Tem certeza que deseja cancelar a operação em progresso?\n\n'
              'Esta ação irá interromper o processo atual e resetar a sessão.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Não'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Sim, Cancelar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Exibe snackbar de sucesso
  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  /// Exibe snackbar de erro
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações Pendentes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Message Display Widget
            const MessageDisplayWidget(),
            const SizedBox(height: 16),

            // Status Card
            StatusCard(
              sessionId: _controller.sessionId,
              hasPendingTransaction: _controller.hasPendingTransaction,
              isTransactionFinalized: _controller.isTransactionFinalized,
            ),
            const SizedBox(height: 16),

            // Transaction Fields Card
            if (_controller.hasPendingTransaction) ...[
              TransactionFieldsCard(
                pendingTransaction: _controller.pendingTransaction!,
              ),
              const SizedBox(height: 16),
            ],

            // Configuration Card
            ConfigurationCard(
              serverIPController: _controller.serverIPController,
              storeIdController: _controller.storeIdController,
              terminalIdController: _controller.terminalIdController,
            ),
            const SizedBox(height: 16),

            // Transaction Data Card
            TransactionDataCard(
              selectedTransactionType: _selectedTransactionType,
              amountController: _controller.amountController,
              cupomFiscalController: _controller.cupomFiscalController,
              operatorController: _controller.operatorController,
              onTransactionTypeChanged: (value) {
                setState(() {
                  _selectedTransactionType = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Action Buttons Card
            ActionButtonsCard(
              isLoading: _controller.isLoading,
              hasPendingTransaction: _controller.hasPendingTransaction,
              isTransactionFinalized: _controller.isTransactionFinalized,
              onStartTransaction: _startTransaction,
              onSimulateCupom: _simulateCupom,
              onConfirmTransaction: _confirmTransaction,
              onCancelTransaction: _cancelTransaction,
            ),
            const SizedBox(height: 16),

            // Botão de Cancelamento de Operação em Progresso
            if (_controller.isLoading) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cancelamento de Operação',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Use este botão para cancelar operações que estão em loop ou travadas.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _cancelOperationInProgress,
                        icon: const Icon(Icons.stop),
                        label: const Text('🛑 CANCELAR OPERAÇÃO'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Instructions Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Como Usar',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Configure os dados do servidor\n'
                      '2. Preencha os dados da transação\n'
                      '3. Clique em "Iniciar Transação Pendente"\n'
                      '4. Acompanhe as mensagens em tempo real\n'
                      '5. Simule a emissão do cupom fiscal\n'
                      '6. Confirme ou cancele a transação',
                    ),
                  ],
                ),
              ),
            ),

            // Loading Indicator
            if (_controller.isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
