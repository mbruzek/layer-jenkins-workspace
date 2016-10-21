#!/bin/bash

# This bash script uses the reactive framework to configure and install a
# Jenkins workspace. https://jujucharms.com/docs/2.0/developer-layer-example

# Source the reactive framework file to get the when and when_not decorators.
source charms.reactive.sh

set -o errexit
set -o xtrace

JENKINS_WORKSPACE_DIR=/var/lib/jenkins/jobs

@when_not 'jenkins-workspace.configured'
function install_prerequisite_software() {
  # Install the pre-requisite software needed before pulling the workspace.
  status-set "maintenance" "Installing prerequisite software."
  # There are additional steps to configure before Jenkins can use Docker.
  apt-get update -qq -y
  # Install Docker, AUFS and the kernel extras.
  apt-get install -y \
    aufs-tools \
    docker.io \
    linux-image-extra-`uname -r` 
  # Add the "jenkins" user to the "docker" group.
  usermod -G docker jenkins
  # Reconfigure the docker daemon to use AUFS instead of DeviceMapper.
  # Append the DOCKER_OPTS to the /etc/default/docker configuration file.
  cat << EOF > /etc/default/docker
# THIS FILE IS MANAGED BY A BUILD SCRIPT!
DOCKER_OPTS="--storage-driver=aufs"
EOF
  # Restart the docker daemon to get the new AUFS support.
  service docker restart || true
  # Restart jenkins so it can access the docker daemon.
  service jenkins restart || true

  charms.reactive set_state 'jenkins-workspace.configured'
}

@when_not 'jenkins-workspace.delivered'
function deliver_resource_payload() {
  # Use the Juju resources feature to get the workspace configuration.
  WORKSPACE_ARCHIVE=$(resource-get workspace) || true
  # When the archive file is zero size or workspace zip path is empty, return.
  if [[ $? != 0 || -z "${WORKSPACE_ARCHIVE}" ]]; then
     status-set "waiting" "Waiting for a workspace to be provided via 'juju attach'."
     return
  fi
  # When the archive file exists uncompress it.
  if [ -f "${WORKSPACE_ARCHIVE}" ]; then
     # Uncompress the archive in the Jenkins workspace directory.
     tar -xvzf $WORKSPACE_ARCHIVE -C $JENKINS_WORKSPACE_DIR
     # Make sure the "jenkins" user owns the files.
     chown -R jenkins:jenkins $JENKINS_WORKSPACE_DIR/*
     # The configuration changed, reload Jenkins.
     service jenkins restart || true
     status-set "active" "Workspace uncompressed, ready to build."
     charms.reactive set_state 'jenkins-workspace.delivered'
  fi
}

set +o xtrace

reactive_handler_main
