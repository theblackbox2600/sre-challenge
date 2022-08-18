#!/usr/bin/env bash
HOME=~/sre-challenge

minikube start
eval $(minikube -p minikube docker-env)

# this is your part to fill
docker build $HOME/invoice-app -t invoice-app
docker build $HOME/payment-provider -t payment-provide