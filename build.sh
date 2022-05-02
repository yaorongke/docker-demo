#!/bin/bash
# sh build.sh harbor.rkyao.com rkyao admin Harbor12345

# 前提是docker仓库上已创建命名空间 rkyao
docker_hub_domain=$1
docker_hub_namespace=$2
docker_hub_username=$3
docker_hub_password=$4

# 不同服务只需修改 service_name
service_name=docker-demo
service_version=latest

mvn clean package -Dmaven.test.skip=true

docker build -t ${docker_hub_domain}/${docker_hub_namespace}/${service_name}:${service_version} .

docker login --username=${docker_hub_username} ${docker_hub_domain} -p ${docker_hub_password}

docker push ${docker_hub_domain}/${docker_hub_namespace}/${service_name}:${service_version}

docker rmi ${docker_hub_domain}/${docker_hub_namespace}/${service_name}:${service_version}
