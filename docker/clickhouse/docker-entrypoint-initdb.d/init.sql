CREATE TABLE first_test_table
(
	`key` String,
	`price` UInt64,
	`version` UInt64,
	`deleted` UInt8
)
ENGINE = ReplacingMergeTree(version, deleted)
ORDER BY key;
