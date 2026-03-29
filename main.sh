#!/usr/bin/env bash
#Variables
source ./config.sh
source ./logging.sh

write_log "----SCRIPT STARTED----"
write_log "Docker home directory is $DOCKER_HOME"

################################################################################## Stop all containers

write_log "Stopping all containers..."


if docker stop $(docker ps -a -q) ; then
    write_log "Successfully all running containers"
else
    write_error "Issues were encountered while stopping containers"
fi

write_log "All containers stopped successfully"

################################################################################## Create archive locally

write_log "Creating archive..."
ARCHIVE_NAME="AJRy-archive-$DATE.zip"

if zip -r  -v "./$ARCHIVE_NAME" $DOCKER_HOME ; then
     write_log "Successfully created archive"
    else
        write_error "Issues were encountered while creating archive"
fi

################################################################################## Export Archive
write_log "Copying archive to remote repo..."
if scp -i $SSH_KEY "$ARCHIVE_NAME" "$REMOTE_REPO" ; then
     write_log "Done"
else
    write_error "Issues were encountered while copying archive to remote repo"
fi

################################################################################## Delete local Archive
write_log "Deleting local archive file..."
if rm -f $ARCHIVE_NAME ; then
    write_log "Done"
else
    write_error "Issues were encountered while deleting local archive $ARCHIVE_NAME"
fi

################################################################################## Start uncommented containers
write_log "Starting stopped containers..."
for file in $(cat ./compose-files.txt | egrep -v "#" ); do
    if docker compose -f $file start ; then
        write_log "Successfully started $file"
    else
        write_error "Issues were encountered starting $file"
    fi
done

write_log "All containers stopped successfully"

write_log "----SCRIPT FINISHED----"