FROM quay.io/debezium/connect:2.6.0.Final
# https://clickhouse.com/docs/en/integrations/kafka/clickhouse-kafka-connect-sink
RUN curl -Ss --location --url 'https://github.com/ClickHouse/clickhouse-kafka-connect/releases/download/v1.0.17/clickhouse-kafka-connect-v1.0.17.zip' > /tmp/ckc.zip \
    && unzip -d /kafka/connect /tmp/ckc.zip \
    && rm -f /tmp/ckc.zip
