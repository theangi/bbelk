#!/bin/bash

echo "Enter password to change vm.max_map_count on this host"
sudo sysctl vm.max_map_count=262144

echo "Starting up containers!"
docker-compose -p bbelk up -d --build
echo "Done! Exit with 'docker-compose stop'                  "
echo "To access containers:                                  "
echo "    elasticsearch: 'docker exec -it elasticsearch bash'"
echo "    logstash:      'docker exec -it logstash bash'     "
echo "    kibana:        'docker exec -it kibana bash'       "
echo "-------------------------------------------------------"
echo "To interact via browser:                               "
echo "    kibana: http://localhost:5601                      "
echo "-------------------------------------------------------"

read -p "Send ALL TCPDUMPs from this host to elasticsearch? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "tcpdumping to port 5000 in 30 seconds..."
    sleep 30s
    echo "start!"
    sudo tcpdump | nc -q0 localhost 5000
    echo "end bbelk"
fi
