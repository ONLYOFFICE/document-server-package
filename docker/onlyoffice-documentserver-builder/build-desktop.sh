#!/bin/bash

BUILD_DIR=/var/lib/onlyoffice

cd $BUILD_DIR/desktop-apps/win-linux
mkdir -p build/Release
cd build/Release

qmake ../../ASCDocumentEditor.pro -r -spec linux-g++

make clean && make
