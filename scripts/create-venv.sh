#!/usr/bin/env bash
set -e

if [[ -z "${PIP_INSTALL}" ]]; then
    PIP_INSTALL='install'
fi

# Directory of *this* script
this_dir="$( cd "$( dirname "$0" )" && pwd )"
src_dir="$(realpath "${this_dir}/..")"

# -----------------------------------------------------------------------------

# Path to virtual environment
: "${venv:=${src_dir}/.venv}"

# Python binary to use
: "${PYTHON=python3}"

python_version="$(${PYTHON} --version)"

# Create virtual environment
echo "Creating virtual environment at ${venv} (${python_version})"
rm -rf "${venv}"
"${PYTHON}" -m venv "${venv}"
source "${venv}/bin/activate"

# Install Python dependencies
echo "Installing Python dependencies"
pip3 ${PIP_INSTALL} --upgrade pip
pip3 ${PIP_INSTALL} --upgrade wheel setuptools

pip3 ${PIP_INSTALL} -f 'https://synesthesiam.github.io/prebuilt-apps/' "${src_dir}"

# Development dependencies
if [[ -f requirements_dev.txt ]]; then
    pip3 ${PIP_INSTALL} -r requirements_dev.txt || echo "Failed to install development dependencies" >&2
fi

# -----------------------------------------------------------------------------

echo "OK"
