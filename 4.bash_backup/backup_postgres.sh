#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST="192.168.x.x"
REMOTE_SSH_USER="user"
REMOTE_DIR="/remote_dir"
VOLUME_NAME="postgres_data" #docker volume ls
USE_MINIO=false  #опционально
MINIO_BUCKET="bucket_name"
MINIO_ENDPOINT="http://localhost:9000"

BACKUP_NAME="pg_backup_$(date +%Y%m%d_%H%M%S).sql.gz"
LOCAL_BACKUP_PATH="/tmp/${BACKUP_NAME}"

if ! docker volume inspect "$VOLUME_NAME" &>/dev/null; then
  echo "Ошибка: Docker volume '$VOLUME_NAME' не найден." >&2
  exit 1
fi

echo "Бэкапим volume '$VOLUME_NAME' → $LOCAL_BACKUP_PATH ..."
docker run --rm \
  -v "${VOLUME_NAME}":/pgdata \
  alpine:3 sh -c "cd /pgdata && tar -czf - . " > "$LOCAL_BACKUP_PATH"

echo "Копируем на сервер $REMOTE_HOST:$REMOTE_DIR ..."
scp "$LOCAL_BACKUP_PATH" "${REMOTE_SSH_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

if [[ "$USE_MINIO" == "true" ]]; then
  echo "☁️ Загружаем бэкап в MinIO..."
  aws --endpoint-url "$MINIO_ENDPOINT" \
    s3 cp "$LOCAL_BACKUP_PATH" "s3://${MINIO_BUCKET}/$BACKUP_NAME"
fi

echo " Бэкап завершён"

