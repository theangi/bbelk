#!/bin/bash
echo "Starting up containers!"
docker-compose up -d --build
echo "Done! Exit with 'docker-compose stop'                  "
echo "To access containers:                                  "
echo "    elasticsearch: 'docker exec -it elasticsearch bash'"
echo "    logstash:      'docker exec -it logstash bash'     "
echo "    kibana:        'docker exec -it kibana bash'       "
echo "-------------------------------------------------------"
echo "To interact via browser:                               "
echo "    kibana: http://localhost:5601                      "
echo "-------------------------------------------------------"
