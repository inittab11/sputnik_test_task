ifndef ENV
  ENV=dev
endif

ifeq ($(ENV),dev)
  COMPOSE_FILES=-f docker-compose.yml -f docker-compose.dev.yml
else ifeq ($(ENV),prod)
  COMPOSE_FILES=-f docker-compose.yml -f docker-compose.prod.yml
else
  $(error Unknown ENV=$(ENV), use dev or prod)
endif

check-env:
	@echo "Проверяем обязательные переменные..."
	@bash -ec 'for v in BASE_DOMAIN REACT_APP_PATH REACT_APP_TEST_VAR POSTGRES_PASSWORD LETSENCRYPT_EMAIL; do : "$$${v:?Error: $${v} is not set}"; done'

up: check-env
	docker compose $(COMPOSE_FILES) up -d --build --wait

down:
	docker compose $(COMPOSE_FILES) down

status:
	docker compose $(COMPOSE_FILES) ps
