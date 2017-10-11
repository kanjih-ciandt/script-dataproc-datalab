#!/bin/bash
#set -e

# Load configuration sourcing the config.sh script
. env.conf

# Copy configuration files
gsutil -m cp -r setup "gs://$BUCKET/"
