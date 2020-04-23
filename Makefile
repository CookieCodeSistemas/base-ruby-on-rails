# Variables
COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m
COLOR_ERROR   = \033[0;31m
PROD = false
DC = docker-compose

setup:
	@echo "$(COLOR_INFO)==> Building docker images ..."
	    @$(DC) build

	@echo "$(COLOR_INFO)==> Starting docker images ..."
	    @$(DC) up -d --remove-orphans

	@echo "$(COLOR_INFO)==> Downloading Gemfile dependencies ..."
	    @$(DC) exec api bundle install

	@echo "$(COLOR_INFO)==> Creating postgres database ..."
	    @$(DC) exec api rails db:create
	    @$(DC) exec api rails db:migrate
		@$(DC) exec api rails db:seed
		@$(DC) exec api rails db:populate


	@echo "$(COLOR_INFO)==> Serving Rails API ..."
	    @$(DC) exec -d api rails s -b=0.0.0.0

	@echo "$(COLOR_COMMENT)==> API RUNNING: http://localhost:80"
	@echo "$(COLOR_COMMENT)==> ADMINER RUNNING: http://localhost:8080 \n\t \n\t with this credentials: \n\t username: postgres\n\t password: postgres"

start:
	@$(DC) stop
	@echo "$(COLOR_INFO)==> Starting docker images ..."
	    @$(DC) up -d

	@echo "$(COLOR_INFO)==> Serving Rails API ..."
	    @$(DC) exec -d api rails s -b=0.0.0.0

	@echo "$(COLOR_COMMENT)==> API RUNNING: http://localhost:80"
	@echo "$(COLOR_COMMENT)==> ADMINER RUNNING: http://localhost:8080\n\t \n\t with this credentials: \n\t username: postgres\n\t password: postgres"

stop:
	@echo "$(COLOR_INFO)==> Stopin docker images ..."
	    @$(DC) stop

upgrade:
	@echo "$(COLOR_INFO)==> Downloading Gemfile dependencies ..."
	    @$(DC) exec api bundle install

	@echo "$(COLOR_INFO)==> Updating postgres database ..."
		@$(DC) exec api rails db:migrate
		@$(DC) exec api rails db:seed
		@$(DC) exec api rails db:populate

reset_db:
	@echo "$(COLOR_INFO)==> Reseting postgres database ..."
		@$(DC) exec api rails db:drop
		@$(DC) exec api rails db:create
		@$(DC) exec api rails db:migrate
		@$(DC) exec api rails db:seed
		@$(DC) exec api rails db:populate
