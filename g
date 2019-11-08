[1mdiff --git a/docker-compose.yml b/docker-compose.yml[m
[1mindex ced7c7b..012e7f2 100644[m
[1m--- a/docker-compose.yml[m
[1m+++ b/docker-compose.yml[m
[36m@@ -5,26 +5,23 @@[m [mnetworks: { elastic_network_stack: {} }[m
 services:[m
   [m
   elasticsearch:[m
[31m-    image: docker.elastic.co/elasticsearch/elasticsearch:6.6.1[m
[32m+[m[32m    image: docker.elastic.co/elasticsearch/elasticsearch:7.4.0[m
     container_name: elasticsearch[m
[31m-    # restart: unless-stopped[m
     ports: ['9200:9200'][m
     networks: ['elastic_network_stack'][m
     volumes:[m
       - 'es_data:/usr/share/elasticsearch/data'[m
 [m
   kibana:[m
[31m-    image: docker.elastic.co/kibana/kibana:6.6.1[m
[32m+[m[32m    image: docker.elastic.co/kibana/kibana:7.4.0[m
     container_name: kibana[m
[31m-    # restart: unless-stopped[m
     ports: ['5601:5601'][m
     networks: ['elastic_network_stack'][m
     depends_on: ['elasticsearch'][m
 [m
   logstash:[m
[31m-    build: ./logstash-config[m
[32m+[m[32m    build: ./logstash[m
     container_name: logstash[m
[31m-    # restart: unless-stopped[m
     networks: ['elastic_network_stack'][m
     ports: ['5000:5000'][m
     depends_on: ['elasticsearch'][m
[1mdiff --git a/elasticsearch/tcpdump_template.json b/elasticsearch/tcpdump_template.json[m
[1mindex 65705ec..df5e2e7 100644[m
[1m--- a/elasticsearch/tcpdump_template.json[m
[1m+++ b/elasticsearch/tcpdump_template.json[m
[36m@@ -14,7 +14,7 @@[m
       },[m
       "dstIP" : {[m
         "type" : "ip",[m
[31m-        "norms" : false,[m
[32m+[m[32m        "norms" : false[m
       },[m
       "dstPort" : {[m
         "type" : "text",[m
[1mdiff --git a/logstash/Dockerfile b/logstash/Dockerfile[m
[1mindex 1548364..23455d9 100644[m
[1m--- a/logstash/Dockerfile[m
[1m+++ b/logstash/Dockerfile[m
[36m@@ -1,2 +1,2 @@[m
[31m-FROM docker.elastic.co/logstash/logstash:6.6.1[m
[32m+[m[32mFROM docker.elastic.co/logstash/logstash:7.4.0[m
 ADD pipeline /usr/share/logstash/pipeline[m
\ No newline at end of file[m
[1mdiff --git a/logstash/pipeline/logstash-01-tcpdump.conf b/logstash/pipeline/logstash-01-tcpdump.conf[m
[1mindex 734d661..801973c 100644[m
[1m--- a/logstash/pipeline/logstash-01-tcpdump.conf[m
[1m+++ b/logstash/pipeline/logstash-01-tcpdump.conf[m
[36m@@ -19,6 +19,11 @@[m [mfilter{[m
 }[m
 [m
 output {[m
[31m-  elasticsearch { hosts => ["elasticsearch:9200"] }[m
[31m-  # stdout { codec => rubydebug }[m
[32m+[m[32m  elasticsearch {[m
[32m+[m[32m    hosts => ["elasticsearch:9200"][m
[32m+[m[32m    index => "tcp_dump_index"[m
[32m+[m[32m    document_type => "tcpdump_custom_mapping"[m
[32m+[m[32m  }[m
[32m+[m
[32m+[m[32m  stdout { codec => rubydebug }[m
 }[m
\ No newline at end of file[m
[1mdiff --git a/start.sh b/start.sh[m
[1mindex 2187aba..84a2701 100755[m
[1m--- a/start.sh[m
[1m+++ b/start.sh[m
[36m@@ -1,6 +1,10 @@[m
 #!/bin/bash[m
[32m+[m
[32m+[m[32mecho "Enter password to change vm.max_map_count on this host"[m
[32m+[m[32msudo sysctl vm.max_map_count=262144[m
[32m+[m
 echo "Starting up containers!"[m
[31m-docker-compose up -d --build[m
[32m+[m[32mdocker-compose -p bbelk up -d --build[m
 echo "Done! Exit with 'docker-compose stop'                  "[m
 echo "To access containers:                                  "[m
 echo "    elasticsearch: 'docker exec -it elasticsearch bash'"[m
[36m@@ -10,3 +14,14 @@[m [mecho "-------------------------------------------------------"[m
 echo "To interact via browser:                               "[m
 echo "    kibana: http://localhost:5601                      "[m
 echo "-------------------------------------------------------"[m
[32m+[m
[32m+[m[32mread -p "Send ALL TCPDUMPs from this host to elasticsearch? " -n 1 -r[m
[32m+[m[32mecho[m
[32m+[m[32mif [[ $REPLY =~ ^[Yy]$ ]][m
[32m+[m[32mthen[m
[32m+[m[32m    echo "tcpdumping to port 5000 in 30 seconds..."[m
[32m+[m[32m    sleep 30s[m
[32m+[m[32m    echo "start!"[m
[32m+[m[32m    sudo tcpdump | nc -q0 localhost 5000[m
[32m+[m[32m    echo "end bbelk"[m
[32m+[m[32mfi[m
