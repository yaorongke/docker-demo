#### 一、镜像打包并上传

`build.sh` 用于构建 `maven`、打包 `docker` 镜像并上传到 `docker` 仓库，执行时根据传递的参数区分不同的环境。

```shell
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
```

使用的`docker`仓库为阿里云容器镜像服务，需在上传镜像前在上面创建命名空间 `rkyao`。

#### 二、部署服务

##### 1、docker部署

```shell
# 拉取镜像
docker pull harbor.rkyao.com/rkyao/docker-demo:1.0.0
# 运行容器
docker run -p 8090:8090 -d harbor.rkyao.com/rkyao/docker-demo:1.0.0
```

测试服务是否正常，外网访问

```
localhost:8090/docker-demo/docker/test01?id=1
```

##### 2、k8s部署

在 `k8s` 的 `master` 节点上创建名为 `myhub` 的 `secret`，设置 `docker` 镜像仓库的信息，创建一次即可，不需每个服务都创建

```shell
kubectl create secret docker-registry myhub \
  --docker-server=harbor.rkyao.com \
  --docker-username=admin \
  --docker-password=Harbor12345 \
  --docker-email=123456@163.com
```

在 `k8s` 的 `master` 节点上创建名为 `my-config` 的`configmap`，设置环境变量，创建一次即可，不需每个服务都创建

```shell
# 删除
kubectl delete configmap my-config
# 创建 设置环境变量 myenv 为 prod, 用于启动服务时选择配置文件
kubectl create configmap my-config --from-literal=myenv=prod
# 查看
kubectl describe configmap my-config
```

创建 `k8s` 部署文件 `k8s-deployment.yaml`，上传到 `k8s` 的 `master` 节点

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: docker-demo-deployment
  labels:
    app: docker-demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: docker-demo
  template:							
    metadata:
      labels:
        app: docker-demo
    spec:
      containers:
      - name: docker-demo
        image: harbor.rkyao.com/rkyao/docker-demo:latest
        imagePullPolicy: Always
        envFrom:
            - configMapRef:
                name: my-config
        ports:
        - containerPort: 8090
      imagePullSecrets:
      - name: myhub
---
apiVersion: v1
kind: Service
metadata:
  name: docker-demo-service
  labels:
    app: docker-demo
spec:
  type: NodePort
  ports:
    - port: 8090
      nodePort: 30001
      targetPort: 8090
  selector:
    app: docker-demo
```

在 `k8s` 的 `master` 节点上执行

```shell
# 删除旧的deployment
kubectl delete -f k8s-deployment.yaml
# 创建新的deployment
kubectl apply -f k8s-deployment.yaml
```

测试服务是否正常

```shell
# 只能内网访问 pod地址+容器port
curl 172.17.43.30:8090/docker-demo/docker/test01?id=1
# 只能内网访问 云服务器内网地址 + nodePort
curl 10.0.16.9:30001/docker-demo/docker/test01?id=1
# 内外网皆可访问 云服务器公网地址 + nodePort
curl 1.117.41.254:30001/docker-demo/docker/test01?id=1
```

#### 三、调试方法

##### Arthas

```shell
docker exec -it f6843bd31fd6 /bin/bash
cd /opt/arthas
java -jar arthas-boot.jar
```

