FROM docker.io/prom/alertmanager:v0.32.2

LABEL org.opencontainers.image.authors="jahrik@gmail.com"

COPY config.yml /etc/alertmanager/config.yml

EXPOSE 9093
VOLUME [ "/alertmanager" ]

CMD [ "--config.file=/etc/alertmanager/config.yml", "--storage.path=/alertmanager" ]
