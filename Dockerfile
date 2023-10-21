# Discover the sha by removing the @sha part and running: timeout 5 docker buildx build --pull --no-cache .
# Dockerhub does not show the overall sha https://github.com/docker/roadmap/issues/262
FROM fedora:39@sha256:95c88cea36312cfd73613f1c56d8a8db8e63be5cd884cfc97ba9475d0a45eac5

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
ARG TARGETARCH

RUN echo platform $TARGETPLATFORM
RUN echo arch $TARGETARCH
RUN echo uname -m $(uname -m)

LABEL name="NWCHEM Openmpi" \
      url="http://www.nwchem-sw.org/"

ENV NWCHEM_VERSION 7.2.0
ENV FEDORA_RELEASE 4.fc39

RUN set -x \
    && dnf install -y \
       nwchem-openmpi-${NWCHEM_VERSION}-${FEDORA_RELEASE} \
       nwchem-${NWCHEM_VERSION}-${FEDORA_RELEASE} \
    && dnf clean all

CMD ["/bin/bash"]
