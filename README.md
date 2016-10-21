# jenkins-workspace 

This is a subordinate charm used to configure builders for a deployed 
[jenkins charm](https://jujucharms.com/jenkins). 

Jenkins is an automation engine with a plugin ecosystem that supports a variety
of tools to create delivery pipelines, continuous integration, automated
testing, or continuous delivery. 

This subordinate customizes the workspace on any unit added to the horizontally
scalable Jenkins server.

## Usage

Deploy the jenkins charm and deploy the jenkins-workspace charm and relate the
two charms in Juju:

```
juju deploy jenkins
juju deploy jenkins-workspace
juju add-relation jenkins jenkins-workspace
```

Then you need to add the "workspace" resource to the jenkins-workspace charm.
The workspace resource is a compressed archive of at a minimum, a directory
with the buildler name, and a `config.xml` with the builder definition.

Add the resource using the Juju resources feature:

```
juju attach jenkins-workspace workspace=kubernetes-builder.tgz
```

## Supported Actions

Snapshot - Compress a workspace.tgz compatible with this charms resources.

Example snapshot and restore operation:

```
juju run-action jenkins-workspace/0 snapshot outfile=/home/ubuntu/workspace.tgz
juju scp jenkins-workspace/0:/home/ubuntu/workspaces.tgz .
juju attach jenkins-workspace workspaces=./workspaces.tgz
```

Snapshot-restore Allows the force deployment of a snapshot provided through 
resource.

# Further information

This charm was built from a the 
[jenkins-workspace layer](https://github.com/juju-solutions/layer-jenkins-workspace)

Check out the [Jenkins documentation](https://jenkins.io/doc/) for more 
information about Jenkins and workspaces.

The [Jenkins charm](https://jujucharms.com/jenkins/) is available at the Juju
Charm Store. 
