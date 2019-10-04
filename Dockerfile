FROM fedora:29

LABEL name="NWCHEM Openmpi" \
      url="http://www.nwchem-sw.org/"

ENV NWCHEM_VERSION 6.8.1
ENV FEDORA_RELEASE 5.fc29
ENV FEDORA_ARCH x86_64

RUN set -x \
    && dnf install -y nwchem-openmpi-${NWCHEM_VERSION}-${FEDORA_RELEASE}.${FEDORA_ARCH} \
    && dnf clean all

CMD ["/bin/bash"]
