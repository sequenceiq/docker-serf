# Serf on Docker
This is a [docker](docker.io) image and a couple of helper bash function, to work
with [serf](serfdom.io).

This document describe the process:
- create the docker image
- start a cluster of connected serf agent running in docker containers
- stop/start nodes to check how membership gossip works

## Create the image
```
git clone git@github.com:sequenceiq/docker-serf.git
cd docker-serf
git checkout serf-only
docker build -t sequenceiq/serf .
```

## start a demo cluster

run 3 docker container from the image you just built.
all of them is running in the background (-d docker parameter)

- **serf0** the first one doesn't joins to a cluster as he is the first
- **serf<1..n>** nodes connecting to the cluster

serf-start-cluster function defaults to starting 3 nodes. if you want more
just add a parameter `serf-start-cluster 5`

```
# load helper bash functions serf-xxx
. serf-functions

# start a cluster with 3 nodes
serf-start-cluster

# check the running nodes
docker ps
```

## start a test node and attach

it starts a new container name **serf99**, but not in the brackound, like the previous ones.
you will be attached to the container, which:

- joins the cluster
- starts a **/bin/bash** ready to use

```
serf-test-instance

# once attached to the test instance prompt changes to [bash-4.1#]
serf members
```
you will see now all memebers including the test instance itself **serf99**
```
serf99.mycorp.kom  172.17.0.5:7946  alive  
serf1.mycorp.kom   172.17.0.3:7946  alive  
serf0.mycorp.kom   172.17.0.2:7946  alive  
serf2.mycorp.kom   172.17.0.4:7946  alive
```

## Start/stop a node

Stop one of the nodes:
```
docker stop -t 0 serf1
```

now if you run again the `serf members` in **serf99** you will notice serf1 node marked as **failed**.
note: it might take a couple of seconds, until the cluster gossips around the failure of node99.

```
serf99.mycorp.kom  172.17.0.5:7946  alive
serf1.mycorp.kom   172.17.0.3:7946  failed  
serf0.mycorp.kom   172.17.0.2:7946  alive
serf2.mycorp.kom   172.17.0.4:7946  alive
```

if you resart the node **serf1**:
```
docker start serf1
```

It will apear again as **live**. Check it on **serf99**:
```
serf members

serf99.mycorp.kom  172.17.0.5:7946  alive  
serf1.mycorp.kom   172.17.0.3:7946  alive  
serf0.mycorp.kom   172.17.0.2:7946  alive  
serf2.mycorp.kom   172.17.0.4:7946  alive
```
