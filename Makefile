# Variables
APP = purplesky
REPO = sudhanshuraheja
ENV_PREFIX = PURPLESKY_

TAG = $(shell git describe --always --abbrev --tags --long)
TAG_EXISTS = $(shell docker images | grep $(TAG) | grep $(APP) | awk 'END {print NR}')
APP_EXISTS = $(shell docker ps -a | grep $(APP).app | awk 'END {print NR}')

# Colours
NO_COLOR = \x1b[0m
GRAY_COLOR = \x1b[30;01m
RED_COLOR = \x1b[31;01m
# GREEN_COLOR = \x1b[32;01m
YELLOW_COLOR = \x1b[33;01m
BLUE_COLOR = \x1b[34;01m
# FIVE_COLOR = \x1b[35;01m
GREEN_COLOR = \x1b[36;01m
WHITE_COLOR = \x1b[37;01m


create:
	hugo new site . --force

dev:
	hugo server -D

local:
	hugo -b http://localhost:3000

prod:
	hugo -b https://purplesky.io

caddy:
	caddy run

build:
	@echo "$(BLUE_COLOR)➤ Building image $(APP):$(TAG) $(NO_COLOR)"
ifeq '$(TAG_EXISTS)' '0'
	docker build -t $(APP):$(TAG) .
	docker tag $(APP):$(TAG) $(APP):latest
else
	@echo "$(RED_COLOR)➤ Image $(APP):$(TAG) already exists$(NO_COLOR)"
endif

rmi:
	@echo "$(BLUE_COLOR)➤ Removing image $(REPO):$(TAG) $(NO_COLOR)"
	docker rmi $(APP):$(TAG) -f
	docker rmi $(APP):latest -f

run:
	@echo "$(BLUE_COLOR)➤ Run the container $(NO_COLOR)"
	docker run -d -p 3000:3000 --name $(APP) $(APP)

exec:
	@echo "$(BLUE_COLOR)➤ Exec into the container $(NO_COLOR)"
	docker exec -it $(APP) sh

logs:
	@echo "$(BLUE_COLOR)➤ Tailing container logs $(NO_COLOR)"
	docker logs -f $(APP)

stop:
	@echo "$(BLUE_COLOR)➤ Stop the container $(NO_COLOR)"
	docker stop $(APP)

# Clean
clean: rmi
	@echo "$(BLUE_COLOR)➤ Clean up$(NO_COLOR)"
	docker rm -f $(shell docker ps -a -q)
	docker rmi -f $(shell docker images -q)
