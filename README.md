[![Build Status](https://travis-ci.org/marcindulak/docker-nwchem-openmpi.svg?branch=master)](https://travis-ci.org/marcindulak/docker-nwchem-openmpi)

# Description

Dockerfile for NWCHEM http://www.nwchem-sw.org/ built against openmpi, based on Fedora.

The docker images are available at [dockerhub](https://hub.docker.com/r/marcindulak/nwchem-openmpi)


# Usage

First, make sure you are able to run the `docker run hello-world` example https://docs.docker.com/get-started/.
**Note** on MS Windows install https://hub.docker.com/editions/community/docker-ce-desktop-windows.

Then test the basic NWCHEM functionality

```sh
docker run --rm -it marcindulak/nwchem-openmpi:latest bash -c '. /etc/profile.d/modules.sh&& module use /usr/share/modulefiles&& module load mpi/openmpi-x86_64&& echo -e "geometry\nH 0 0 0\nH 0 0 1\nend\nbasis\nH library STO-3G\nend\ntask dft energy" > /tmp/h2.nw && mpiexec --allow-run-as-root -np 1 nwchem_openmpi /tmp/h2.nw'
```

**Note**: if on MS Windows you are getting 'image operating system "linux" cannot be used on this platform' follow https://docs.docker.com/docker-for-windows/#switch-between-windows-and-linux-containers

When running NWCHEM jobs inside of the container you want the output files created by NWCHEM to
be accessible locally on the machine running the job.
In order to achieve this create a local storage directory for this particular myjob.

```sh
mkdir myjob
```

Create a NWCHEM input script and save into the `myjob` directory.

Then start the job mounting the local storage directory as a docker volume https://docs.docker.com/storage/volumes/ inside of the container.
You have two choices, listed below.

## Run a job with docker-compose

```sh
docker-compose -f docker-compose.myjob.yml up
```

Remove the terminated container

```sh
docker-compose -f docker-compose.myjob.yml down
```

## Run a job manually

```sh
docker run --name myjob --rm -it -v "$(pwd)/myjob:/mnt" marcindulak/nwchem-openmpi:latest bash -c '. /etc/profile.d/modules.sh&& module use /usr/share/modulefiles&& module load mpi/openmpi-x86_64&& cd /mnt&& mpiexec --allow-run-as-root -np 2 nwchem_openmpi h2.nw > h2.out'
```

## Examine the created output file

```sh
cat myjob/h2.out
```


# Building

## Locally

Build based on the local [Dockerfile](Dockerfile)

```sh
docker build -t nwchem-openmpi .
```

List images

```sh
docker images
```


# Docker image tagging convention

The docker image is tagged with the NWCHEM upstream version appended by a build number,
for example the first docker image of NWCHEM version `6.8.1` is tagged with `6.8.1-1`.
Note that this docker image may correspond to e.g. Fedora's RPM `6.8.1-5.fc29.x86_64`.
See the `ENV` values in [Dockerfile](Dockerfile).


# Dependencies

docker and optionally docker-compose


# License of this Dockerfile

Apache-2.0

**Note** please consult the NWCHEM software https://github.com/nwchemgit/nwchem/blob/master/LICENSE.TXT


# Todo
