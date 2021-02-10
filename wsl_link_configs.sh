#!/bin/bash

WIN_USERNAME=${1:-$(whoami)}
USERNAME=$(whoami)

if [[ ! -d "/mnt/c/Users/$WIN_USERNAME" ]]; then
    echo "Username \"$WIN_USERNAME\" not found on C:\Users\ directory!"
    exit 1
fi

## Copy ssh credentials
sudo cp "/mnt/c/Users/$WIN_USERNAME/.ssh/*" ~/.ssh/
sudo chmod 400 ~/.ssh/*
sudo chown $USERNAME:$USERNAME ~/.ssh/*

## Create symlinks
ln -s "/mnt/c/Users/$WIN_USERNAME/.aws" ~/.aws
ln -s "/mnt/c/Users/$WIN_USERNAME/.kube" ~/.kube
