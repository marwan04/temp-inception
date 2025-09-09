# **************************************************************************** #
#                                   Makefile                                   #
# **************************************************************************** #

COMPOSE = docker-compose -f srcs/docker-compose.yml

all: up

up:
	@$(COMPOSE) up -d --build

down:
	@$(COMPOSE) down

clean:
	@$(COMPOSE) down -v --remove-orphans

fclean: clean
	@docker system prune -af --volumes

re: fclean all

logs:
	@$(COMPOSE) logs -f

ps:
	@$(COMPOSE) ps
