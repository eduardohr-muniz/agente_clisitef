import 'package:agente_clisitef/agente_clisitef.dart';
import 'package:agente_clisitef/src/core/exceptions/clisitef_error_codes.dart';
import 'package:flutter_test/flutter_test.dart';

/// Crédito parcelado loja no fluxo automático do [StartTransactionUseCase].
///
/// As respostas roteirizadas seguem a sequência real capturada no totem
/// (função 3, menu `1:A Vista;2:Parcelado Loja;3:Crediario;`).
void main() {
  const sessionId = '68725582';
  const menuFormaPagamento = '1:A Vista;2:Parcelado Loja;3:Crediario;';

  TransactionResponse continuar({int command = 0, int fieldId = -1, String data = ''}) {
    return TransactionResponse(
      serviceStatus: 0,
      clisitefStatus: 10000,
      sessionId: sessionId,
      command: command,
      fieldType: fieldId,
      buffer: data,
      message: data,
    );
  }

  const fimDoFluxo = TransactionResponse(serviceStatus: 0, clisitefStatus: 0, sessionId: sessionId);

  TransactionData credito({int? installments}) {
    final agora = DateTime(2026, 10, 9, 14, 30);
    return TransactionData.payment(
      functionId: 3,
      trnAmount: 100,
      taxInvoiceNumber: '123',
      taxInvoiceDate: agora,
      taxInvoiceTime: agora,
      installments: installments,
    );
  }

  /// Sequência real: título do menu, menu de forma de pagamento, pergunta do
  /// número de parcelas (só quando parcelado) e o campo 100 de modalidade.
  List<TransactionResponse> roteiroCredito({
    String menu = menuFormaPagamento,
    bool perguntaParcelas = true,
    String? modalidade,
  }) {
    return [
      continuar(command: 4, data: 'Selecione a forma de pagamento'),
      continuar(command: 21, data: menu),
      if (perguntaParcelas) continuar(command: 30, fieldId: 505, data: 'Numero de parcelas'),
      continuar(command: 14),
      if (modalidade != null) continuar(fieldId: 100, data: modalidade),
      fimDoFluxo,
    ];
  }

  Future<(StartTransactionResult, _RepositorioRoteirizado)> executar(
    TransactionData data,
    List<TransactionResponse> roteiro,
  ) async {
    final repositorio = _RepositorioRoteirizado(inicio: continuar(command: 0, fieldId: 170, data: '1'), roteiro: roteiro);
    final useCase = StartTransactionUseCase(repositorio, useSmartPixSelection: true);
    final resultado = await useCase.execute(data: data, stopBeforeFinish: true);
    return (resultado, repositorio);
  }

  group('StartTransactionUseCase | à vista (sem parcelas) |', () {
    test('menu de forma de pagamento continua respondendo 1 (A Vista)', () async {
      final (resultado, repositorio) = await executar(credito(), roteiroCredito(perguntaParcelas: false));

      expect(resultado.isSuccess, true);
      expect(resultado.isPending, true);
      expect(repositorio.respostaAoComando(21), '1');
      expect(repositorio.finalizacoes, isEmpty);
    });

    test('seleção inteligente de PIX não muda', () async {
      final (_, repositorio) = await executar(
        credito(),
        [continuar(command: 21, data: '1:Ticket;2:PIX;'), fimDoFluxo],
      );

      expect(repositorio.respostaAoComando(21), '2');
    });
  });

  group('StartTransactionUseCase | parcelado loja |', () {
    test('escolhe Parcelado Loja no menu e responde a quantidade de parcelas', () async {
      final (resultado, repositorio) = await executar(credito(installments: 3), roteiroCredito());

      expect(resultado.isSuccess, true);
      expect(resultado.isPending, true);
      expect(repositorio.respostaAoComando(21), '2');
      expect(repositorio.respostaAoComando(30), '3');
      expect(repositorio.finalizacoes, isEmpty);
    });

    test('aceita o texto "Parcelado Estabelecimento" e nunca escolhe administradora', () async {
      final (resultado, repositorio) = await executar(
        credito(installments: 2),
        roteiroCredito(menu: '1:A Vista;2:Parcelado Administradora;3:Parcelado Estabelecimento;'),
      );

      expect(resultado.isSuccess, true);
      expect(repositorio.respostaAoComando(21), '3');
      expect(repositorio.respostaAoComando(30), '2');
    });

    test('ignora acentos e caixa no texto do menu', () async {
      final (resultado, repositorio) = await executar(
        credito(installments: 2),
        roteiroCredito(menu: '1:À VISTA;2:PARCELADO LOJA;'),
      );

      expect(resultado.isSuccess, true);
      expect(repositorio.respostaAoComando(21), '2');
    });

    test('menus que não são de forma de pagamento seguem o comportamento padrão', () async {
      final (resultado, repositorio) = await executar(credito(installments: 3), [
        continuar(command: 21, data: '1:Visa;2:Mastercard;'),
        ...roteiroCredito(),
      ]);

      expect(resultado.isSuccess, true);
      expect(repositorio.respostasAoComando(21), ['1', '2']);
    });

    test('campo 100 confirmando parcelado loja (0202) conclui com sucesso', () async {
      final (resultado, repositorio) = await executar(credito(installments: 3), roteiroCredito(modalidade: '0202'));

      expect(resultado.isSuccess, true);
      expect(repositorio.finalizacoes, isEmpty);
    });
  });

  group('StartTransactionUseCase | parcelado loja | nunca cai em à vista |', () {
    test('menu sem Parcelado Loja aborta a transação no CliSiTef', () async {
      final (resultado, repositorio) = await executar(
        credito(installments: 3),
        roteiroCredito(menu: '1:A Vista;2:Crediario;'),
      );

      expect(resultado.isSuccess, false);
      expect(resultado.errorMessage, contains('Parcelado Loja'));
      expect(repositorio.continuacoes.last.continueCode, -1);
      expect(repositorio.continuacoes.any((continuacao) => continuacao.data == '1' && continuacao.command == 21), false);
    });

    test('fluxo sem menu de forma de pagamento desfaz a transação pendente', () async {
      final (resultado, repositorio) = await executar(
        credito(installments: 3),
        [continuar(command: 14), fimDoFluxo],
      );

      expect(resultado.isSuccess, false);
      expect(repositorio.finalizacoes, [false]);
    });

    test('sem a pergunta do número de parcelas desfaz a transação pendente', () async {
      final (resultado, repositorio) = await executar(
        credito(installments: 3),
        roteiroCredito(perguntaParcelas: false),
      );

      expect(resultado.isSuccess, false);
      expect(resultado.errorMessage, contains('parcelas'));
      expect(repositorio.finalizacoes, [false]);
    });

    test('campo 100 indicando à vista (0200) desfaz a transação pendente', () async {
      final (resultado, repositorio) = await executar(credito(installments: 3), roteiroCredito(modalidade: '0200'));

      expect(resultado.isSuccess, false);
      expect(resultado.errorMessage, contains('0200'));
      expect(repositorio.finalizacoes, [false]);
    });
  });

  group('CliSiTefServiceCapturaTardia | parcelado loja |', () {
    Future<(CliSiTefServiceCapturaTardia, _RepositorioRoteirizado)> criarServico(List<TransactionResponse> roteiro) async {
      final repositorio = _RepositorioRoteirizado(inicio: continuar(command: 0, fieldId: 170, data: '1'), roteiro: roteiro);
      final servico = CliSiTefServiceCapturaTardia(
        config: const CliSiTefConfig(sitefIp: '127.0.0.1', storeId: '00000000', terminalId: 'REST0001'),
        repository: repositorio,
      );
      await servico.initialize();
      return (servico, repositorio);
    }

    test('repassa as parcelas para o fluxo automático', () async {
      final (servico, repositorio) = await criarServico(roteiroCredito(modalidade: '0202'));

      final transacao = await servico.startPendingTransaction(credito(installments: 3));

      expect(transacao, isNotNull);
      expect(repositorio.respostaAoComando(21), '2');
      expect(repositorio.respostaAoComando(30), '3');
    });

    test('falha do parcelado vira CliSiTefException que não é de cancelamento', () async {
      final (servico, _) = await criarServico(roteiroCredito(menu: '1:A Vista;2:Crediario;'));

      await expectLater(
        servico.startPendingTransaction(credito(installments: 3)),
        throwsA(
          isA<CliSiTefException>()
              .having((erro) => CliSiTefErrorCode.isCancellationCode(erro.errorCode.code), 'cancelamento', false)
              .having((erro) => erro.toString(), 'mensagem', contains('Parcelado Loja')),
        ),
      );
    });
  });

  group('TransactionData | installments |', () {
    test('não é enviado ao AgenteCliSiTef', () {
      final mapa = credito(installments: 3).toMap();

      expect(mapa.values.join(';'), isNot(contains('installments')));
      expect(mapa.keys, isNot(contains('installments')));
    });

    test('copyWith preserva as parcelas', () {
      expect(credito(installments: 3).copyWith(sessionId: 'abc').installments, 3);
      expect(credito(installments: 3).copyWith(installments: 2).installments, 2);
      expect(credito().copyWith(sessionId: 'abc').installments, isNull);
    });

    test('igualdade considera as parcelas', () {
      expect(credito(installments: 3), credito(installments: 3));
      expect(credito(installments: 3), isNot(credito(installments: 2)));
    });

    test('menos de 2 parcelas é inválido', () {
      expect(credito(installments: 1).isValid, false);
      expect(credito(installments: 0).isValid, false);
      expect(credito(installments: 2).isValid, true);
      expect(credito().isValid, true);
    });
  });
}

