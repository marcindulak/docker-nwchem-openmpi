![main](https://github.com/marcindulak/docker-nwchem-openmpi/workflows/main/badge.svg)

# Description

Dockerfile for NWCHEM http://www.nwchem-sw.org/ built against openmpi, based on Fedora.

The docker images are available at [dockerhub](https://hub.docker.com/r/marcindulak/nwchem-openmpi)


# Usage

First, make sure you are able to run the `docker run hello-world` example https://docs.docker.com/get-started/.
**Note** on MS Windows install https://hub.docker.com/editions/community/docker-ce-desktop-windows.

Then test the basic NWCHEM functionality

```sh
docker run --rm -it marcindulak/nwchem-openmpi:latest bash -c '. /etc/profile.d/modules.sh&& module use /usr/share/modulefiles&& module load mpi/openmpi&& echo -e "geometry\nH 0 0 0\nH 0 0 1\nend\nbasis\nH library STO-3G\nend\ntask dft energy" > /tmp/h2.nw && mpiexec --allow-run-as-root -np 1 nwchem_openmpi /tmp/h2.nw'
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
docker compose -f docker-compose.myjob.yml up --exit-code-from nwchem
```

Remove the terminated container

```sh
docker compose -f docker-compose.myjob.yml down
```

## Run a job manually

```sh
docker run --name myjob --rm -it -v "$(pwd)/myjob:/mnt" marcindulak/nwchem-openmpi:latest bash -c '. /etc/profile.d/modules.sh&& module use /usr/share/modulefiles&& module load mpi/openmpi&& cd /mnt&& mpiexec --allow-run-as-root -np 2 nwchem_openmpi h2.nw > h2.out'
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


# Releasing

# Docker image tagging convention

The docker image is tagged with the NWCHEM upstream version appended by a build number,
for example the first docker image of NWCHEM version `6.8.1` is tagged with `6.8.1-1`.
Note that this docker image may correspond to e.g. Fedora's RPM `6.8.1-5.fc29`.
See the `ENV` values in [Dockerfile](Dockerfile).

Build and test the image, see [buildx](https://docs.docker.com/engine/reference/commandline/buildx/).

Create a builder instance

```sh
docker buildx create --name node-docker-nwchem-openmpi --platform linux/amd64,linux/arm64
docker buildx use node-docker-nwchem-openmpi
```

Build the image for supported targets

```sh
BUILDKIT_PROGRESS=plain docker buildx bake -f docker-compose.test.yml --set '*.platform=linux/amd64,linux/arm64' --no-cache
# or
# BUILDKIT_PROGRESS=plain docker buildx build --platform linux/amd64,linux/arm64 --no-cache .
```

Load the machine target image for testing. Only one platform can be loaded,
see https://github.com/docker/buildx/issues/59 and https://stackoverflow.com/questions/71765232/what-is-default-platform-type-in-docker-image
```sh
docker buildx build --platform $(docker system info --format '{{.OSType}}/{{.Architecture}}') -t docker-nwchem-openmpi-sut:latest --load .
```

Test the image

```sh
docker compose -f docker-compose.test.yml up --exit-code-from sut
```

Tag and push the images (need to build again, using `--push` option https://github.com/docker/buildx/issues/1152)
```sh
BUILDKIT_PROGRESS=plain docker buildx build --platform linux/amd64,linux/arm64 -t marcindulak/nwchem-openmpi:6.8.1-1 --push .
BUILDKIT_PROGRESS=plain docker buildx build --platform linux/amd64,linux/arm64 -t marcindulak/nwchem-openmpi:latest --push .
```

Remove the builder instance

```sh
docker buildx stop node-docker-nwchem-openmpi
docker buildx rm node-docker-nwchem-openmpi
```


# Dependencies

docker and optionally docker-compose


# License of this Dockerfile

Apache-2.0

**Note** please consult the NWCHEM software https://github.com/nwchemgit/nwchem/blob/master/LICENSE.TXT


# Todo
