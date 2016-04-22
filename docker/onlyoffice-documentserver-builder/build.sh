#!/bin/bash

BUID_DIR=/var/lib/onlyoffice

#cd $BUID_DIR/sdkjs && make clean && make
cd $BUID_DIR/server && make clean && make
cd $BUID_DIR/document-server-integration/web/documentserver-example/nodejs && npm install
cd $BUID_DIR/package && rm -f documentserver documentserver-example && make deb
