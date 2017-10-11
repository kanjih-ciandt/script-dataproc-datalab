#!/bin/bash
set -e

# Load configuration sourcing the config.sh script
. env.conf

# Do not change nothing bellow this
USAGE="Usage: `basename $0` <CLUSTERNAME> <ACTION> (create|tunnel|browse|destroy)"

# Check for Parameters
CLUSTERNAME=$1
ACTION=$2
W=$3

if [ -z "$CLUSTERNAME" ]; then
  echo 'CLUSTERNAME argument is required.'
  echo $USAGE
  exit 1
fi

if [ -z "$ACTION" ]; then
  echo 'ACTION argument is required.'
  echo $USAGE
  exit 1
fi

if [[ ! -z "$W" ]]; then
  WORKERS=$W
  echo "Setting WORKERS to $WORKERS"
fi


if [ $ACTION = "create" ]; then
	# Create Cluster
	gcloud dataproc clusters create $CLUSTERNAME \
	    --project $PROJECT \
	    --num-workers $WORKERS \
      --bucket $BUCKET \
      --metadata startup-script-url=gs://$BUCKET/setup/setup_env.sh,BUCKET=$BUCKET \
	    --master-machine-type $VMMASTER \
        --worker-machine-type $VMWORKER \
	    --initialization-actions \
	        gs://dataproc-initialization-actions/datalab/datalab.sh \
      --scopes cloud-platform

  gcloud compute instances add-metadata $CLUSTERNAME-m \
      --metadata shutdown-script-url=gs://$BUCKET/setup/setup_shutdown.sh


	exit 0

elif [ $ACTION = "connect" ]; then
    echo 'Open tunnel Dataproc with Datalab'
    # gcloud compute ssh  --zone=$ZONE \
  	#    --ssh-flag="-D $PORT" --ssh-flag="-N" --ssh-flag="-n" "$CLUSTERNAME-m"
    gcloud compute --project "$PROJECT" ssh --zone "$ZONE" "$CLUSTERNAME-m" \
       --ssh-flag="-D 10000" --ssh-flag="-N" --ssh-flag="-n"
  	TUNNEL_PID=$!
  	echo $TUNNEL_PID > .tunnel.pid



elif [ $ACTION = "destroy" ]; then
	echo 'Destroying DataLab'
  gcloud dataproc clusters delete $CLUSTERNAME


else
	echo 'Invalid action!'
    echo $USAGE
    exit 1
fi
