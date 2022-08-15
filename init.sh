#!/bin/bash
HOME=~/sre-challenge

minikube start
eval $(minikube -p minikube docker-env)

# this is your part to fill
cd $HOME/invoice-app
docker build . -t invoice-app

cd $HOME/payment-provider
docker build . -t payment-provider