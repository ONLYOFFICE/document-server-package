#!/bin/bash

BUILD_DIR=/var/lib/onlyoffice

cd $BUILD_DIR/core && make clean && make all ext
