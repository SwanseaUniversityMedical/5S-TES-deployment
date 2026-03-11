# Build stage — install Funnel in a temporary container
FROM alpine:latest AS builder
ARG FUNNEL_VERSION
RUN apk add --no-cache curl perl-utils \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohsu-comp-bio/funnel/refs/heads/develop/install.sh )" -- ${FUNNEL_VERSION} \
    && cp /root/.local/bin/funnel /tmp/funnel

# Final stage — use Funnel Binary in a rootless Docker image
FROM docker:dind-rootless

USER root
RUN apk update && apk upgrade --no-cache

COPY --from=builder /tmp/funnel /usr/local/bin/funnel

# Create directories and set ownership
RUN chown rootless:rootless /usr/local/bin/funnel \
    && chmod +x /usr/local/bin/funnel \
    && mkdir -p /opt/funnel/data \
    && chown -R rootless:rootless /opt/funnel

# Switch to rootless
USER rootless
WORKDIR /opt/funnel

COPY --chmod=+x --chown=rootless:rootless entrypoint.sh ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]