#!/bin/sh

# Check if user settings.json exists
if [ -f "/config/settings.json" ]; then
    echo "Using existing /config/settings.json"
    cp /config/settings.json /usr/src/api/config/settings.json
else
    echo "No /config/settings.json found, copying default"
    cp /usr/src/api/config/settings.default.json /usr/src/api/config/settings.json
fi

# Make config readable
chmod 644 /usr/src/api/config/settings.json

# Start app
exec "$@"
