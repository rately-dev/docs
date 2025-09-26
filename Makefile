dev:
	docker-compose -f docker-compose.yaml up --build

devd:
	docker-compose down --remove-orphans