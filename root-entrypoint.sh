#!/bin/bash

set -ex

# Run ssh-server
service ssh start

# Workaround for avoid volume permission error
if [ -z ${USER_ID} ]; then
    echo 'ERROR! Variable "USER_ID" is not defined!'
    exit 1
fi
usermod -u ${USER_ID} httpd

# Run entrypoint for httpd user
exec gosu httpd httpd-entrypoint.sh "$@"