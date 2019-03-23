# taking backup of a few repos. Decided not to clone it so that it can fit my directory structure 
# and becoming not versioned

# clean up git folder as you can't have git subfolders in one repo
rm -rf training-data-analyst
rm -rf sensor-sim
rm -rf deploymentmanager-samples

#
git clone http://github.com/GoogleCloudPlatform/training-data-analyst
git clone https://github.com/cagamboa123/sensor-sim.git
git clone http://github.com/GoogleCloudPlatform/deploymentmanager-samples

# clean up git folder as you can't have git subfolders in one repo
rm -rf training-data-analyst/.git
rm -rf sensor-sim/.git
rm -rf deploymentmanager-samples/.git