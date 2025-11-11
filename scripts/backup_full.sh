#!/usr/bin/env bash
# =======================================================
# backup_full.sh — Backup incremental genérico
# Autor: mandr (Soeirotech)
# =======================================================

# Detecta o projeto automaticamente (nome da pasta atual)
PROJECT_NAME=$(basename "$(pwd)")
SOURCE_DIR="$(pwd)"
DEST_DIR="$HOME/dev/backup/$PROJECT_NAME"
TIMESTAMP=$(date +%Y-%m)
LOG_FILE="$DEST_DIR/${PROJECT_NAME}_backup.log"

# Cores
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# Lista de nomes de versão por mês
VERSIONS=("primeiro" "segundo" "terceiro" "quarto" "quinto" "sexto" "sétimo" "oitavo" "nono" "décimo")

echo -e "${CYAN}🚀 Iniciando backup do projeto: ${PROJECT_NAME}${RESET}"
echo "Data: $(date)" | tee -a "$LOG_FILE"

# Verifica se o diretório de origem existe
if [ ! -d "$SOURCE_DIR" ]; then
  echo -e "${RED}❌ Diretório de origem não encontrado: $SOURCE_DIR${RESET}" | tee -a "$LOG_FILE"
  exit 1
fi

# Cria pasta de destino específica do projeto
mkdir -p "$DEST_DIR"

# Determina próxima versão disponível
index=0
while [ -d "$DEST_DIR/backup_${TIMESTAMP}.${VERSIONS[$index]}" ]; do
  ((index++))
done

# Se ultrapassar o limite de nomes, gera numerado
if [ $index -ge ${#VERSIONS[@]} ]; then
  VERSION="extra_$((index+1))"
else
  VERSION="${VERSIONS[$index]}"
fi

TARGET_DIR="$DEST_DIR/backup_${TIMESTAMP}.${VERSION}"

echo -e "📦 Próximo backup: ${CYAN}${TARGET_DIR}${RESET}"
echo "Destino: $TARGET_DIR" | tee -a "$LOG_FILE"

# Executa o backup
rsync -avh --progress "$SOURCE_DIR/" "$TARGET_DIR" | tee -a "$LOG_FILE"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Backup '${VERSION}' concluído com sucesso!${RESET}" | tee -a "$LOG_FILE"
  echo -e "📁 Local: ${CYAN}$TARGET_DIR${RESET}"
else
  echo -e "${RED}❌ Ocorreu um erro durante o backup.${RESET}" | tee -a "$LOG_FILE"
  exit 1
fi

# (Opcional) Compactar automaticamente
read -p "Deseja compactar o backup em .tar.gz? (s/n): " compress
if [[ "$compress" =~ ^[Ss]$ ]]; then
  echo -e "${CYAN}📦 Compactando backup...${RESET}" | tee -a "$LOG_FILE"
  tar -czf "${TARGET_DIR}.tar.gz" -C "$DEST_DIR" "$(basename "$TARGET_DIR")"
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Arquivo compactado: ${TARGET_DIR}.tar.gz${RESET}" | tee -a "$LOG_FILE"
  else
    echo -e "${RED}❌ Falha ao compactar.${RESET}" | tee -a "$LOG_FILE"
  fi
fi

echo "----------------------------------------" | tee -a "$LOG_FILE"
echo "Backup finalizado em: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
