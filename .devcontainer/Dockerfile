# Dockerfile of rfmino-dev-container

FROM nordicplayground/nrfconnect-sdk:main

# Install additional packages
RUN apt-get update \
    && apt-get -y install uncrustify \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Launch bash shell by default
CMD ["/bin/bash"]
