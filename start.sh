#!/bin/bash

set -e

if [ ! -z "${SA_PASSWORD_FILE}" ] && [ -e ${SA_PASSWORD_FILE} ];
then
	echo "Setting SA_PASSWORD from ${SA_PASSWORD_FILE}"
    export SA_PASSWORD="$(cat ${SA_PASSWORD_FILE})"
fi

/opt/mssql/bin/sqlservr &

wait_for_pid=$!

until /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "${SA_PASSWORD}" -Q "SELECT 1" > /dev/null; do
	echo 'Waiting for sql server to start ...'
	sleep 1
done

if [ "$#" -ge 1 ] && [ ! -z "$1" ] && [ ! -f "$1" ]; then
	echo "Running init sql script: $1"
	/opt/mssql-tools/bin/sqlcmd \
		-S localhost -U SA -P "${SA_PASSWORD}" \
		-i "$1"
fi

echo 'DONE'

wait $wait_for_pid