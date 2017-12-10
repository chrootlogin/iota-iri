FROM maven:3.5-jdk-8 as builder

# IRI release to use, can be either git tag or branch
ARG IRI_VERSION=1.4.1.2

RUN git clone -b v$IRI_VERSION https://github.com/iotaledger/iri /opt/iri
WORKDIR /opt/iri
RUN mvn clean package \
  && cp /opt/iri/target/iri-$IRI_VERSION.jar /opt/iri/target/iri.jar

FROM openjdk:8-alpine

ENV NEIGHBORS="" \
  REMOTE_API_LIMIT="attachToTangle, addNeighbors, removeNeighbors" \
  API_PORT=14265 \
  UDP_PORT=14600 \
  TCP_PORT=15600 \
  JAVA_OPTIONS="-XX:+DisableAttachMechanism -XX:+HeapDumpOnOutOfMemoryError -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"

COPY root /
COPY --from=builder /opt/iri/target/iri.jar /opt/iri/iri.jar

RUN apk --no-cache -U add \
  bash

VOLUME /opt/iri/data

EXPOSE $API_PORT
EXPOSE $UDP_PORT/UDP
EXPOSE $TCP_PORT

ENTRYPOINT ["/docker-entrypoint.sh"]
