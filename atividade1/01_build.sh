#!/bin/bash

application=$1
cd $application

image_name="puc-sre/$application"
image_version=`echo $(cat version)+1 | bc`
image_fullname="$image_name:$image_version"

echo $image_version

docker build -t $image_fullname . --build-arg AUTOR=$2
docker tag      $image_fullname $image_name:latest

# Update version
echo $image_version > version
sed -i "s%$image_name:.*%$image_name:$image_version%" Dockerfile

cd ..
echo -e "\n\nImage $image_fullname was builted."

