# Discover the sha by removing the @sha part and running: timeout 5 docker buildx build --pull --no-cache .
# Alternatively find the sha in Dockerhub UI https://github.com/docker/roadmap/issues/262
FROM fedora:40@sha256:d0207dbb078ee261852590b9a8f1ab1f8320547be79a2f39af9f3d23db33735e

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
ARG TARGETARCH

RUN echo platform $TARGETPLATFORM
RUN echo arch $TARGETARCH
RUN echo uname -m $(uname -m)

LABEL name="NWCHEM Openmpi" \
      url="http://www.nwchem-sw.org/"

ENV NWCHEM_VERSION 7.2.3
ENV FEDORA_RELEASE 1.fc40

RUN set -x \
    && dnf install -y \
       nwchem-openmpi-${NWCHEM_VERSION}-${FEDORA_RELEASE} \
       nwchem-${NWCHEM_VERSION}-${FEDORA_RELEASE} \
    && dnf clean all

CMD ["/bin/bash"]
