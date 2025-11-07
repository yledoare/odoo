install -d docker
echo 'version: "3.1"
services:
  db'$ODOO':
    image: postgres:13
    ports:
      - "54'$ODOO':5432"
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_PASSWORD=odoo
      - POSTGRES_USER=odoo' > docker/docker-compose.yml


docker ps |grep docker-db$ODOO-1 

if [ $? = 1 ] && [ -e docker ]
then
	cd docker
	docker-compose up -d || docker compose up -d || exit 1
	cd ..
fi
