#!/bin/bash

cat > /opt/iri/iri.ini <<EOL
[IRI]
PORT = ${API_PORT}
UDP_RECEIVER_PORT = ${UDP_PORT}
TCP_RECEIVER_PORT = ${TCP_PORT}
NEIGHBORS = ${NEIGHBORS}
IXI_DIR = data/ixi
HEADLESS = true
DEBUG = false
TESTNET = false
DB_PATH = data/db
EOL

if [ "${PRESYNC}" == "1" ]; then
  if [ ! -d "/opt/iri/data/db" ]; then
    echo "+++ Downloading IOTA.partners mainnetdb... +++"
    cd /tmp
    curl -LO http://db.iota.partners/IOTA.partners-mainnetdb.tar.gz \
      && mkdir -p /opt/iri/data/db \
      && tar xzfv /tmp/IOTA.partners-mainnetdb.tar.gz -C /opt/iri/data/db \
      && rm -f /tmp/IOTA.partners-mainnetdb.tar.gz
  fi
fi

cd /opt/iri

chown -R iota:iota /opt/iri/data

exec runuser -l iota -c "java \
  $JAVA_OPTIONS \
  -Djava.net.preferIPv4Stack=true \
  -Dlogback.configurationFile=/opt/iri/logback.xml \
  -jar /opt/iri/iri.jar \
  --config /opt/iri/iri.ini \
  --remote --remote-limit-api \"$REMOTE_API_LIMIT\" \
  \"$@\""
