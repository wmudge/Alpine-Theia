#!/bin/sh

echo "Starting SSH agent"
eval `ssh-agent -s`

echo "Starting Theia IDE"
yarn theia start --hostname 0.0.0.0 --port 3000