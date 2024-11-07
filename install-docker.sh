#!/bin/bash

# Base URL for downloading the deb files
base_url="https://download.docker.com/linux/ubuntu/dists/oracular/pool/stable/amd64/"

# Array of file names for the deb packages
deb_files=(
    "containerd.io_1.7.22-1_amd64.deb"
    "docker-buildx-plugin_0.17.1-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-ce-cli_27.3.0-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-ce-cli_27.3.1-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-ce-rootless-extras_27.3.0-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-ce-rootless-extras_27.3.1-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-ce_27.3.0-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-ce_27.3.1-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-compose-plugin_2.29.6-1~ubuntu.24.10~oracular_amd64.deb"
    "docker-compose-plugin_2.29.7-1~ubuntu.24.10~oracular_amd64.deb"
)

# Download each deb file
for file in "${deb_files[@]}"; do
    wget "${base_url}${file}"
done

# Install all downloaded .deb files
sudo dpkg -i ./*.deb