#! /bin/bash 

export CLOUDSDK_PYTHON=/usr/bin/python2.7
gcloud init

export PROJECT_ID=$(gcloud config get-value project)



#
#
#
# create Pub Sub topics, and add permission
gcloud pubsub topics create iotlab
# I can't fingure out how the above permission granting done in command line
read -p "add Permission Pub/Sub Publisher to cloud-iot@system.gserviceaccount.com and then press enter"



#
#
# create bucket 
gsutil mb -l us-central1 gs://$PROJECT_ID/
# I can't figure out how gsutil can create directory 
read -p "Create folder Sensor-Data and then press enter"


#
#
#
# create data flow to copy pub sub to storage text 
gcloud dataflow jobs run sensor-data \
    --gcs-location gs://dataflow-templates/latest/Cloud_PubSub_to_GCS_Text \
    --parameters \
inputTopic=projects/$PROJECT_ID/topics/iotlab,\
outputDirectory=gs://$PROJECT_ID/Sensor-Data/,\
outputFilenamePrefix=output-,\
outputFilenameSuffix=.txt




#
#
#
# login to console, in the case of the Coursera course, a VM is already created 
# I seem to be able to re-create the VM using create-iot-device-simulator.sh 
# SSH to the VM, run the 2-prepare-simulator.sh and then
# re-open SSH and run the 3-prepare-simulator-part2.sh
# it will prompt for creation of registry which is the next step
read -p "prepare your iot-data-simulator VM and then press enter"


#
#
#
# create a registry 
# at one point you will need to copy the certificate from the VM
# follow prompt on the simulator's SSH 
gcloud iot registries create iotlab-registry \
    --project=$PROJECT_ID \
    --region=us-central1 \
    --event-notification-config=topic=projects/$PROJECT_ID/topics/iotlab

read -p "Copy the IOT Device Simulator RSA Key to sample_cert.pem file"
cp sample_cert.pem ~/sample_cert.pem

# create the device 
gcloud iot devices create temp-sensor-buenos-aires \
    --project=$PROJECT_ID \
    --region=us-central1 \
    --registry=iotlab-registry \
    --public-key path=/home/acahyadi/sample_cert.pem,type=rs256

# create the device 
gcloud iot devices create temp-sensor-istanbul \
    --project=$PROJECT_ID \
    --region=us-central1 \
    --registry=iotlab-registry \
    --public-key path=/home/acahyadi/sample_cert.pem,type=rs256
    
    
read -p "Run the simulator telemetry for first device"

read -p "Run the simulator telemetry for second device"

read -p "Wait for 5-10 mins and then check your Cloud Storage contains the telemetry"