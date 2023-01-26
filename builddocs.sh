#!/bin/bash

# IMPORTANT: the following python modules must be installed before running this script
# pip install mkdocs-material-extensions
# pip install mkdocs-material
# pip install pymdown-extensions

# Build and run docs server locally on https://127.0.0.1:8000

rm -rf site
mkdocs build --verbose --clean --strict --site-dir site
mkdocs serve