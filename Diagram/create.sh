#!/bin/bash

COMMAND=$1

if [ "$COMMAND" == "server" ]; then
    docker run --rm \
     -v "$PWD:/data" \
     --init \
     -t \
     -p 5173:5173 \
     -p 24678:24678 \
     -e CHOKIDAR_USEPOLLING=1 \
     -e CHOKIDAR_INTERVAL=200 \
     likec4/likec4 \
     start
    exit 0
fi

if [ "$COMMAND" == "export" ]; then
    docker run --rm -t likec4/likec4 export -h
    exit 0
fi

if [ "$COMMAND" == "build" ]; then
    docker run -v "$PWD:/data" likec4/likec4 build -o dist
    exit 0
fi

# Default case: show usage
echo "Usage: $0 {server|export|build}"
