FROM ubuntu:24.04 
WORKDIR /opt/funnel

RUN apt update && apt install -y curl perl

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohsu-comp-bio/funnel/refs/heads/develop/install.sh)" -- v0.11.7

RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh get-docker.sh

ENTRYPOINT ["config/entrypoint.sh"]
