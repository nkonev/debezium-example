CREATE TABLE first_test_table
(
	`key` String,
	`price` UInt64,
	`version` UInt64,
	`deleted` UInt8
)
ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY key;

CREATE TABLE customers(
    id Int32 NOT NULL,
    first_name String NOT NULL,
    last_name String NOT NULL,
    email String NOT NULL,
    PRIMARY KEY(id)
) ENGINE = MergeTree;