#!/bin/bash
set -exo pipefail
printenv
if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    brew update
    brew outdated pyenv || brew upgrade pyenv
    brew install unixodbc
    brew install pyenv-virtualenv
    brew install psqlodbc
    brew install readline xz
    brew uninstall openssl && brew install openssl
    # https://github.com/pyenv/pyenv/issues/993
    # about openssl
    export CFLAGS="-I$(brew --prefix openssl)/include $CFLAGS"
    export LDFLAGS="-L$(brew --prefix openssl)/lib $LDFLAGS"
    # ----------------------------------------

    eval "$(pyenv init -)"
    pyenv install ${TRAVIS_PYTHON_VERSION}
    pyenv virtualenv ${TRAVIS_PYTHON_VERSION} turbodbc
    pyenv activate turbodbc
    python --version
    pip install pytest mock


    echo "Setting up preinstalled PostgreSQL database"
    rm -rf /usr/local/var/postgres
    initdb /usr/local/var/postgres
    pg_ctl -D /usr/local/var/postgres -w start
    createuser -s postgres
    psql -U postgres -c 'CREATE DATABASE test_db;'
    psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'password';"
fi

if [ "${TURBODBC_USE_CONDA}" == "yes" ]; then
    MINICONDA_URL="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    wget --no-verbose -O miniconda.sh $MINICONDA_URL
    export MINICONDA=$HOME/miniconda
    bash miniconda.sh -b -p $MINICONDA
    source $MINICONDA/etc/profile.d/conda.sh
    conda config --remove channels defaults
    conda config --add channels conda-forge
    conda create -y -q -n turbodbc-dev pyarrow=$TURBODBC_ARROW_VERSION numpy pybind11 boost-cpp=1.68 \
        pytest pytest-cov mock cmake unixodbc coveralls gtest gmock python=3.7 \
        gxx_linux-64 gcc_linux-64 ninja make \
        -c conda-forge
    conda activate turbodbc-dev
fi
