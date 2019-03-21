#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7

export PROJECT_ID=$(gcloud config get-value project)

bq mk --dataset $PROJECT_ID:sensorHubData
bq mk --table --label $PROJECT_ID:sensorHubData.sensorData schema.json


# use data flow to copy from pub/sub to bigquery dataset table 
gcloud dataflow jobs run JOB_NAME \
    --gcs-location gs://dataflow-templates/latest/PubSub_to_BigQuery \
    --staging-location gs://$PROJECT_ID/tmp \
    --parameters \
inputTopic=projects/$PROJECT_ID/topics/device-events,\
outputTableSpec=$PROJECT_ID:sensorHubData.sensorData



# query data from bigquery 
bq query --destination_table $PROJECT_ID:sensorHubData.sensorData \ 
         --use_legacy_sql=false 
         '[QUERY]'
