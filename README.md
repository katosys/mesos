# mesos

[![Build Status](https://travis-ci.org/katosys/mesos.svg?branch=master)](https://travis-ci.org/katosys/mesos)

This container is used to build, ship and deploy a native CoreOS Mesos build. The payload of this container are Mesos binaries and libraries which are deployed in `/opt` on the CoreOS host system. A single `systemd` unit can be used to retrieve, deploy and start a Mesos master and agents. The `Dockerfile` has many steps that can be cached to speed up development. It is therefore recommended to squash the final image (rkt + ACI + quay.io = squash). The final download should be less than 20MB.

**Mesos master example**:
```
[Unit]
Description=Mesos master
After=zookeeper.service

[Service]
Slice=kato.slice
Restart=always
RestartSec=10
TimeoutStartSec=0
KillMode=mixed
EnvironmentFile=/etc/kato.env
Environment=IMG=quay.io/kato/mesos:latest
ExecStartPre=/opt/bin/zk-alive ${KATO_QUORUM_COUNT}
ExecStartPre=/usr/bin/rkt fetch ${IMG}
ExecStartPre=/usr/bin/rkt run \
 --volume rootfs,kind=host,source=/ \
 --mount volume=rootfs,target=/media \
 ${IMG} --exec cp -- -R /opt /media
ExecStart=/usr/bin/bash -c " \
 PATH=/opt/bin:${PATH} \
 LD_LIBRARY_PATH=/lib64:/opt/lib \
 exec /opt/bin/mesos-master \
  --hostname=master-${KATO_HOST_ID}.${KATO_DOMAIN} \
  --cluster=${KATO_CLUSTER_ID} \
  --ip=${KATO_HOST_IP} \
  --zk=zk://${KATO_ZK}/mesos \
  --work_dir=/var/lib/mesos/master \
  --log_dir=/var/log/mesos \
  --quorum=${KATO_QUORUM}"

[Install]
WantedBy=kato.target
```

**Mesos agent example:**
```
[Unit]
Description=Mesos agent
After=go-dnsmasq.service

[Service]
Slice=kato.slice
Restart=always
RestartSec=10
TimeoutStartSec=0
KillMode=mixed
EnvironmentFile=/etc/kato.env
Environment=IMG=quay.io/kato/mesos:latest
ExecStartPre=/opt/bin/zk-alive ${KATO_QUORUM_COUNT}
ExecStartPre=/usr/bin/rkt fetch ${IMG}
ExecStartPre=/usr/bin/rkt run \
 --volume rootfs,kind=host,source=/ \
 --mount volume=rootfs,target=/media \
 ${IMG} --exec cp -- -R /opt /media
ExecStart=/usr/bin/bash -c " \
 PATH=/opt/bin:${PATH} \
 LD_LIBRARY_PATH=/lib64:/opt/lib \
 exec /opt/bin/mesos-agent \
 --executor_environment_variables='{\"LD_LIBRARY_PATH\": \"/lib64:/opt/lib\"}' \
 --hostname=worker-${KATO_HOST_ID}.${KATO_DOMAIN} \
 --ip=${KATO_HOST_IP} \
 --containerizers=mesos \
 --image_providers=docker \
 --docker_store_dir=/var/lib/mesos/store/docker \
 --isolation=filesystem/linux,docker/runtime \
 --executor_registration_timeout=5mins \
 --master=zk://${KATO_ZK}/mesos \
 --work_dir=/var/lib/mesos/agent \
 --log_dir=/var/log/mesos/agent \
 --network_cni_config_dir=/var/lib/mesos/cni-config \
 --network_cni_plugins_dir=/var/lib/mesos/cni-plugins"

[Install]
WantedBy=kato.target
```
