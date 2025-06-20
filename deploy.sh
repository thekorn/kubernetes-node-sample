#!/usr/bin/env bash

# Build and deploy script for k3s

echo "Building Docker image..."
docker build -t node-sample-app:latest .

echo "Loading image into k3s..."
k3s ctr images import <(docker save node-sample-app:latest)

echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/

echo "Deployment complete!"
echo "App should be available at: http://hallo.local"
