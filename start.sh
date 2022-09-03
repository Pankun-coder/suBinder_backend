#!/bin/bash
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
rails db:setup RAILS_ENV=production
rails s -p 80 -b 0 -e production