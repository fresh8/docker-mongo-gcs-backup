#!/bin/sh

[[ -z "$BUCKET_NAME" ]] && echo "BUCKET_NAME required" && exit 1;
[[ -z "$MONGODB_URI" ]] && echo "MONGODB_URI required" && exit 1;
[[ -z "$OUTPUT_NAME" ]] && echo "OUTPUT_NAME required" && exit 1;

DATE=$(date +%Y%m%d_%H%M)

OUTPUT_FILE="/tmp/$OUTPUT_NAME-$DATE.gz"
mongodump --uri $MONGODB_URI --archive=$OUTPUT_FILE --gzip -v

gcloud auth activate-service-account --key-file /secrets/gcp-key.json
gsutil -m -h "Cache-Control:no-cache" cp -r "$OUTPUT_FILE" "gs://$BUCKET_NAME/"
