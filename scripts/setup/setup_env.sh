#!/usr/bin/env bash
set -e

SCRIPT_PATH="/root/setup"
BUCKET=$(curl -f -s -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/instance/attributes/BUCKET || true)
PIP=/usr/local/bin/miniconda/bin/pip

mkdir $SCRIPT_PATH
cd $SCRIPT_PATH

# Copy setup scripts from GCS and apply 755 permission
gsutil cp gs://$BUCKET/setup/* $SCRIPT_PATH/
gsutil -m cp gs://$BUCKET/notebooks/*.ipynb /datalab/notebooks/ 
chmod 755 $SCRIPT_PATH/*

apt-get install -y imagemagick
apt-get install -y bzip2
apt-get install -y git
apt-get install -y gcc



## Instaling aditional python packages
#$PIP install google
$PIP install opencv-python==3.2.0.8
$PIP install scikit-image
