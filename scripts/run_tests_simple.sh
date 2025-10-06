#!/bin/bash

# Script simples para executar os testes do serviço de cancelamento

echo "🧪 Executando testes do ClisitefCancelamentoService..."
echo ""

# Executar testes unitários
echo "📋 Testes Unitários:"
flutter test test/clisitef_cancelamento_service_test.dart

echo ""
echo "🔧 Teste Manual:"
dart test/run_tests.dart

echo ""
echo "✅ Testes concluídos!"
