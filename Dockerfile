FROM java:8

COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas

COPY target/docker-demo.jar /data/app.jar
COPY bootstrap.sh /data/bootstrap.sh

RUN chmod 755 /data/bootstrap.sh && \
mkdir -p /data/logs && \
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

CMD ["/data/bootstrap.sh"]
