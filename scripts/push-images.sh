
#!/bin/bash

set -e

export $(grep -v '^#' ./backend/.env | xargs)

BACKEND_IMAGE="cloudbite-backend"
FRONTEND_IMAGE="cloudbite-frontend"

TAG="v1"

# Building backend image

docker build \
    -t $DOCKER_USERNAME/$BACKEND_IMAGE:$TAG\
    ./backend


# Building frontend image

docker build \
    -t $DOCKER_USERNAME/$FRONTEND_IMAGE:$TAG\
    ./frontend


echo "Pushing backend image..."

docker push $DOCKER_USERNAME/$BACKEND_IMAGE:$TAG

echo "Pushing frontend image..."

docker push $DOCKER_USERNAME/$FRONTEND_IMAGE:$TAG

echo "Images were pushed successfully"