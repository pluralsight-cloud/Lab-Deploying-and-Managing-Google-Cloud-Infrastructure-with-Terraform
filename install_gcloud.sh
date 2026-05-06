#!/bin/bash

# Update package list
sudo apt-get update

# Install required dependencies
sudo apt-get install -y apt-transport-https ca-certificates gnupg curl

# Add Google Cloud public signing key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg

# Add Google Cloud SDK repository
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Update package list again with new repository
sudo apt-get update

# Install Google Cloud CLI
sudo apt-get install -y google-cloud-cli

# Verify installation
gcloud version
