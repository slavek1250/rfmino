# @file Dockerfile
#
# @note Copyright (c) 2023 rfmino

FROM nordicplayground/nrfconnect-sdk:main

WORKDIR /root/config

COPY Env/Bash/* .

# Install additional packages
RUN apt-get update \
    && apt-get -y install uncrustify \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && echo 'source /root/config/bash-setup.sh' >> /root/.bashrc

# Launch bash shell by default
CMD ["/bin/bash"]
