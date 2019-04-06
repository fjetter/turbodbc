#!/bin/bash
set -exo pipefail
export ODBCSYSINI=${PWD}/travis/${ODBC_DIR}
echo "================================================================="
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv activate turbodbc
echo $(which python)
printenv
echo "================================================================="

ls ${PYENV_VIRTUAL_ENV}/
ls ${PYENV_VIRTUAL_ENV}/lib/
ls ${PYENV_VIRTUAL_ENV}/lib/*
ls ${PYENV_VIRTUAL_ENV}/lib/*/site-packages/
mkdir build && cd build

if [ "${TURBODBC_USE_CONDA}" == "yes" ]; then
    export UNIXODBC_INCLUDE_DIR=$CONDA_PREFIX/include
    # Install correct MS SQL driver path
    odbcinst -i -d -f /opt/microsoft/msodbcsql17/etc/odbcinst.ini
    cmake -DBOOST_ROOT=$CONDA_PREFIX -DBUILD_COVERAGE=ON -DCMAKE_INSTALL_PREFIX=./dist  -DPYTHON_EXECUTABLE=`which python` -GNinja ..
    ninja
else
    cmake -DBUILD_COVERAGE=ON -DCMAKE_INSTALL_PREFIX=./dist -DPYBIND11_PYTHON_VERSION=${TRAVIS_PYTHON_VERSION} ..
    make -j4
fi

if [ "$TRAVIS_OS_NAME" == "osx" ]; then
    ctest -E turbodbc_arrow_unit_test --verbose
else
    ctest --verbose
fi

cd ..
mkdir gcov
cd gcov
gcov -l -p `find ../build -name "*.gcda"` > /dev/null
echo "Removing coverage for boost and C++ standard library"
find . -name "*#boost#*" | xargs rm
find . -name "*#c++#*" | xargs rm
cd ..
cd python/turbodbc_test/
echo "Uploading Python coverage"
bash <(curl -s https://codecov.io/bash) -s $PWD/gcov/ -s $PWD -X gcov
cd ../..
echo "Uploading C++ coverage"
bash <(curl -s https://codecov.io/bash) -s $PWD/gcov/ -X coveragepy -X gcov

cd build
cmake --build . --target install
cd dist
python setup.py sdist

if [ "${TURBODBC_USE_CONDA}" != "yes" ]; then
    cd dist
    pip install *.tar.gz
    cd ..
fi
rm -rf dist
