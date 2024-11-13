#!/bin/bash

# Function to display usage
show_usage() {
    echo "Usage: $0 <command>"
    echo "Commands:"
    echo "  test    - Run tests"
    echo "  deploy  - Deploy application"
}

# Function to run tests
test_command() {

    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: test HOST_PORT JS_FILE"
        exit 1
    fi

    HOST_PORT=$1
    JS_FILE=$2

    echo "Running tests on port $HOST_PORT with file $JS_FILE..."
    ./mock_serverless.sh "$HOST_PORT" "$JS_FILE"
}

# Function to deploy
deploy_command() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
        echo "Usage: deploy JS_FILE RPC_URL PRIVATE_KEY CONTRACT_ADDRESS" 
        exit 1
    fi

    JS_FILE=$1
    RPC_URL=$2
    PRIVATE_KEY=$3
    CONTRACT=$4

    echo "Deploying $JS_FILE to contract $CONTRACT..."
    ./serverless-function-deployer --file "$JS_FILE" --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" --contract "$CONTRACT"
}

# Main command handler
case "$1" in
    "test")
        shift  # Remove the first argument ('test')
        test_command "$@"  # Pass remaining arguments to test_command
        ;;
    "deploy")
        shift  # Remove the first argument ('deploy')
        deploy_command "$@"  # Pass remaining arguments to deploy_command
        ;;
    *)
        show_usage
        exit 1
        ;;
esac