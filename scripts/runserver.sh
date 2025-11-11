#!/bin/bash

cd "$(dirname "$0")/.."

VENV_PATH=$(poetry env info --path)

echo "🐍 Ativando ambiente virtual: $VENV_PATH"
source "$VENV_PATH/bin/activate"

echo "📄 Carregando variáveis do .env..."
export $(grep -v '^#' .env | xargs -d '\n')

echo "📦 Instalando dependências via Poetry..."
poetry install

echo "⚙️ Aplicando migrações do banco..."
python manage.py migrate

echo "🚀 Servidor iniciado em http://localhost:8000"
python manage.py runserver 0.0.0.0:8000
