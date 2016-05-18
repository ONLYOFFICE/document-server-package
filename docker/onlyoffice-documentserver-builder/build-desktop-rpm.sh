#!/bin/bash

BUILD_DIR=/var/lib/onlyoffice

cd $BUILD_DIR/desktop-apps/win-linux/package/linux/
SVN_TAG=default
export SVN_TAG
make COMPANY_NAME=onlyoffice PLATFORM=linux_64 clean qt-redist rpm