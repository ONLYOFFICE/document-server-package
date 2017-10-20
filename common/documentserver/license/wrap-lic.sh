#!/bin/sh
find . -name LICENSE.txt -exec sh -c "fold -s -w80 {} > {}.tmp && mv {}.tmp {}" \;
