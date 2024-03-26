set -e
echo 'creating postgres connector'
http_code=$(curl -Ss -o /dev/null -w '%{http_code}' --connect-timeout 5 --max-time 5 -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' --url 'http://connect:8083/connectors/' -d @/opt/create-debezium-connectors/connector-postgres.json)
echo "http_code=$http_code"
if [ "$http_code" != "201" ] && [ "$http_code" != "409" ]; then
  echo "exit because of wrong code during creating postgres connector";
  exit 1;
fi

echo 'creating clickhouse connector'
http_code=$(curl -Ss -o /dev/null -w '%{http_code}' --connect-timeout 5 --max-time 5 -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' --url 'http://connect:8083/connectors/' -d @/opt/create-debezium-connectors/connector-clickhouse.json)
echo "http_code=$http_code"
if [ "$http_code" != "201" ] && [ "$http_code" != "409" ]; then
  echo "exit because of wrong code during creating clickhouse connector";
  exit 1;
fi
