#!/bin/bash
set -exo pipefail

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv activate turbodbc
fi

if [ "${TURBODBC_USE_CONDA}" != "yes" ]; then
    pip install \
        coveralls \
        mock \
        numpy==1.14.5 \
        pandas \
        pyarrow==$TURBODBC_ARROW_VERSION \
        pytest-cov \
        six \
        twine
fi
