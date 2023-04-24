FROM telegraf:1.26 AS telegraf

RUN touch /tmp/emptyfile

FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_SERVICES_GRACETIME=10000 \
    S6_KILL_GRACETIME=10000

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY rootfs/ /

# add telegraf binary
COPY --from=telegraf /usr/bin/telegraf /usr/bin/telegraf

RUN set -x && \
    TEMP_PACKAGES=() && \
    KEPT_PACKAGES=() && \
    KEPT_PACKAGES+=(socat) && \
    TEMP_PACKAGES+=(git) && \
    # install packages
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ${KEPT_PACKAGES[@]} \
        ${TEMP_PACKAGES[@]} \
        && \
    # set up base telegraf config directories
    mkdir -p /etc/telegraf/telegraf.d && \
    # document telegraf version
    bash -ec "telegraf --version >> /VERSIONS" && \
    # document versions
    bash -ec 'grep -v tar1090-db /VERSIONS | grep tar1090 | cut -d " " -f 2 > /CONTAINER_VERSION' && \
    cat /VERSIONS && \
    # Clean-up.
    apt-get remove -y ${TEMP_PACKAGES[@]} && \
    apt-get autoremove -y && \
    rm -rf /src/* /tmp/* /var/lib/apt/lists/*


