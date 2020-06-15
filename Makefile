QYH_ENV := staging
QYH_REPO := git@github.com:chinabeishi/QYH-service.git
WORK_DIR := ~/work
APP_NAME := QYH-service
PROJECT_ROOT = $(WORK_DIR)/$(APP_NAME)
DOCKER_COMPOSE_DIR := ./deploy/$(QYH_ENV)

all: setup start

setup:
	git clone $(QYH_REPO) $(PROJECT_ROOT)
	sudo yum -y install \
		docker \
		golang \
		docker-compose \
		;

start:
	sudo systemctl start docker.service
	cd $(DOCKER_COMPOSE_DIR) && sudo docker-compose up -d
	sleep 2
	cd $(PROJECT_ROOT) && ./qyhctl.sh build && QYH_ENV=$(QYH_ENV) ./qyhctl.sh start

stop:
	cd $(PROJECT_ROOT) && ./qyhctl.sh stop
	cd $(DOCKER_COMPOSE_DIR) && sudo docker-compose down
	sudo systemctl stop docker.service

clean:
	rm -rf $(PROJECT_ROOT)
	sudo rm -rf /usr/local/bin/docker-compose
	sudo yum -y remove docker
