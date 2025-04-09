#!/bin/bash
podman build . -t docker.io/meuna/lsdc2:minecraft \
&& podman push docker.io/meuna/lsdc2:minecraft