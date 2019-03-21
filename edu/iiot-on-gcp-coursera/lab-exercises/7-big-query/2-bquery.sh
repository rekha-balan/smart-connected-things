#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7

export PROJECT_ID=$(gcloud config get-value project)

bq mk --dataset $PROJECT_ID:sensorHubData
bq mk --table --label $PROJECT_ID:sensorHubDatanative.sensorData schema.json
