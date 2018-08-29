#! /bin/bash

source /etc/sync_env

function die {
    echo >&2 "$@"
    echo ;
    exit 1
}

echo "Starting pull at $(date -R)"

KNOWN_HOSTS_FILE_PATH="/root/.ssh/known_hosts"
if [ ! -n "$(grep "^${GIT_REPO_DOMAIN} " ${KNOWN_HOSTS_FILE_PATH})" ]; then
  echo "registering known host for ${GIT_REPO_DOMAIN} ..."
  echo "> ssh-keyscan ${GIT_REPO_DOMAIN} >> ${KNOWN_HOSTS_FILE_PATH}"
  ssh-keyscan ${GIT_REPO_DOMAIN} >> ${KNOWN_HOSTS_FILE_PATH} 2>/dev/null;
fi

MAINTAINER_DIR="/sync-dir/${GIT_REPO_MAINTAINER}"

if [ ! -d "${MAINTAINER_DIR}" ]; then
  echo "> mkdir -p ${MAINTAINER_DIR}"
  mkdir -p ${MAINTAINER_DIR}
fi

echo "> cd ${MAINTAINER_DIR}"
cd ${MAINTAINER_DIR}

if [ -d "${GIT_REPO_DIR_NAME}" ]; then
  mkdir -p ${MAINTAINER_DIR}
  echo "> cd ${GIT_REPO_DIR_NAME}"
  cd ${GIT_REPO_DIR_NAME}

  # Guarantee that the directory is a bare repository
  branches  config  description  HEAD  hooks  info  objects  packed-refs  refs
  if [ -d "branches" -a -d "hooks" -a -d "info" -a -d "objects" -a -d "refs" -a -e "config" -a -e "description" -a -e "HEAD" ]; then
    echo "> git fetch --prune"
    git fetch --prune || die "git pull failed"
    echo ;
    exit 0

  else
    rm -rf ${GIT_REPO_DIR_NAME}
  fi
fi

echo "${MAINTAINER_DIR}/${GIT_REPO_DIR_NAME} does not exist or is not a directory. Performing initial clone."
echo "> git clone --bare ${GIT_REPO_URL} ${GIT_REPO_DIR_NAME}"
git clone --bare "${GIT_REPO_URL}" "${GIT_REPO_DIR_NAME}" || die "git clone failed"
cd ${GIT_REPO_DIR_NAME}
git config remote.origin.fetch "+*:*"
echo ;
