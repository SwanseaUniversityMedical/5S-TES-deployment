#!/bin/sh
sed \
  -e "s|\${MinioKey}|$MinioKey|g" \
  -e "s|\${MinioSecret}|$MinioSecret|g" \
  config/config.template.yaml > config.yaml

exec funnel server run --config config.yaml
