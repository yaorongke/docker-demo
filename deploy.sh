#!/bin/bash
# dev
# sh deploy.sh 192.168.73.143
# prod
# sh deploy.sh 1.117.41.254

k8s_ip=$1
# 不同服务只需修改 service_name
service_name=docker-demo
yaml_path=/home/k8s-deploy/${service_name}/k8s-deployment.yaml

ssh root@${k8s_ip} "rm -rf /home/k8s-deploy/${service_name}"
ssh root@${k8s_ip} "mkdir -p /home/k8s-deploy/${service_name}"
scp k8s-deployment.yaml root@${k8s_ip}:${yaml_path}

ssh root@${k8s_ip} "kubectl delete -f ${yaml_path}"
ssh root@${k8s_ip} "kubectl apply -f ${yaml_path}"