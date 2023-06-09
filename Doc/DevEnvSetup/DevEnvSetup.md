# Development Environment for rfmino - Setup

## Introduction
This project uses Visual Studio Code as a main IDE.
All development is done in a Docker container. This allows for a consistent development environment and minimizes the risk of errors due to different development environments.
VS Code takes care of setting up the Docker container and starting it. The container is based on the [nordicplayground/nrfconnect-sdk:main](https://hub.docker.com/r/nordicplayground/nrfconnect-sdk/) image.

## Prerequisites
- [Visual Studio Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker-desktop)

## Debuggers
- J-Link, e.g. built-in in [nRF52840-DK](https://www.nordicsemi.com/Software-and-tools/Development-Kits/nRF52840-DK)

## Hardware
- [nRF52840-DK](https://www.nordicsemi.com/Software-and-tools/Development-Kits/nRF52840-DK)
- rfmino Boards

## Verify Environment Setup
Connect a nRF52840-DK board to the host machine, open a terminal in VS Code connected to the development container and run the following commands:
```bash
cd /workdir/zephyr && \
west build -p always -b nrf52840dk_nrf52840 samples/basic/blinky && \
west flash
```
It should build and flash the blinky sample to the board.

## How to
### Windows
[Attach USB devices to WSL](https://learn.microsoft.com/en-us/windows/wsl/connect-usb)
[GitHub credentials setup](https://cli.github.com/manual/gh_auth_login)

#### Attach USB device
To attach a USB device connected to the Windows host use script `Setup.cmd` that allows attaching USB devices to the WSL which then binds them to the dev container.

### Line endings
Make sure to configure GIT to auto replace CRLF when committing `git config --global core.autocrlf true`.

### Ubuntu
[Install docker on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
