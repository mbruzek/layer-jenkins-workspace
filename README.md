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

# Further information

This charm was built from a the 
[jenkins-workspace layer](https://github.com/juju-solutions/layer-jenkins-workspace)

Check out the [Jenkins documentation](https://jenkins.io/doc/) for more 
information about Jenkins and workspaces.

The [Jenkins charm](https://jujucharms.com/jenkins/) is available at the Juju
Charm Store. 
