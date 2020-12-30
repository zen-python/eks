helm repo add elastic https://helm.elastic.co
helm repo update
helm search hub elasticsearch
helm install elasticsearch elastic/elasticsearch

kubectl port-forward svc/elasticsearch-master 9200:9200
curl http://localhost:9200/

helm install filebeat elastic/filebeat
curl http://localhost:9200/_cat/indices

helm install kibana elastic/kibana
kubectl port-forward svc/kibana-kibana 5601:5601


helm install metricbeat elastic/metricbeat
curl http://localhost:9200/_cat/indices

helm get values --all metricbeat | grep imageTag

curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.8.0-darwin-x86_64.tar.gz
tar xzvf metricbeat-7.8.0-darwin-x86_64.tar.gz
cd metricbeat-7.8.0-darwin-x86_64
./metricbeat setup --dashboards
