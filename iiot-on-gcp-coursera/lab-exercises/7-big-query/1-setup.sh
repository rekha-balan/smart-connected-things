#! /bin/bash

export CLOUDSDK_PYTHON=/usr/bin/python2.7

gcloud init

export PROJECT_ID=$(gcloud config get-value project)

gcloud pubsub topics create device-events

gsutil mb -l us-central1 gs://$PROJECT_ID/

read -p "Execute simulator in CloudShell"

#
#
# create BigQuery table
cp sample-schema.json /home/acahyadi/sample-schema.json
bq mk --dataset $PROJECT_ID:sensorHubData
bq mk --table $PROJECT_ID:sensorHubData.sensorData /home/acahyadi/sample-schema.json



#
#
# create data flow to export pub sub data from simulator to the bigquery table
# use data flow to copy from pub/sub to bigquery dataset table
gcloud dataflow jobs run copy-to-bq \
    --gcs-location gs://dataflow-templates/latest/PubSub_to_BigQuery \
    --staging-location gs://$PROJECT_ID/tmp \
    --parameters \
inputTopic=projects/$PROJECT_ID/topics/device-events,\
outputTableSpec=$PROJECT_ID:sensorHubData.sensorData



#
#
# query data from bigquery
bq query --use_legacy_sql=false \
'SELECT * FROM `$PROJECT_ID.sensorHubData.sensorData` LIMIT 10'


#
#
# another query ..
bq query --use_legacy_sql=false \
'SELECT \
  #timestamp in miliseconds \
  EXTRACT(DATE FROM TIMESTAMP_MILLIS(CAST(timestamp_ambient_pressure AS INT64))) AS Pressuredate, \
  TIMESTAMP_MILLIS(CAST(timestamp_ambient_pressure AS INT64)) AS Pressuretime, \
  EXTRACT(DATE FROM TIMESTAMP_MILLIS(CAST(timestamp_temperature AS INT64))) AS Tempdate, \
  TIMESTAMP_MILLIS(CAST(timestamp_temperature AS INT64)) AS Temptime, \
  ambient_pressure as pressure, \
  temperature as temp_c, \
  (temperature*1.8)+32 as temp_f \
FROM \
  `$PROJECT_ID.sensorHubData.sensorData`, \
  UNNEST(data) AS d \
  WHERE timestamp_temperature IS NOT NULL OR timestamp_ambient_pressure IS NOT NULL'


#
#
# stop dataflow (in real life, this is a chargeable item)
gcloud dataflow jobs drain copy-to-bq
