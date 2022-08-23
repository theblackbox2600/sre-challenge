#!/usr/bin/env bash

HOME=~/sre-challenge
GET_PATH="invoices"
POST_PATH="invoices/pay"

echo "Getting endpoint url from minikube"
#ENDPOINT=$(minikube service invoice-app --url)
echo $ENDPOINT

echo "---------------------------------------------"

echo "First we will get the current invoices: "
echo "GET: ${ENDPOINT}/${GET_PATH} - "
curl ${ENDPOINT}/${GET_PATH} | jq

echo "---------------------------------------------"

echo "Next we will pay ALL of the invoices using an empty data object (I would suggest that this may be a bad API design) :"
echo "POST: ${ENDPOINT}/${POST_PATH} - "
curl -X POST ${ENDPOINT}/${POST_PATH} -d {}

echo "---------------------------------------------"

sleep 5

echo "Finally we will check that all invoices have indeed been paid: "
echo "GET: ${ENDPOINT}/${GET_PATH} - "

RESULTS="$(curl -s ${ENDPOINT}/${GET_PATH} | jq -c '[ .[] | select ( .IsPaid == true)]')"

if [[ $(echo $RESULTS | jq -r 'length') -eq 0 ]]; then
    echo "INVOICES HAVE NOT BEEN PAID: ${RESULTS}"
else
    echo "INVOICES HAVE BEEN PAID: ${RESULTS}"
fi