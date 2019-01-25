#!/bin/sh

[[ -z "$BUCKET_NAME" ]] && echo "BUCKET_NAME required" && exit 1;
[[ -z "$MONGODB_URI" ]] && echo "MONGODB_URI required" && exit 1;
[[ -z "$OUTPUT_NAME" ]] && echo "OUTPUT_NAME required" && exit 1;

DATE=$(date +%Y%m%d_%H%M)

if [[ "$MONGODB_HOST" == "" ]]; then
    MONGODB_HOST=localhost
fi

# Execute a database lookup
HAS_COLLECTIONS=$(mongo -uri $MONGO_URI <<< "db.getCollectionNames().length > 0" |& grep "^true$")
if [[ "$HAS_COLLECTIONS" != "true" ]]
then
    echo "Database has no collections or we cannot connect"
    exit 1
fi

OUTPUT_FILE="/tmp/$OUTPUT_NAME-$DATE.gz"
mongodump --uri $MONGODB_URI --archive=$OUTPUT_FILE --gzip -v

gcloud auth activate-service-account --key-file /secrets/gcp-key.json
gsutil -m -h "Cache-Control:no-cache" cp -r "$OUTPUT_FILE" "gs://$BUCKET_NAME/"
