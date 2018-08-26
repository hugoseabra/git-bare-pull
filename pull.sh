#! /bin/bash

source /etc/sync_env

SYNC_DIR="/sync-dir/${GIT_REPO_MAINTAINER}/${GIT_REPO_DIR_NAME}"

function die {
    echo >&2 "$@"
    exit 1
}

echo "Starting sync at $(date -R)"

KNOWN_HOSTS_FILE_PATH="/root/.ssh/known_hosts"
if [ ! -n "$(grep "^${GIT_REPO_DOMAIN} " ${KNOWN_HOSTS_FILE_PATH})" ]; then
  echo "registering known host for ${GIT_REPO_DOMAIN} ..."
   ssh-keyscan ${GIT_REPO_DOMAIN} >> ${KNOWN_HOSTS_FILE_PATH} 2>/dev/null;
fi

if [ ! -d "$SYNC_DIR" ]; then
  echo "${SYNC_DIR} does not exist or is not a directory. Performing initial clone."
  git clone --bare "${GIT_REPO_URL}" "${SYNC_DIR}" || die "git clone failed"
fi

cd ${SYNC_DIR}

git pull origin "${GIT_REPO_BRANCH}" || die "git pull failed"

echo ;