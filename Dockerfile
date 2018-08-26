FROM ubuntu:16.04
MAINTAINER Hugo Seabra <hugoseabra19@gmail.com>

# Install runtime dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qq -y --no-install-recommends git openssh-client cron

# Install scripts
COPY pull.sh entrypoint.sh /usr/local/bin/

# Run the command on container startup
ENTRYPOINT ["entrypoint.sh"]
