#!/bin/bash
mkdir /run/php-fpm
php-fpm --allow-to-run-as-root --nodaemonize
