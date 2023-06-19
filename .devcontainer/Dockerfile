# Dockerfile of rfmino-dev-container

FROM nordicplayground/nrfconnect-sdk:main

# Install additional packages
RUN apt-get update \
    && apt-get -y install uncrustify \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Setup git-bash-like bash
RUN echo 'PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\[\033[1;36m\]\$(git rev-parse --is-inside-work-tree &> /dev/null && git rev-parse --abbrev-ref HEAD | xargs printf \" (%s)\")\[\033[00m\]\n\$ "' >> /root/.bashrc

# Launch bash shell by default
CMD ["/bin/bash"]
