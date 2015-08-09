#!/bin/bash

exec 1>> ~/shutdown.log
exec 2>> ~/shutdown.log

date

set -e
set -x

export PATH=/usr/local/bin:$PATH

cd $(dirname $0)

bundle exec ./shutdown_watcher.rb
