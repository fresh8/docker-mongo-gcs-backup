# copied the source for the google cloud sdk alpine image
#
# Current alpine:edge is the only image with alpine 3.8
# (which is no longer on the alpine edge branch)
FROM alpine:edge
ARG CLOUD_SDK_VERSION=231.0.0
ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION

ENV PATH /google-cloud-sdk/bin:$PATH
RUN apk --no-cache add \
  curl \
  python \
  py-crcmod \
  bash \
  libc6-compat \
  openssh-client \
  git \
  gnupg \
  && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
  ln -s /lib /lib64 && \
  gcloud config set core/disable_usage_reporting true && \
  gcloud config set component_manager/disable_update_check true && \
  gcloud config set metrics/environment github_docker_image && \
  gcloud --version
VOLUME ["/root/.config"]
# end copied google-cloud sdk
RUN apk add --update \
  mongodb-tools
WORKDIR /usr/share/mongo-backup
COPY backup.sh /usr/share/mongo-backup/backup.sh
RUN chmod +x /usr/share/mongo-backup/backup.sh
CMD ["/usr/share/mongo-backup/backup.sh"]
