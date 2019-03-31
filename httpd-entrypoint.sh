#!/bin/bash

set -ex

if [ -z ${REPOSITORIES} ]; then
    echo 'ERROR! Variable "REPOSITORIES" is not defined!'
    exit 1
fi

cd /home/httpd/git/repos/

for repository_name in ${REPOSITORIES}; do
    if [[ ! -d ${repository_name}.git ]]; then
        echo "Initializing repository ${repository_name}"
        git init --bare ${repository_name}.git
    else
        echo "Using exist ${repository_name} repository"
    fi
done

exec "$@"