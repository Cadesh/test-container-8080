#!/bin/bash
#------------------------------------------------------------------------------
# Date: 2024-07-15

# TEST-CONTAINER IMAGE
# It features a small HTTP server with the following characteristics:

# It serves content on two ports (8080 and 8081) to enable testing that multiple Docker container ports can be exposed.
# It serves an HTML root page, with a few basic elements, to enable verification that browser-based test tools can access the container.
# It serves a non-HTML endpoint at /ping, to enable plain HTTP testing.
# It serves a UUID unique to this running instance of the container, at /uuid, to enable testing of multiple container instances or testing of stop/start behaviour.
# It implements a configurable delay at startup before each port's server is started, to enable testing of startup wait strategies (TCP or HTTP-based). Setting the environment variable DELAY_START_MSEC to a non-zero number will:
# wait for the defined duration
# start the port 8080 server
# wait again for the same duration
# start the port 8081 server
# It emits a basic log message after starting which can be used to test log-based wait strategies.

# Requirements: Docker
#------------------------------------------------------------------------------

BASE_IMG_NAME="test-container-8080"
REGION='ca-central-1'
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
ECR_URI="$ACCOUNT_ID.dkr.ecr.ca-central-1.amazonaws.com" # check the ECR endpoint
DOCKERFILE="Dockerfile-Test-Container-8080"

#------------------------------------------------------
# 1. REMOVE OLD DOCKER IMAGE FOR NEW BUILD
if [ $( docker image ls | grep ${BASE_IMG_NAME} | wc -l ) -gt 0 ]; then
    echo "Delete old docker image for new build."
    docker rmi ${BASE_IMG_NAME}  
fi
#------------------------------------------------------

#------------------------------------------------------
# 2. BUILD NEW DOCKER IMAGE
echo "Build base ${BASE_IMG_NAME} from official docker image"
docker build -t ${BASE_IMG_NAME} -f ./$DOCKERFILE .
#------------------------------------------------------

#------------------------------------------------------
# 3. LOG TO REGISTRY
echo "Log to Registry."
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_URI
#------------------------------------------------------

#------------------------------------------------------
# 4. TAG DOCKER IMAGE AS LATEST
echo "Tag new Docker Image."
docker tag $BASE_IMG_NAME:latest $ECR_URI/$BASE_IMG_NAME:latest
#------------------------------------------------------

#------------------------------------------------------
# 5. PUSH BASE IMAGE TO ECR
echo "Push Image to AWS ECR."
docker image ls
docker push $ECR_URI/$BASE_IMG_NAME:latest
#------------------------------------------------------

#------------------------------------------------------
# 6. DELETE UNTAGGED IMAGES
echo "Deleting old (untagged) images from Registry"
IMAGES_TO_DELETE=$( aws ecr list-images \
--region $REGION \
--repository-name $BASE_IMG_NAME \
--filter "tagStatus=UNTAGGED" \
--query 'imageIds[*]' --output json )

if [[ -n "$IMAGES_TO_DELETE" ]] && [[ "$IMAGES_TO_DELETE" != "[]" ]]; then
  aws ecr batch-delete-image \
  --region $REGION \
  --repository-name $BASE_IMG_NAME \
  --image-ids "$IMAGES_TO_DELETE"
  echo "Deleted untagged images from registry"
else
  echo "No untagged images found in registry"
fi
#------------------------------------------------------

echo "Run Docker container with a command such as:"
# using -e "TERM=xterm-256color" to add color to prompt
echo "docker run -p 8080:8080 $ACCOUNT_ID.dkr.ecr.ca-central-1.amazonaws.com/test-container-8080" 