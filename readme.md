https://github.com/debezium/debezium-examples/tree/main/tutorial#using-postgres

# Replication via Kafka Connect
```bash
# Start the topology as defined in https://debezium.io/documentation/reference/stable/tutorial.html
docker-compose up -d --build

# Consume messages from a Debezium topic
docker exec -it kafka /opt/kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server kafka:9092 \
    --from-beginning \
    --property print.key=true \
    --topic dbserver1.inventory.customers

# Modify records in the database via Postgres client
docker exec -it -e PGOPTIONS="--search_path=inventory" postgres  psql -U postgres postgres
insert into customers (first_name, last_name, email) values ('Nikita', 'Konev', 'nkonev@example.com');
update customers set first_name = 'Nikita 2' where id = 1005;
delete from customers where id = 1005;

# see in Clickhouse
docker exec -it clickhouse clickhouse client
select * from customers;

optimize table customers final cleanup;
# or
select * from customers final;
# or
select * from customers limit 1 by id;
# or - remove duplicates and hide deleted wiv limit by
select * from customers prewhere deleted = 0 order by version desc limit 1 by id;
# show updated - filter out old versions
# https://clickhouse.com/docs/en/sql-reference/statements/select/limit-by
select * from customers prewhere deleted = 0 order by version desc limit 1 by id limit 2;


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

# Links
* https://clickhouse.com/blog/clickhouse-postgresql-change-data-capture-cdc-part-1
* https://clickhouse.com/blog/clickhouse-postgresql-change-data-capture-cdc-part-2
* https://clickhouse.com/docs/en/engines/table-engines/mergetree-family/replacingmergetree
* https://clickhouse.com/blog/handling-updates-and-deletes-in-clickhouse
* https://itnext.io/using-postgresql-pgoutput-plugin-for-change-data-capture-with-debezium-on-azure-845d3bb2787a
* https://github.com/abhirockzz/debezium-postgres-pgoutput
