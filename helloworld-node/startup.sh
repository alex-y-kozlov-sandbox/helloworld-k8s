#!/bin/sh
echo "Entering startup.sh"

echo "/opt/appdynamics/ agent mount"
ls /opt/appdynamics/

echo "agent ENV"

echo "APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY: ${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY}"
echo "APPD_API_KEY: ${APPD_API_KEY}"
echo "APPD_GLOBAL_ACCOUNT: ${APPD_GLOBAL_ACCOUNT}"

echo "Running node server.js"
node server.js
