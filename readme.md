https://github.com/debezium/debezium-examples/tree/main/tutorial#using-postgres

# Replication via Kafka Connect
```bash
# Start the topology as defined in https://debezium.io/documentation/reference/stable/tutorial.html
docker-compose up -d --build

# Consume messages from a Debezium topic
docker-compose exec kafka /opt/kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic dbserver1.inventory.customers

# Modify records in the database via Postgres client
docker exec -it postgres env PGOPTIONS="--search_path=inventory" bash -c 'psql -U postgres postgres'
insert into customers (first_name, last_name, email) values ('Nikita', 'Konev', 'nkonev@example.com');

# see in Clickhouse
docker exec -it clickhouse clickhouse client
select * from customers;


-- for tests
insert into customers_mv(id, first_name, last_name, email) values (1, 'Nikita', 'Konev', 'nkonev@example.com');
insert into customers_changes(`after.id`, `after.first_name`, `after.last_name`, `after.email`) values (1, 'Nikita', 'Konev', 'nkonev@example.com');

# Shut down the cluster
docker-compose down
```


# Experimental Replication w/o Kafka & Debezium
https://clickhouse.com/docs/en/integrations/postgresql#using-the-materializedpostgresql-database-engine
```
# PostgreSQL

docker exec -i -t postgres psql -U postgres
CREATE ROLE clickhouse_user SUPERUSER LOGIN PASSWORD 'ClickHouse_123';
CREATE DATABASE db1;
\connect db1
CREATE TABLE table1 (
    id         integer primary key,
    column1    varchar(10)
);

INSERT INTO table1
(id, column1)
VALUES
(1, 'abc'),
(2, 'def');

select * from pg_replication_slots;


# Clickhouse
docker exec -it clickhouse clickhouse client
SET allow_experimental_database_materialized_postgresql=1;

CREATE DATABASE db1_postgres
ENGINE = MaterializedPostgreSQL('postgres:5432', 'db1', 'clickhouse_user', 'ClickHouse_123')
SETTINGS materialized_postgresql_tables_list = 'table1';

select * from db1_postgres.table1;


# Then in PostgreSQL
INSERT INTO table1
(id, column1)
VALUES                    
(3, 'ghi'),
(4, 'jkl');

# Then in Clickhouse (after some time, ~2 sec)
select * from db1_postgres.table1;
```
