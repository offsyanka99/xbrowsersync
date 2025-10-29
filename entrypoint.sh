#!/bin/sh

set -e

# Copy default settings if no user config
if [ ! -f "/config/settings.json" ]; then
  echo "No /config/settings.json found, copying default to /config"
  cp /usr/src/api/config/settings.default.json /config/settings.json
else
  echo "Using existing /config/settings.json"
fi

# Make sure config is readable
chmod 644 /config/settings.json

# Start the app
exec "$@"
