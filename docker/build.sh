#!/bin/sh
set -eux
docker-compose down
docker-compose build common
docker-compose build "$PACKAGE_MANAGER"
docker-compose up "$PACKAGE_MANAGER"
