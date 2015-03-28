FROM debian:jessie

# setup mackerel-agent
RUN apt-get update \
  && apt-get -y install curl sudo ruby docker.io \
  && curl -fsSL https://mackerel.io/assets/files/scripts/setup-apt.sh | sh \
  && apt-get update \
  && apt-get -y install mackerel-agent mackerel-agent-plugins \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup docker plugin
COPY mackerel-plugin-docker.rb /mackerel-plugin-docker.rb
RUN echo [plugin.metrics.docker] >> /etc/mackerel-agent/mackerel-agent.conf
RUN echo command = \"ruby /mackerel-plugin-docker.rb\" >> /etc/mackerel-agent/mackerel-agent.conf

# boot mackerel-agent
# CMD /usr/local/bin/mackerel-agent -apikey="${apikey}" -v
CMD /usr/local/bin/mackerel-agent -apikey="${apikey}"
