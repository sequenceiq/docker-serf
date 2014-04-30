# Serf on Docker

This image aims to provide resolvable fully qualified domain names,
between dynamically created docker containers.

## The problem

By default **/etc/hosts** is readonly in docker containers. The usual
solution is to start a DNS server (probably as a docker container) and pass
a reference when starting docker instances: `docker run -dns <IP_OF_DNS>`

The issues are:
- the DNS server is a single point of failure
- you still have to reconfigure DNS at the start of every node
- nodes probably want to know about each other, for that you need something

## The solution

To avoid the single point of failure of a dedicated dns, lets start a lightweight
dns: dnsmasq on each node. How they get informed of joining nodes? Here comes
Serf:

> Serf is a service discovery and orchestration tool that is decentralized,
highly available, and fault tolerant.

whenever a node joins or leaves the cluster
![serf on docker](https://s3-eu-west-1.amazonaws.com/sequenceiq/serf-docker.png)

There are several Service Discovery projects including: zookeper, etcd, eureka,
but they seemed to be an overkill. Especially that the original problem domain
was hadoop cluster on docker, so for hadoop you will use zookeper anyway.

So [Serf](http://www.serfdom.io/) was chosen:

> Serf's architecture is based on gossip and provides a smaller feature set.
Serf only provides membership, failure detection, and user events.

Notable features:
 - no single point of failure
 - single binary distribution
 - easy extensibility via user-event handler scripts

The other part of the solution is [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
a lightweight dns server.


## References

 - [Serf vs. ZooKeeper, doozerd, etcd](http://www.serfdom.io/intro/vs-zookeeper.html)
 - [compairing Open-Source Service Discovery](http://jasonwilder.com/blog/2014/02/04/service-discovery-in-the-cloud/)
