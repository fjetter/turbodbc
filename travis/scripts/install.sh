#!/bin/bash
set -exo pipefail
if [ "$TRAVIS_OS_NAME" == "osx"]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv activate turbodbc
fi

if [ "${TURBODBC_USE_CONDA}" != "yes" ]; then
    pip install numpy==1.14.5 pyarrow==$TURBODBC_ARROW_VERSION six twine pytest-cov coveralls pandas
fi
