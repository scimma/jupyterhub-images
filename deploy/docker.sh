#!/bin/bash

docker_build() {
    local env=$1
    docker build --tag scimma-jupyterhub-singleuser-$env:latest .
}

docker_login() {
    aws ecr \
        get-login-password \
        --region us-west-2 \
        | docker login \
                 --username AWS \
                 --password-stdin 585193511743.dkr.ecr.us-west-2.amazonaws.com
}

docker_push() {
    local env=$1
    docker tag \
           scimma-jupyterhub-singleuser-$env:latest \
           585193511743.dkr.ecr.us-west-2.amazonaws.com/scimma-jupyterhub-singleuser-$env:latest
    docker push 585193511743.dkr.ecr.us-west-2.amazonaws.com/scimma-jupyterhub-singleuser-$env:latest
}
