#!/bin/sh
sed \
  -e "s|\${MinioKey}|$MinioKey|g" \
  -e "s|\${MinioSecret}|$MinioSecret|g" \
  config/config.template.yaml > config.yaml
exec /root/.local/bin/funnel server run --config config.yaml
