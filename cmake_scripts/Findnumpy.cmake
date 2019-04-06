# This script provides include directories for numpy

find_path(
    Numpy_INCLUDE_DIR
    numpy/npy_common.h
    HINTS
        $ENV{PYENV_VIRTUAL_ENV}/lib/*/site-packages/numpy/core/include
        $ENV{VIRTUAL_ENV}/lib/*/site-packages/numpy/core/include
        $ENV{CONDA_PREFIX}/lib/*/site-packages/numpy/core/include
        ENV PYTHON_INCLUDE_DIR
        /usr/local/lib/python2.7/dist-packages/numpy/core/include
        $ENV{PYTHON}/lib/site-packages/numpy/core/include
    DOC "Path to the numpy headers"
)

