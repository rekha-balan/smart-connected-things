#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7
gcloud init
gcloud pubsub topics create MyTopic
gcloud pubsub subscriptions create --topic MyTopic MySub
gcloud pubsub topics publish MyTopic --message "Hello World"
gcloud pubsub subscriptions pull --auto-ack MySub