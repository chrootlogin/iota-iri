# IOTA IRI node

This is [IRI (IOTA reference implementation)](https://github.com/iotaledger/iri) packed as small docker image.

[![](https://images.microbadger.com/badges/version/rootlogin/iota-iri.svg)](https://microbadger.com/images/rootlogin/iota-iri "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/rootlogin/iota-iri.svg)](https://microbadger.com/images/rootlogin/iota-iri "Get your own image badge on microbadger.com")

## Features
  * Java 8
  * [IOTA IRI node](https://github.com/iotaledger/iri)
  * Configurable via environment variable

## Usage

First you need to find some neighbors for your node. You can do this by joining the [#nodesharing](https://iotatangle.slack.com/messages/C2DBMJHK8)-Slack channel. You can join slack on [slack.iota.org](http://slack.iota.org/).

Afterwards you can start the node with:

```
$ docker run --net=host -d --name iota-node -v iota_data:/opt/iri/data -e "NEIGHBORS=udp://neighbor1:14600 tcp://neighbor1:15600 udp://neighbor3:14600" rootlogin/iota-iri
```

To rescan the database or revalidate, you can do this:

```
$ docker run --net=host --rm --name iota-node -v iota_data:/opt/iri/data -e "NEIGHBORS=udp://neighbor1:14600 tcp://neighbor1:15600 udp://neighbor3:14600" rootlogin/iota-iri --rescan
$ docker run --net=host --rm --name iota-node -v iota_data:/opt/iri/data -e "NEIGHBORS=udp://neighbor1:14600 tcp://neighbor1:15600 udp://neighbor3:14600" rootlogin/iota-iri --revalidate
```

#### Pre-sync database

If you want to sync your node with the latest tangle database from [iota.partners](http://iota.partners), set the environment variable `PRESYNC` to 1. This helps to get your node faster fully synced.

### Environment variables

You can configure different things with environment variables:

| Name             | Description                                                                                              |
| ---------------- | -------------------------------------------------------------------------------------------------------- |
| NEIGHBORS        | List of your neighbors (space delimited).                                                                |
| REMOTE_API_LIMIT | List of things that are forbidden via api (Default: attachToTangle, addNeighbors, removeNeighbors).      |
| API_PORT         | Port for API listener (Default: 14265).                                                                  |
| UDP_PORT         | Port for UDP listener (Default: 14600).                                                                  |
| TCP_PORT         | Port for TCP listener (Default: 15600).                                                                  |
| PRESYNC          | If you want presync your database with iota.partners set 1 (Default: 0).                                 |
| JAVA_OPTIONS     | Default: "-XX:+DisableAttachMechanism -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap" |

## Run with docker-compose

You can also run IRI with docker-compose. See this example:

```
version: '2'

services:
  iota-node:
    container_name: iota-node
    restart: always
    image: rootlogin/iota-iri:latest
    mem_limit: 8G
    network_mode: host
    environment:
      - TZ=Europe/Zurich
      - NEIGHBORS=udp://neighbor1:14600 tcp://neighbor1:15600 udp://neighbor3:14600
    volumes:
      - /opt/iri-data:/opt/iri/data
```
