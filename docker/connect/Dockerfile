FROM debezium/connect:2.5.2.Final
RUN curl -Ss --location --url 'https://github.com/ClickHouse/clickhouse-kafka-connect/releases/download/v1.0.15/clickhouse-kafka-connect-v1.0.15.zip' > /tmp/ckc.zip
RUN unzip -d /kafka/connect /tmp/ckc.zip
RUN rm -f /tmp/ckc.zip