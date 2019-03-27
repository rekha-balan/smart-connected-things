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



#
#
# I can't seem to see if I can automate this using command line tool

read -p "Create DataPrep recipe"

#    On the Navigation menu, click Dataprep.
#    Check the project on the top of the page. It should be the same project number.
#    Check the box to share information with Trifacta, then Agree and continue.
#    Allow Trifacta access to project data. Accept the defaults.
#    In Dataprep click Import Data.
#    On the left hand side, click GCS.
#    Click the <project_name> > Sensor-Data > (+).
#    If there is more than one file, click on each file.
#    Check Add Datasets to a Flow.
#    For the flow name, type Sensor-Data.
#    Click Import and Add to Flow.
#    Click Add new Recipe.

#    Click Edit Recipe.
# Split a column
#    Click the Split Column icon ().
#    Click On delimiter
#    Select device column.
#    For delimiter use ‘temp-sensor-'
#    Click Add
# You should have a column called device2 with only locations of the devices listed.
# Delete column
#    Click the expansion arrow on the column titled device1.
#    Click Delete.
# Rename column
#   Click the expansion arrow on the column titled device2.
#    For new name, type Device location.
#    Click Add
# Round values in a column
#   Click the expansion arrow on the column titled temperature.
#   Click Calculate > Round > Round.
#    Click Add.
# You now have a recipe for handling data coming from GCS.
#    Click Run job. This can take several minutes.
#    When the job is done, double click on the second Sensor-Data icon in the flow. Examine the data.


read -p "Schedule a dataprep job"

# You now have a Dataprep dataset and a recipe for transforming the data. AS you may have noticed, your devices are continuing to publish data and store it in GCS. You can now schedule a flow to download new data and execute the recipe.
#    Click on the Dataprep icon in the upper left corner.
#    Click on Sensor-Data.
#    The flow has the data set and the recipe you created. Click on the recipe icon.
#    You should now have a second recipe icon in the flow. Click on the second recipe icon.
#    At the top of the Flow page, click on the overflow menu .
#    Click Schedule flow.
#    On the Add schedule page, specify the following:

# Timezone
# Select your timezone
# Frequency
# Hourly
# Minutes past the hour

# Specify 20 minutes from your present time
#    Click Save. You will see a message that says ‘No scheduled destinations set...'. You will set the destination in the following steps.
#    Go to the Details page on the right side of the Flow page. Click on the overflow menu .
#    Click Create Output to run.
#    For Scheduled destinations, Click Add.
#    Click Add Publishing Action.
#    Click GCS.
#    Click Create Folder.
#    On the Create Folder page, specify the following:
# Folder Name Device Events Data
#    Click Create Folder.
#    Click Create a new file.
#    Click Add.
#    Click Save Settings.

read -p "Examine dataprep output"

# Click Jobs ().
# If the job is not scheduled to run within the next few minutes, you can run the job manually.
# Run a job manually
# Click on the Flows page.
# Click on the second recipe icon.
# Click on Edit Recipe
# Click on Run Job (upper right corner)
# Click on the Jobs page

# The Jobs page lists the jobs that have been completed. Click on the job number as soon as it is completed. This time the job will take a little longer because it has more data to process. The metadata for the dataset is shown. Moving your cursor over the bar graphs will give you details about each data point.
# Dataprep assumes the dataset is large, therefore it does not show the entire dataset. The default is to show initial values. There are cases where this may not be acceptable.
# Change dataset sample
# Find the dataset name in the information bar at the top of the page. Click on the dataset name.
# On the Flows page, double click on the second recipe icon.
# In the upper right corner, click the Samples item.
# Click Got it!. This will display all the samples available.
# Click Random.
# Select Full to pull samples from the entire dataset.
# Click Collect.
# Click on the Dataflow symbol next to the progress bar. The Dataflow page shows the job as running. The time to complete the job depends on how much data has accumulated in the Sensor-Data folder. Wait for the job to complete.
# Go back to the GCP Console. Click Navigation > Storage
# Click bucket titled <project name>.
# Click Sensor-Data. You should now see a list of files, each written five minutes apart. These files contain all the data published by the devices.
# Return to Dataprep. Click Flows.
# Click Sensor-Data Flow.
# Double click the last icon in the flow. Examine the data.
