# Discover the sha by removing the @sha part and running: timeout 5 docker buildx build --pull --no-cache .
# Dockerhub does not show the overall sha https://github.com/docker/roadmap/issues/262
FROM fedora:39@sha256:ee16ca86648f857c68270514442953c808c61c416152b9a316e551b02bedf8ec

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETPLATFORM
ARG TARGETARCH

RUN echo platform $TARGETPLATFORM
RUN echo arch $TARGETARCH
RUN echo uname -m $(uname -m)

LABEL name="NWCHEM Openmpi" \
      url="http://www.nwchem-sw.org/"

ENV NWCHEM_VERSION 7.2.2
ENV FEDORA_RELEASE 1.fc39

RUN set -x \
    && dnf install -y \
       nwchem-openmpi-${NWCHEM_VERSION}-${FEDORA_RELEASE} \
       nwchem-${NWCHEM_VERSION}-${FEDORA_RELEASE} \
    && dnf clean all

CMD ["/bin/bash"]
