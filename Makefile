APP_ENV := prod
APP_REPO :=
WORK_DIR := ~/workspace
APP_NAME := accountservice
PROJECT_ROOT = $(WORK_DIR)/$(APP_NAME)
DOCKER_COMPOSE_DIR := ./deploy/$(APP_ENV)

all: setup start

setup:
	#git clone $(APP_REPO) $(PROJECT_ROOT)
	sudo yum -y install \
		docker \
		golang \
		docker-compose \
		;

start:
	sudo systemctl start docker.service
	cd $(DOCKER_COMPOSE_DIR) && sudo docker-compose up -d
	sleep 2
	cd $(PROJECT_ROOT) && ./server.sh build && APP_ENV=$(APP_ENV) ./server.sh start

stop:
	cd $(PROJECT_ROOT) && ./server.sh stop
	cd $(DOCKER_COMPOSE_DIR) && sudo docker-compose down
	sudo systemctl stop docker.service

clean:
	rm -rf $(PROJECT_ROOT)
	sudo rm -rf /usr/local/bin/docker-compose
	sudo yum -y remove docker
