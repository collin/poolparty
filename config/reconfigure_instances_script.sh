#!/bin/sh

echo "Setting up pem files"
:setup_pems
# Move the hosts file
echo "Moving the hosts file into place"
:move_hostfile
# Move the authkeys
echo "Configuring the authkeys"
:configure_authkeys
# Move the config file
echo "Moving custom config file for this cloud"
:move_config_file
# Reconfigure master if master?
echo "If this is the master, I'm configuring it as the master now"
:config_master
# Configure haproxy
echo "Configuring and starting haproxy"
:configure_haproxy
# Configure heartbeat
echo "Moving all the resource.d files into place"
:configure_resource_d
# Start heartbeat
echo "Configuring and starting heartbeat"
:configure_heartbeat
# Start s3fs
echo "Mounting shared drive, if shared_bucket exists in config"
:mount_s3_drive
# Configure monit
echo "Configuring monit"
:configure_monit
# Update the plugins
echo "Updating plugins"
:update_plugins
# Run user tasks
echo "Running user tasks"
:user_tasks