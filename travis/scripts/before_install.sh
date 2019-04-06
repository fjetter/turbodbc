#!/bin/bash
set -exo pipefail

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    eval "$(pyenv init -)"
    pyenv install ${TRAVIS_PYTHON_VERSION}
    pyenv virtualenv ${TRAVIS_PYTHON_VERSION} turbodbc
    pyenv activate turbodbc
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
