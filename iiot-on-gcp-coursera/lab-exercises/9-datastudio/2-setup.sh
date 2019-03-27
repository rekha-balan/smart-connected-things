#! /bin/bash

export CLOUDSDK_PYTHON=/usr/bin/python2.7
# gcloud init
export PROJECT_ID=$(gcloud config get-value project)

#
#
#
gcloud alpha pubsub subscriptions create taxi-test-sub --topic projects/pubsub-public-data/topics/taxirides-realtime
gcloud alpha pubsub subscriptions pull projects/<your-project-id>/subscriptions/taxi-test-sub



#
#
#
gsutil mb -l us-central1 gs://$PROJECT_ID/


#
#
#
cp sample-schema.json /home/acahyadi/sample-schema.json
bq mk --dataset $PROJECT_ID:streamingTaxi
bq mk --table $PROJECT_ID:streamingTaxi.taxiData /home/acahyadi/sample-schema.json




#
#
#
gcloud dataflow jobs run taxistream \
    --gcs-location gs://dataflow-templates/latest/PubSub_to_BigQuery \
    --staging-location gs://$PROJECT_ID/tmp \
    --parameters \
inputTopic=projects/pubsub-public-data/topics/taxirides-realtime,\
outputTableSpec=$PROJECT_ID:streamingTaxi.taxiData


#
#
# Unable to fix the project ID dynamically
bq query --use_legacy_sql=false \
 'SELECT * FROM `qwiklabs-gcp-40b96aa3ac67a598.streamingTaxi.taxiData` LIMIT 10'

read -p "Add BiqQuery table to Data Studio"
read -p "Visualise your data by creating report"
read -p "Share your data"
