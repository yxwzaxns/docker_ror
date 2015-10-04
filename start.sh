#!/bin/bash --login
thin -C /etc/thin/railsapp.yml start
tail /app/src/log/development.log
tail /app/src/log/thin.300*
service nginx start
