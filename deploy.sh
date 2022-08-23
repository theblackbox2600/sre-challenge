#!/usr/bin/env bash
HOME=~/sre-challenge

echo "Commencing initial deployment"
kubectl apply -f $HOME/payment-provider/deployment.yaml;
kubectl apply -f $HOME/invoice-app/deployment.yaml;