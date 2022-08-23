#!/usr/bin/env bash
HOME=~/sre-challenge


docker image rm invoice-app
docker image rm payment-provider

kubectl delete -f $HOME/payment-provider/deployment.yaml
kubectl delete -f $HOME/invoice-app/deployment.yaml