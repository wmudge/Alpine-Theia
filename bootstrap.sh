#!/bin/sh

eval `ssh-agent -s`

#yarn theia start --hostname 0.0.0.0 --port 3000
node /home/theia/src-gen/backend/main.js /home/project --hostname=0.0.0.0
