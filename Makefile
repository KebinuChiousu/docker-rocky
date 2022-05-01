build:
	docker build -t meredithkm/rocky:8 -t meredithkm/rocky .
rebuild:
	docker build --no-cache -t meredithkm/rocky .
start:
	docker-compose up -d
stop:
	docker-compose down
destroy:
	sudo rm -rf $(shell docker inspect docker-rocky_home | jq '.[].Mountpoint' -r)
	docker-compose down -v
check:
	docker-compose ps
shell:  
	docker exec -it rocky-ssh /bin/bash
network-create:
	docker network create --driver bridge --subnet "240.20.0.0/24" --gateway "240.20.0.1" docker-lan
network-destroy:
	docker network rm docker-lan
