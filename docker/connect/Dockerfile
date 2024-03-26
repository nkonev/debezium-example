FROM quay.io/debezium/connect:2.6.0.Beta1
# https://clickhouse.com/docs/en/integrations/kafka/clickhouse-kafka-connect-sink
RUN curl -Ss --location --url 'https://github.com/ClickHouse/clickhouse-kafka-connect/releases/download/v1.0.15/clickhouse-kafka-connect-v1.0.15.zip' > /tmp/ckc.zip
RUN unzip -d /kafka/connect /tmp/ckc.zip
RUN rm -f /tmp/ckc.zip