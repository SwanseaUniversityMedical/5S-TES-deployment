FROM docker:dind-rootless
WORKDIR /opt/funnel/

USER root
ARG FUNNEL_VERSION=v0.11.7
RUN apk add --no-cache curl perl-utils \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohsu-comp-bio/funnel/refs/heads/develop/install.sh)" -- v0.11.7 \
    && cp /root/.local/bin/funnel /usr/local/bin/funnel \
    && chown rootless:rootless /usr/local/bin/funnel \
    && chmod +x /usr/local/bin/funnel \
    && apk del curl perl-utils 
USER rootless

# Set entrypoint
ENTRYPOINT ["config/entrypoint.sh"]
