#! /bin/bash 

export PROJECT_ID==$(gcloud config get-value project)

cd $HOME/training-data-analyst/quests/iotlab/

python cloudiot_mqtt_example_json.py \
   --project_id=$PROJECT_ID \
   --cloud_region=us-central1 \
   --registry_id=iotlab-registry \
   --device_id=temp-sensor-buenos-aires \
   --private_key_file=rsa_private.pem \
   --message_type=event \
   --algorithm=RS256 --num_messages=200 > buenos-aires-log.txt 2>&1 &