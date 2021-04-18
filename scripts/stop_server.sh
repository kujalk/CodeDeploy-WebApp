#!/bin/bash
isExistApp=`pgrep htppd`
if [[ -n  $isExistApp ]]; then
    service httpd stop
fi
