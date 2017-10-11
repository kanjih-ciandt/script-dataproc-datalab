#!/usr/bin/env bash
set -e

echo "Copying notebooks on shutdown..."
BUCKET=$(curl -f -s -H Metadata-Flavor:Google http://metadata/computeMetadata/v1/instance/attributes/BUCKET || true)

gsutil -m rm gs://$BUCKET/notebooks/*
gsutil -m cp /root/notebooks/*.ipynb gs://$BUCKET/notebooks/
