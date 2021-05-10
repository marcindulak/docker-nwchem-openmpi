FROM fedora:34@sha256:e6c6b6e158333b8d1b03095b1c70795f1ed19a7b0353e6986e9e255bbe6412da

LABEL name="NWCHEM Openmpi" \
      url="http://www.nwchem-sw.org/"

ENV NWCHEM_VERSION 7.0.2
ENV FEDORA_RELEASE 6.fc34
ENV FEDORA_ARCH x86_64

RUN set -x \
    && dnf install -y \
       nwchem-openmpi-${NWCHEM_VERSION}-${FEDORA_RELEASE}.${FEDORA_ARCH} \
       nwchem-${NWCHEM_VERSION}-${FEDORA_RELEASE}.${FEDORA_ARCH} \
    && dnf clean all

CMD ["/bin/bash"]
