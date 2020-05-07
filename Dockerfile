FROM fedora:32@sha256:573b324f1f9fbca0e3649acabbe65069d8e639fc8957e5ec39879e097b721d8f

LABEL name="NWCHEM Openmpi" \
      url="http://www.nwchem-sw.org/"

ENV NWCHEM_VERSION 7.0.0
ENV FEDORA_RELEASE 6.fc32
ENV FEDORA_ARCH x86_64

RUN set -x \
    && dnf install -y nwchem-openmpi-${NWCHEM_VERSION}-${FEDORA_RELEASE}.${FEDORA_ARCH} \
    && dnf clean all

CMD ["/bin/bash"]
