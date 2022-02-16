
Hostnames are important. The master node should be named `control`, the squid host `frontier-squid`,
and the workers will have a `workers` in their names (automatically).

# Setting up the control node

This repository should be checked out to `/srv/osg-jetstream2`

Create the following two files to hold secrets:

`/srv/pillar/top.sls`

    base:
      '*':
        - secrets

`/srv/pillar/secrets.sls`

    ospool_token: ******
    restapi_token: ******


# Bootstrapping (can be done on any node)

```
rpm --import https://repo.saltproject.io/py3/redhat/8/x86_64/latest/SALTSTACK-GPG-KEY.pub
curl -fsSL https://repo.saltproject.io/py3/redhat/8/x86_64/latest.repo >/etc/yum.repos.d/salt.repo
yum install -y salt-minion
echo "master: control" >/etc/salt/minion.d/minion.conf
salt-call state.highstate
```


