#!/bin/sh

if [ -z "$MinioKey" ] || [ -z "$MinioSecret" ]; then
    echo "ERROR: MinioKey and MinioSecret must be set"
    exit 1
fi

sed \
  -e "s|\${MinioKey}|$MinioKey|g" \
  -e "s|\${MinioSecret}|$MinioSecret|g" \
  config/config.template.yaml > config.yaml

exec funnel server run --config config.yaml
