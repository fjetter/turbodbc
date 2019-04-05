#!/bin/bash
set -euxo pipefail
if [ "${TURBODBC_USE_CONDA}" != "yes" ]; then
    pip install numpy==1.14.5 pyarrow==$TURBODBC_ARROW_VERSION six twine pytest-cov coveralls pandas
fi
