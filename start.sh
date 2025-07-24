#!/bin/bash

# Check if stage name is passed
if [ -z "$1" ]; then
  echo "❌ Please provide the stage name (dev or prod)"
  echo "Usage: ./start.sh dev"
  exit 1
fi

STAGE=$1
CONFIG_FILE="config/${STAGE}_config.properties"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "❌ Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "✅ Starting application with config: $CONFIG_FILE"

# Run the jar with the selected config file
nohup java -jar -Dspring.config.location=$CONFIG_FILE target/techeazy-devops-0.0.1-SNAPSHOT.jar > app.log 2>&1 &

