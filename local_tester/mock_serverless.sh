#!/bin/bash

set -e 

# Check if the host port and js file arguments are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 HOST_PORT JS_FILE"
    exit 1
fi

HOST_PORT=$1
JS_FILE=$2

# Check if JS_FILE is an absolute path or relative path
if [[ "$JS_FILE" = /* ]]; then
    ABS_JS_FILE="$JS_FILE"
else
    ABS_JS_FILE="$(pwd)/$JS_FILE"
fi

# Run the Docker container with the provided host port and JS file
CONTAINER_ID=$(docker run -d -p $HOST_PORT:8080 -v "$ABS_JS_FILE":/app/code.js tester)

# Check if the container started successfully
if [ $? -ne 0 ]; then
    echo "Failed to start the Docker container."
    exit 1
fi

echo "Docker container started with ID: $CONTAINER_ID"

# Define cleanup function
cleanup() {
    echo -e "\nKilling container..."
    docker kill $CONTAINER_ID
    docker rm $CONTAINER_ID
    echo "Container killed!"
}

# Set trap to catch SIGINT (Ctrl+C) and call the cleanup function
trap cleanup SIGINT

# Stream the logs from the container to the terminal
docker logs -f $CONTAINER_ID

