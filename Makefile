APP_RUNNING = $(shell docker inspect -f {{.State.Running}} locusttestapi_app_1)

# Show command line help message
help:
	@echo "The following commands are available:"
	@echo ""
	@echo "make run:			Run local development server inside container."
	@echo "make test:			Run tests."
	@echo "make run-locust:		Run the locust server inside container."
	@echo "make stop:			Stop all assoicated running containers."

db:
	docker-compose -f docker-db.yml up -d --no-recreate

run: db
	docker-compose -f docker-app.yml up --no-recreate

run-locust:
ifneq ($(APP_RUNNING), true)
	gnome-terminal -e "make run"
	bash -c "sleep 1"
endif

	docker-compose -f docker-locust.yml up -d --no-recreate

run-nikto:
ifneq ($(APP_RUNNING), true)
	gnome-terminal -e "make run"
	bash -c "sleep 1"
endif

	docker-compose -f docker-nikto.yml up


test: db
	docker-compose -f docker-test.yml up

stop:
	docker ps -a | grep 'locusttestapi' | awk '{print $1}' | xargs docker stop
