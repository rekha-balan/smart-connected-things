#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7
gcloud init

export PROJECT_ID=$(gcloud config get-value project)

gsutil mb -l us-central1 gs://$PROJECT_ID/

gcloud dataflow jobs run counting-words \
    --gcs-location gs://dataflow-templates/latest/Word_Count \
    --staging-location gs://$PROJECT_ID/tmp \
    --parameters inputFile=gs://dataflow-samples/shakespeare/kinglear.txt,output=gs://$PROJECT_ID/counts 
    


echo "Check Logs !!"
# check Logs and you should be able to see the Google provided 
# data flow tepmlate "Word Count" should include four stages of
# ReadLines, WordCount.CountWords, MapElements and WriteCounts. 

echo "Check Output Files on the Buckets !!"
# files e.g. counts-00000-of-00003 should appear in the bucket 
# and it should contain word count for Shakespeare's King Lear 

gcloud pubsub topics create device-data
gcloud pubsub subscriptions create --topic device-data device-data-sub

gcloud dataflow jobs run export_to_pub_sub \
    --gcs-location gs://dataflow-templates/latest/GCS_Text_to_Cloud_PubSub \
    --staging-location gs://$PROJECT_ID/tmp \
    --parameters inputFilePattern=gs://$PROJECT_ID/*,outputTopic=projects/$PROJECT_ID/topics/device-data
    
    
gcloud pubsub subscriptions pull device-data-sub --auto-ack --limit=10