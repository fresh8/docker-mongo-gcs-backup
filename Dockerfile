FROM google/cloud-sdk:alpine
RUN apk add --update \
  mongodb-tools
WORKDIR /usr/share/mongo-backup
COPY backup.sh /usr/share/mongo-backup/backup.sh
RUN chmod +x /usr/share/mongo-backup/backup.sh
CMD ["/usr/share/mongo-backup/backup.sh"]
