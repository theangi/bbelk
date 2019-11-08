#!/usr/bin/env bash
echo "Adding mapping for tcpdump index..."
curl -X PUT http://localhost:9200/_template/tcp_dump_index?pretty\
     -H "Content-Type: application/json" \
     --data-binary "@init_elastic_config.sh"