include .env
export

.PHONY: install up down add-hosts remove-hosts

# start a project
install:
	docker-compose up -d --build
	make add-hosts

# Destroy container and volumes
unistall:
	docker-compose down --remove-orphans --volumes
	make remove-hosts

# Up containers
up:
	docker-compose up -d
	make add-hosts
	@echo "Drupal URL: ${DRUPAL_HOST}"
	@echo "React URL: ${REACT_HOST}:3000"

# Down containers
down:
	docker-compose down
	make remove-hosts

# Open containers
shell:
	docker exec -it ${DRUPAL_CONTAINER_NAME} bash

shell-psg:
	docker exec -it ${POSTGRES_CONTAINER_NAME} bash

shell-react:
	docker exec -it ${REACT_CONTAINER_NAME} bash


# Helpers
add-hosts:
	@grep -q "${DRUPAL_HOST}" /etc/hosts || (echo "127.0.0.1 ${DRUPAL_HOST}" | sudo tee -a /etc/hosts && echo "Added ${DRUPAL_HOST} to /etc/hosts")
	@grep -q "${REACT_HOST}" /etc/hosts || (echo "127.0.0.1 ${REACT_HOST}" | sudo tee -a /etc/hosts && echo "Added ${REACT_HOST} to /etc/hosts")
	@echo "Drupal URL: ${DRUPAL_HOST}"
	@echo "React URL: ${REACT_HOST}:3000"

remove-hosts:
	@sudo sed -i "\#${DRUPAL_HOST}#d" /etc/hosts
	@sudo sed -i "\#${REACT_HOST}#d" /etc/hosts
