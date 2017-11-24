#!/bin/bash

# remove legacy docker image
docker stop simple-sinatra-app
docker rm simple-sinatra-app

# remove local/simple-sinatra-app docker image
docker rmi local/simple-sinatra-app

# build new local/local/simple-sinatra-app
docker build -t local/simple-sinatra-app .
