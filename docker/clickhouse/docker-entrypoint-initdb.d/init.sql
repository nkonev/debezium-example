CREATE TABLE first_test_table
(
	`key` String,
	`price` UInt64,
	`version` UInt64,
	`deleted` UInt8
)
ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY key;


-- https://clickhouse.com/blog/clickhouse-postgresql-change-data-capture-cdc-part-2#configuring-debezium
CREATE TABLE customers(
    id Int32 NOT NULL,
    first_name String NOT NULL,
    last_name String NOT NULL,
    email String NOT NULL,
    PRIMARY KEY(id)
) ENGINE = MergeTree;

-- mapping from kafka topic's values onto clickhouse table
CREATE TABLE customers_changes
(
    `before.id` Nullable(Int32),
    `before.first_name` Nullable(String),
    `before.last_name` Nullable(String),
    `before.email` Nullable(String),

    `after.id` Int32 NOT NULL,
    `after.first_name` String NOT NULL,
    `after.last_name` String NOT NULL,
    `after.email` String NOT NULL,

    `op` LowCardinality(String),
    `ts_ms` UInt64,
    `source.sequence` String,
    `source.lsn` UInt64
)
ENGINE = Null;

CREATE MATERIALIZED VIEW customers_mv TO customers
(
   `id` Int32 not null,
   `first_name` String not null,
   `last_name` String not null,
   `email` String not null
) AS
SELECT
    if(op = 'd', before.id, after.id) AS id,
    if(op = 'd', before.first_name, after.first_name) AS first_name,
    if(op = 'd', before.last_name, after.last_name) AS last_name,
    if(op = 'd', before.email, after.email) AS email,

    if(op = 'd', source.lsn, source.lsn) AS version,
    if(op = 'd', 1, 0) AS deleted
FROM default.customers_changes
WHERE (op = 'c') OR (op = 'r') OR (op = 'u') OR (op = 'd');
