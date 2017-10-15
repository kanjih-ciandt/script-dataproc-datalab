# script-dataproc-datalab
This is a simple script to create [Google Cloud Dataproc](https://cloud.google.com/dataproc) cluster with [Cloud Data Lab](https://cloud.google.com/datalab/).

The script execute this command to create a dataproc cluster:
```sh
$ gcloud dataproc clusters create $CLUSTERNAME \
	    --project $PROJECT \
	    --num-workers $WORKERS \
      --bucket $BUCKET \
      --metadata startup-script-url=gs://$BUCKET/setup/setup_env.sh,BUCKET=$BUCKET \
	    --master-machine-type $VMMASTER \
        --worker-machine-type $VMWORKER \
	    --initialization-actions \
	        gs://dataproc-initialization-actions/datalab/datalab.sh \
      --scopes cloud-platform
```

### Steps to Create/Access a DataProc Cluster with DataLab using this script:
- **Step 1 -** Change the file **script/env.conf** with your GCP project information.
- **Step 2 -** Move the setup and shutdown scrips to gcs using the script **script/storage.sh**
```sh
$ ./dataproc.sh <cluster_name> create
```
- **Step 3 -** Create a cluster using the script **script/dataproc.sh**
```sh
$ ./dataproc.sh <cluster_name> create
```
- **Step 4 -** Create a tunnel to access your dataproc cluster (the tunnel will be started using port 10000)
```sh
$ ./dataproc.sh <cluster_name> connect
```

- **Step 5 -** Configure your browser to use socket proxy port 10000 (https://5socks.net/Manual/browser_en.html)

- **Step 6 -** Access the datlab http://localhost:8080

### Steps to Delete your cluster 
```sh
$ ./dataproc.sh <cluster_name> destroy
```
