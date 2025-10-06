#!/bin/bash

# Script para executar testes do serviço de cancelamento
# 
# Este script facilita a execução dos testes unitários e E2E
# do serviço de cancelamento CliSiTef.

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
    echo "🧪 Testes do ClisitefCancelamentoService"
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

# Função para executar testes unitários
run_unit_tests() {
    print_info "Executando testes unitários..."
    
    if flutter test test/clisitef_cancelamento_service_test.dart --reporter=expanded; then
        print_success "Testes unitários executados com sucesso"
    else
        print_error "Falha nos testes unitários"
        return 1
    fi
}

# Função para executar teste manual
run_manual_test() {
    print_info "Executando teste manual..."
    
    if dart test/run_tests.dart; then
        print_success "Teste manual executado com sucesso"
    else
        print_error "Falha no teste manual"
        return 1
    fi
}

# Função para executar testes específicos
run_specific_tests() {
    local test_name="$1"
    print_info "Executando teste específico: $test_name"
    
    if flutter test test/clisitef_cancelamento_service_test.dart --name "$test_name"; then
        print_success "Teste '$test_name' executado com sucesso"
    else
        print_error "Falha no teste '$test_name'"
        return 1
    fi
}

# Função para mostrar ajuda
show_help() {
    echo "Uso: $0 [opção] [argumento]"
    echo ""
    echo "Opções:"
    echo "  unit                    - Executar apenas testes unitários"
    echo "  manual                  - Executar apenas teste manual"
    echo "  specific <nome>         - Executar teste específico"
    echo "  all                     - Executar todos os testes (padrão)"
    echo "  help                    - Mostrar esta ajuda"
    echo ""
    echo "Exemplos:"
    echo "  $0                      # Executar todos os testes"
    echo "  $0 unit                 # Executar apenas testes unitários"
    echo "  $0 manual               # Executar apenas teste manual"
    echo "  $0 specific \"Processamento de Comandos\"  # Executar teste específico"
    echo ""
    echo "Grupos de teste disponíveis:"
    echo "  - Inicialização e Configuração"
    echo "  - Processamento de Comandos"
    echo "  - Processamento de FieldIds"
    echo "  - Validação de Interação"
    echo "  - Fluxo de Cancelamento E2E"
    echo "  - Tratamento de Erros"
    echo "  - Limpeza e Dispose"
    echo "  - Cenários de Integração"
    echo "  - Testes de Performance"
}

# Função principal
main() {
    print_header
    
    # Verificar argumentos
    case "${1:-all}" in
        "unit")
            print_info "Executando apenas testes unitários..."
            check_dependencies
            run_unit_tests
            ;;
        "manual")
            print_info "Executando apenas teste manual..."
            check_dependencies
            run_manual_test
            ;;
        "specific")
            if [ -z "$2" ]; then
                print_error "Nome do teste específico não fornecido"
                echo "Use: $0 specific \"Nome do Teste\""
                exit 1
            fi
            print_info "Executando teste específico: $2"
            check_dependencies
            run_specific_tests "$2"
            ;;
        "all")
            print_info "Executando todos os testes..."
            check_dependencies
            run_unit_tests
            run_manual_test
            ;;
        "help"|"-h"|"--help")
            show_help
            exit 0
            ;;
        *)
            print_error "Opção inválida: $1"
            echo "Use '$0 help' para ver as opções disponíveis"
            exit 1
            ;;
    esac
    
    print_success "Todos os testes concluídos com sucesso!"
    echo ""
    echo "📊 Para mais informações, consulte: test/README_TESTS.md"
}

# Executar função principal
main "$@"
