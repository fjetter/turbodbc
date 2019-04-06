#!/bin/bash
set -exo pipefail
if [ "$TRAVIS_OS_NAME" == "linux" ]; then
    $TRAVIS_BUILD_DIR/travis/setup_test_dbs.sh
    if [ "${TURBODBC_USE_CONDA}" == "yes" ]; then
        docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=StrongPassword1' -p 1433:1433 --name mssql1 -d mcr.microsoft.com/mssql/server:2017-latest
        sudo bash -c 'curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -'
        sudo bash -c 'curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list'
        sudo apt-get update
        sudo ACCEPT_EULA=Y apt-get install msodbcsql17
        dpkg -L msodbcsql17
        docker exec -it mssql1 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'StrongPassword1' -Q 'CREATE DATABASE test_db'
    fi
fi
