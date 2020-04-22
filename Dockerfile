FROM alpine:3.10.3

ENV GRAFANA_VERSION=6.7.2
RUN mkdir /tmp/grafana \
  && wget -P /tmp/ https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz \
  && tar xfz /tmp/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz --strip-components=1 -C /tmp/grafana

FROM alpine:3.9
LABEL maintainer "Lauro de Paula <laurobmb@gmail.com>"

ENV PATH=/usr/share/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/usr/share/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning" \
    GF_PATHS_CONF="/etc/grafana/"

RUN mkdir $GF_PATHS_HOME    
WORKDIR $GF_PATHS_HOME    

RUN set -ex 
RUN addgroup -S grafana 
RUN adduser -S -G grafana grafana 
RUN apk add --no-cache libc6-compat ca-certificates su-exec bash

COPY --from=0 /tmp/grafana "$GF_PATHS_HOME"
RUN mkdir -p "$GF_PATHS_HOME/.aws" \
    && mkdir -p "$GF_PATHS_PROVISIONING/datasources" \
        "$GF_PATHS_PROVISIONING/dashboards" \
        "$GF_PATHS_PROVISIONING/notifiers" \
        "$GF_PATHS_LOGS" \
        "$GF_PATHS_PLUGINS" \
        "$GF_PATHS_DATA" \
    && chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" \
    && chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING"

COPY ./files/grafana.ini "$GF_PATHS_CONFIG"
COPY ./files/ldap.toml "$GF_PATHS_CONF"

COPY ./files/dashboards/all_dashboard.yml "$GF_PATHS_PROVISIONING/dashboards"
COPY ./files/dashboards/dashboard-fortigate.json "$GF_PATHS_PROVISIONING/dashboards"
COPY ./files/dashboards/node-exporter.json "$GF_PATHS_PROVISIONING/dashboards"
COPY ./files/dashboards/openvpn-server.json "$GF_PATHS_PROVISIONING/dashboards"

COPY ./files/datasources/all_datasources.yml "$GF_PATHS_PROVISIONING/datasources"

RUN grafana-cli --pluginsDir "${GF_PATHS_PLUGINS}" plugins install alexanderzobnin-zabbix-app

COPY ./run.sh /run.sh

EXPOSE 3000

CMD ["/run.sh"]
