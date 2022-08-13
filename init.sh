#!/bin/bash
HOME=~/sre-challenge/

# this is your part to fill
cd $HOME/invoice-app
docker build . -t invoice-app

cd $HOME/payment-provider
docker build . -t payment-provider