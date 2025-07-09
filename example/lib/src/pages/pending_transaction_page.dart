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
        // Verificar se precisa de interação do usuário
        final response = pendingTransaction.originalResponse;
        if (response.command != null && response.shouldContinue) {
          _showInteractionDialog(response);
        }
      }
    } catch (e) {
      // Erro tratado pelo MessageManager
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
      // final result = await _controller.confirmTransaction();
      // Mensagens tratadas pelo MessageManager
    } catch (e) {
      // Erro tratado pelo MessageManager
    }
  }

  /// Cancela a transação
  Future<void> _cancelTransaction() async {
    try {
      // final result = await _controller.cancelTransaction();
      // Mensagens tratadas pelo MessageManager
    } catch (e) {
      // Erro tratado pelo MessageManager
    }
  }

  /// Simula emissão de cupom
  Future<void> _simulateCupom() async {
    try {
      await _controller.simulateCupomEmission();
      // Mensagens tratadas pelo MessageManager
    } catch (e) {
      // Erro tratado pelo MessageManager
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