class _Continuacao {
  _Continuacao({required this.command, required this.data, required this.continueCode});

  final int command;
  final String? data;
  final int? continueCode;
}

/// Repositório que devolve respostas roteirizadas e grava o que o use case respondeu.
class _RepositorioRoteirizado implements CliSiTefRepository {
  _RepositorioRoteirizado({required this.inicio, required List<TransactionResponse> roteiro})
      : _roteiro = List.of(roteiro);

  final TransactionResponse inicio;
  final List<TransactionResponse> _roteiro;
  final List<_Continuacao> continuacoes = [];
  final List<bool> finalizacoes = [];

  List<String?> respostasAoComando(int command) => [
        for (final continuacao in continuacoes)
          if (continuacao.command == command) continuacao.data,
      ];

  String? respostaAoComando(int command) => respostasAoComando(command).single;

  @override
  Future<TransactionResponse> startTransaction(TransactionData data) async => inicio;

  @override
  Future<TransactionResponse> continueTransaction({
    required String sessionId,
    required int command,
    int? continueCode,
    String? data,
  }) async {
    continuacoes.add(_Continuacao(command: command, data: data, continueCode: continueCode));
    if (continueCode == -1) {
      return const TransactionResponse(serviceStatus: 0, clisitefStatus: -2, sessionId: '68725582');
    }
    return _roteiro.removeAt(0);
  }

  @override
  Future<TransactionResponse> finishTransaction({
    required String sessionId,
    required bool confirm,
    String? taxInvoiceNumber,
    String? taxInvoiceDate,
    String? taxInvoiceTime,
  }) async {
    finalizacoes.add(confirm);
    return const TransactionResponse(serviceStatus: 0, clisitefStatus: 0, sessionId: '68725582');
  }

  @override
  Future<TransactionResponse> createSession() async =>
      const TransactionResponse(serviceStatus: 0, clisitefStatus: 0, sessionId: '68725582');

  @override
  Future<TransactionResponse> deleteSession() async => const TransactionResponse(serviceStatus: 0, clisitefStatus: 0);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError('${invocation.memberName}');
}
