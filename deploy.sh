#!/bin/bash
HOME=~/sre-challenge

kubectl apply -f $HOME/payment-provider/deployment.yaml
kubectl apply -f $HOME/invoice-app/deployment.yaml
