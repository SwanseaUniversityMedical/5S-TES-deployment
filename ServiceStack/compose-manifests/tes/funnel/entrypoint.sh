#!/bin/sh
sed \
  -e "s|\${MinioKey}|$MinioKey|g" \
  -e "s|\${MinioSecret}|$MinioSecret|g" \
  config/config.template.yaml > config.yaml
echo "##### ----- Funnel config start -----"
cat config.yaml
echo "##### ----- Funnel config end -----"
exec funnel server run --config config.yaml
