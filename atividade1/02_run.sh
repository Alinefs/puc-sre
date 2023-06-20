#!/bin/bash -e

application=$1

docker run --rm -d -p 8080:8080 --name $application puc-sre/$application:`cat $application/version`
docker logs -f $(docker ps -qf name=$application)
