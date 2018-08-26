# git-bare-pull
A docker image allowing you to pull a bare repository to a directory. You schedulle the pull action
to keep you bare repository updated, so you can use it in to share it or in Redmine (my case).

To use it, you must pass the following **environment variables**:

* `GIT_REPO_DOMAIN`: Domain to register the SSH `known_host`;
* `GIT_REPO_MAINTAINER`: Nome of organization or maintainer of the git project. It will create a parent directory;
* `GIT_REPO_URL`: URL of the Git repository to sync to, for example `ssh://git@example.com/foo/bar.git`;
* `GIT_REPO_DIR_NAME`: name of directory where the bare repository will be updated.

Optionally, you can set
* `CRON_TIME`: The execution time of the sync cronjob. For the syntax check [CronHowto](https://help.ubuntu.com/community/CronHowto). Default is every minute (`*/5 * * * *`).

Furthermore you need to setup the following two **volumes**:

* `/root/.ssh`: This volume should contain a valid ssh key (`id_rsa` and `id_rsa.pub`) with write access to the specified git repository. Also it should contain a valid `known_hosts` file.
