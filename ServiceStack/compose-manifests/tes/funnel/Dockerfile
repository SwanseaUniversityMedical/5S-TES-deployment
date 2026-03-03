FROM docker:dind-rootless
ARG FUNNEL_VERSION

USER root
RUN apk add --no-cache curl perl-utils \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohsu-comp-bio/funnel/refs/heads/develop/install.sh)" -- ${FUNNEL_VERSION} \
    && cp /root/.local/bin/funnel /usr/local/bin/funnel \
    && chown rootless:rootless /usr/local/bin/funnel \
    && chmod +x /usr/local/bin/funnel \
    && apk del curl perl-utils 
USER rootless

# Set data dir
WORKDIR /opt/funnel/data

# Set entrypoint
WORKDIR /opt/funnel
COPY entrypoint.sh ./entrypoint.sh 
ENTRYPOINT ["./entrypoint.sh"]
