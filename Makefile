QYH_ENV := staging
QYH_REPO := git@github.com:chinabeishi/QYH-service.git
WORK_DIR := ～/work
DOCKER_COMPOSE_DIR := ./deploy/$(QYH_ENV)

all: setup start

$(WORK_DIR):
	git clone $(QYH_REPO) $@

setup: $(WORK_DIR)
	sudo yum -y install \
		docker \
		golang \
		docker-compose \
		;

start:
	sudo systemctl start docker.service
	cd $(DOCKER_COMPOSE_DIR) && sudo docker-compose up -d
	sleep 2
	$(PROJECT_ROOT)/qyhctl.sh build
	QYH_ENV=$(QYH_ENV) $(PROJECT_ROOT)/qyhctl.sh start

stop:
	$(PROJECT_ROOT)/qyhctl.sh stop
	cd $(DOCKER_COMPOSE_DIR) && sudo docker-compose down
	sudo systemctl stop docker.service

clean:
	sudo rm -rf /usr/local/bin/docker-compose
	sudo rm -rf /etc/docker/daemon.json
	sudo yum -y remove docker
