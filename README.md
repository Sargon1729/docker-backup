# docker-backup
Painless way to backup docker containers on remote hosts

Simply copy and rename the `config.example.sh` to `config.sh` and provide the required variables.

Do the same for `compose-files.txt`, place the full path for the compose files, one on each line, and comment out the ones you want to start back up after the backup is complete.

You also need to make sure the correct permissions are set on the private ssh key, `chmod 700 ./key.pem` should do it.