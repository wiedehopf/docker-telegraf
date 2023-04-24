# sdr-enthusiasts/docker-telegraf

* run telegraf

## Supported tags and respective Dockerfiles

* `latest` should always contain the latest released versions of `readsb`, `tar1090` and `tar1090-db`.
* `latest_nohealthcheck` is the same as the `latest` version above. However, this version has the docker healthcheck removed. This is done for people running platforms (such as [Nomad](https://www.nomadproject.io)) that don't support manually disabling healthchecks, where healthchecks are not wanted.
* Specific version tags are available if required, however these are not regularly updated. It is generally recommended to run latest.

## Prerequisites

You will need to point this container to one more multiple data sources

### General Options

| Variable | Description | Default |
|----------|-------------|---------|
| `TAR1090_URL` | URL tar1090 interface to get data from | Unset |

## Logging

All logs are to the container's stdout and can be viewed with `docker logs -t [-f] container`.

## Getting help

Please feel free to [open an issue on the project's GitHub](https://github.com/sdr-enthusiasts/docker-tar1090/issues).

We also have a [Discord channel](https://discord.gg/sTf9uYF), feel free to [join](https://discord.gg/sTf9uYF) and converse.

```yaml
version: '3.8'

services:

  telegraf:
    image: ghcr.io/sdr-enthusiasts/docker-telegraf:latest
    tty: true
    container_name: telegraf
    hostname: telegraf
    restart: always
    environment:
      - TZ=Australia/Perth
      - TAR1090_URL=tar1090
    ports:
      - 9273:9273
    tmpfs:
      - /run:exec,size=64M
      - /var/log
```

The first part of the mount before the : is the path on the docker host, don't change the 2nd part.
Using this volume gives you persistence for the history / heatmap / range outline

Note that this mode will make T not work as before for displaying all tracks as tracks are only loaded when you click them.

## Metrics

This image contains [Telegraf](https://docs.influxdata.com/telegraf/), which will be used to capture metrics from other containers if an output is enabled.

### Output to InfluxDBv2

In order for Telegraf to output metrics to an [InfluxDBv2](https://docs.influxdata.com/influxdb/) time-series database, the following environment variables can be used:

| Variable | Description |
| ---- | ---- |
| `INFLUXDBV2_URL` | The URL of the InfluxDB instance |
| `INFLUXDBV2_TOKEN` | The token for authentication |
| `INFLUXDBV2_ORG` | InfluxDB Organization to write into |
| `INFLUXDBV2_BUCKET` | Destination bucket to write into |

### Output to Prometheus

In order for Telegraf to serve a [Prometheus](https://prometheus.io) endpoint, the following environment variables can be used:

| Variable | Description |
| ---- | ---- |
| `PROMETHEUS_ENABLE` | Set to `true` for a Prometheus endpoint on `http://0.0.0.0:9273/metrics` |
