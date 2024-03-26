CREATE SCHEMA inventory;

CREATE TABLE inventory.customers (
    id serial primary key,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL
);
ALTER TABLE ONLY inventory.customers REPLICA IDENTITY FULL;

INSERT INTO inventory.customers VALUES (1001, 'Sally', 'Thomas', 'sally.thomas@acme.com');
INSERT INTO inventory.customers VALUES (1002, 'George', 'Bailey', 'gbailey@foobar.com');
INSERT INTO inventory.customers VALUES (1003, 'Edward', 'Walker', 'ed@walker.com');
INSERT INTO inventory.customers VALUES (1004, 'Anne', 'Kretchmar', 'annek@noanswer.org');

SELECT pg_catalog.setval('inventory.customers_id_seq', 1004, true);