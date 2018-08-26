#! /bin/bash

touch /var/log/cron.log

function die {
    echo >&2 "$@"
    exit 1
}

# Check mandatory environment variables
if [ -z "${GIT_REPO_DOMAIN}" ]; then
  die "GIT_REPO_DOMAIN must be specified!"
fi
if [ -z "${GIT_REPO_DIR_NAME}" ]; then
  die "GIT_REPO_DIR_NAME must be specified!"
fi
if [ -z "${GIT_REPO_MAINTAINER}" ]; then
  die "GIT_REPO_MAINTAINER must be specified!"
fi
if [ -z "${GIT_REPO_URL}" ]; then
  die "GIT_REPO_URL must be specified!"
fi

# Ensure correct permissions
chmod 0700 /root/.ssh
chmod 0600 /root/.ssh/id_rsa

touch /root/.ssh/known_hosts
chmod 0644 /root/.ssh/known_hosts


echo "GIT_REPO_DOMAIN=${GIT_REPO_DOMAIN}" >> /etc/sync_env
echo "GIT_REPO_DIR_NAME=${GIT_REPO_DIR_NAME}" >> /etc/sync_env
echo "GIT_REPO_MAINTAINER=${GIT_REPO_MAINTAINER}" >> /etc/sync_env
echo "GIT_REPO_URL=${GIT_REPO_URL}" >> /etc/sync_env

/usr/local/bin/pull.sh

# CRON_TIME can be set via environment
# If not defined, the default is every minute
CRON_TIME=${CRON_TIME:-*/5 * * * *}
echo "Using cron time ${CRON_TIME}"
echo "${CRON_TIME} root /usr/local/bin/pull.sh > /var/log/cron.log 2>&1" >> /etc/cron.d/git-sync
chmod 644 /etc/cron.d/git-sync
echo ;

cron && tail -f /var/log/cron.log
