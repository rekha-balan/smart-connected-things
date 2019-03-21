#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7
gcloud init

export PROJECT_ID=$(gcloud config get-value project)

gsutil mb -l us-central1 gs://$PROJECT_ID/

git clone https://github.com/cagamboa123/images.git

gsutil cp -r images gs://$PROJECT_ID/

gsutil lifecycle set storage_lifecycle.json gs://$PROJECT_ID/

gsutil iam ch user:john.doe@example.com:admin gs://$PROJECT_ID/

rm -rf images 