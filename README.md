# jenkins-workspace 

This is a subordinate charm used to configure the Jenkins builders for a 
deployed [jenkins charm](https://jujucharms.com/jenkins). 

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

### snapshot
`snapshot` - Create a compressed snapshot of the workspace directories. The 
resulting tgz file is compatible with this charm's resource.

Example snapshot operation:

```
# Create the snapshot of the current Jenkins Jobs.
juju run-action jenkins-workspace/0 snapshot outfile=/home/ubuntu/snapshot.tgz
# Copy the snapshot out of the charm to the local directory.
juju scp jenkins-workspace/0:/home/ubuntu/snapshot.tgz .
```

### restore-snapshot

`restore-snapshot` - Takes a Juju resource (tgz file) and installs the
workspaces uncompresses to the Jenkins jobs directory. Using the `atomic` flag
allows the removal of existing workspaces before the resource is expanded.

```
# Upload a new resource to the jenkins-workspace charm.
juju attach jenkins-workspace workspace=./snapshot.tgz
# Delete current Jenkins jobs and install the current workspace resource.
juju run-action jenkins-workspace restore-snapshot atomic=True
```

# Further information

This charm was built from a the 
[jenkins-workspace layer](https://github.com/juju-solutions/layer-jenkins-workspace)

Check out the [Jenkins documentation](https://jenkins.io/doc/) for more 
information about Jenkins and workspaces.

The [Jenkins charm](https://jujucharms.com/jenkins/) is available at the Juju
Charm Store. 
