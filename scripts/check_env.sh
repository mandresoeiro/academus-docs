#!/usr/bin/env bash
# =======================================================
#  check_env.sh – Diagnóstico e ativação profissional do ambiente Python
#  Autor: João Mendes (mandresoeiro)
#  Uso:
#     ./check_env.sh         -> modo diagnóstico
#     source check_env.sh    -> ativa o ambiente local (.venv)
# =======================================================

set -e  # encerra o script se ocorrer algum erro

# --- Cores e ícones ---
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RED="\033[1;31m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}🔍 Verificando ambiente Python...${RESET}"
echo "----------------------------------------"

# --- Diretório e Python atual ---
CURRENT_DIR=$(pwd)
PYTHON_PATH=$(which python)
echo -e "📂 Diretório atual: ${YELLOW}$CURRENT_DIR${RESET}"
echo -e "🐍 Python atual: ${GREEN}$PYTHON_PATH${RESET}"

# --- Caminho esperado do .venv ---
VENV_PATH="$CURRENT_DIR/.venv/bin/python"

# --- Verifica se foi executado com 'source' ---
if [ "$0" = "${BASH_SOURCE[0]}" ]; then
    EXEC_MODE="direct"
else
    EXEC_MODE="sourced"
fi

# --- Cria o ambiente se não existir ---
if [ ! -d ".venv" ]; then
    echo -e "${YELLOW}💡 Nenhum ambiente virtual encontrado. Criando em .venv...${RESET}"
    python3 -m venv .venv
    echo -e "${GREEN}✅ Ambiente virtual criado com sucesso!${RESET}"
fi

# --- Verifica se o Python atual é o .venv ---
if [ "$PYTHON_PATH" = "$VENV_PATH" ]; then
    echo -e "${GREEN}✅ Você já está usando o ambiente virtual (.venv)${RESET}"
else
    echo -e "${YELLOW}⚠️  Você está usando o Python global do sistema${RESET}"
    echo -e "${CYAN}🔄 Tentando ativar o ambiente local (.venv)...${RESET}"

    if [ "$EXEC_MODE" = "direct" ]; then
        echo -e "${RED}❌ O ambiente não pode ser ativado automaticamente com './check_env.sh'${RESET}"
        echo -e "👉 Execute novamente com: ${BLUE}source check_env.sh${RESET}"
    else
        # Ativa o .venv no shell atual
        source .venv/bin/activate
        echo -e "${GREEN}✅ Ambiente virtual (.venv) ativado com sucesso!${RESET}"
    fi
fi

# --- Verificações adicionais ---
echo "----------------------------------------"
echo -e "📦 Pacotes instalados: ${CYAN}$(pip list --format=columns | wc -l)${RESET} (aprox.)"
echo -e "📁 Local do pip: ${BLUE}$(which pip)${RESET}"

# --- Verifica se VS Code está configurado ---
if [ -f ".vscode/settings.json" ]; then
    VSCODE_PATH=$(grep -o '".*\.venv[^"]*"' .vscode/settings.json | head -n 1 | tr -d '"')
    if [[ "$VSCODE_PATH" == *".venv"* ]]; then
        echo -e "🧭 VS Code configurado para: ${GREEN}$VSCODE_PATH${RESET}"
    else
        echo -e "⚠️  VS Code ainda não está apontando para o .venv local.${RESET}"
        echo -e "   Corrija com: ${BLUE}Ctrl+Shift+P → Python: Select Interpreter → .venv/bin/python${RESET}"
    fi
else
    echo -e "📁 VS Code config: ${YELLOW}.vscode/settings.json não encontrado${RESET}"
fi

echo "----------------------------------------"
echo -e "${CYAN}✅ Diagnóstico concluído.${RESET}"
