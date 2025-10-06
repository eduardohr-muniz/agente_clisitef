#!/bin/bash

# Script para executar testes E2E do serviço de cancelamento CliSiTef
# 
# Este script facilita a execução dos testes end-to-end,
# incluindo verificação de dependências e configurações.

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "🧪 Testes E2E - Serviço de Cancelamento CliSiTef"
    echo "=================================================="
    echo -e "${NC}"
}

# Função para verificar dependências
check_dependencies() {
    print_info "Verificando dependências..."
    
    # Verificar Flutter
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter não encontrado. Instale o Flutter primeiro."
        exit 1
    fi
    
    # Verificar Dart
    if ! command -v dart &> /dev/null; then
        print_error "Dart não encontrado. Instale o Dart primeiro."
        exit 1
    fi
    
    print_success "Dependências verificadas com sucesso"
}

# Função para verificar configuração
check_configuration() {
    print_info "Verificando configuração..."
    
    # Verificar se o arquivo de configuração existe
    if [ ! -f "test/e2e_config.yaml" ]; then
        print_warning "Arquivo de configuração não encontrado. Usando configurações padrão."
    else
        print_success "Arquivo de configuração encontrado"
    fi
    
    # Verificar se o diretório de logs existe
    if [ ! -d "logs" ]; then
        print_info "Criando diretório de logs..."
        mkdir -p logs
    fi
}

# Função para executar testes unitários
run_unit_tests() {
    print_info "Executando testes unitários E2E..."
    
    if flutter test test/clisitef_cancelamento_service_e2e_test.dart --reporter=expanded; then
        print_success "Testes unitários executados com sucesso"
    else
        print_error "Falha nos testes unitários"
        return 1
    fi
}

# Função para executar teste manual
run_manual_test() {
    print_info "Executando teste manual E2E..."
    
    if dart test/run_e2e_test.dart; then
        print_success "Teste manual executado com sucesso"
    else
        print_error "Falha no teste manual"
        return 1
    fi
}

# Função para gerar relatório
generate_report() {
    print_info "Gerando relatório de testes..."
    
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local report_file="logs/e2e_report_${timestamp}.txt"
    
    cat > "$report_file" << EOF
Relatório de Testes E2E - CliSiTef Cancelamento
===============================================
Data: $(date)
Executado por: $(whoami)
Sistema: $(uname -a)

Resultados:
- Testes Unitários: $([ $? -eq 0 ] && echo "✅ Sucesso" || echo "❌ Falha")
- Teste Manual: $([ $? -eq 0 ] && echo "✅ Sucesso" || echo "❌ Falha")

Configuração:
- IP: 127.0.0.1
- Store ID: 00000000
- Terminal ID: REST0001
- Operador: CAIXA

Logs disponíveis em: ./logs/
EOF

    print_success "Relatório gerado: $report_file"
}

# Função para limpar recursos
cleanup() {
    print_info "Limpando recursos..."
    
    # Limpar arquivos temporários
    find . -name "*.tmp" -delete 2>/dev/null || true
    
    print_success "Limpeza concluída"
}

# Função principal
main() {
    print_header
    
    # Verificar argumentos
    case "${1:-all}" in
        "unit")
            print_info "Executando apenas testes unitários..."
            check_dependencies
            check_configuration
            run_unit_tests
            ;;
        "manual")
            print_info "Executando apenas teste manual..."
            check_dependencies
            check_configuration
            run_manual_test
            ;;
        "all")
            print_info "Executando todos os testes..."
            check_dependencies
            check_configuration
            run_unit_tests
            run_manual_test
            ;;
        "help"|"-h"|"--help")
            echo "Uso: $0 [opção]"
            echo ""
            echo "Opções:"
            echo "  unit     - Executar apenas testes unitários"
            echo "  manual   - Executar apenas teste manual"
            echo "  all      - Executar todos os testes (padrão)"
            echo "  help     - Mostrar esta ajuda"
            echo ""
            echo "Exemplos:"
            echo "  $0           # Executar todos os testes"
            echo "  $0 unit      # Executar apenas testes unitários"
            echo "  $0 manual    # Executar apenas teste manual"
            exit 0
            ;;
        *)
            print_error "Opção inválida: $1"
            echo "Use '$0 help' para ver as opções disponíveis"
            exit 1
            ;;
    esac
    
    generate_report
    cleanup
    
    print_success "Todos os testes concluídos com sucesso!"
    echo ""
    echo "📊 Relatórios disponíveis em: ./logs/"
    echo "📝 Logs detalhados em: ./logs/e2e_test_$(date +%Y-%m-%d).log"
}

# Capturar sinais para limpeza
trap cleanup EXIT INT TERM

# Executar função principal
main "$@"
