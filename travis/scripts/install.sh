#!/bin/bash
set -euxo pipefail
if [ "${TURBODBC_USE_CONDA}" != "yes" ]; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    pyenv activate turbodbc
    pip install numpy==1.14.5 pyarrow==$TURBODBC_ARROW_VERSION six twine pytest-cov coveralls pandas
fi
