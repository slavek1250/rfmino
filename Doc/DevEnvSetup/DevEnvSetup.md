# Development Environment for rfmino - Setup

## Introduction
This project uses Visual Studio Code Insiders as a main IDE. It is also possible to use Visual Studio Code, but it is not recommended.
All development is done in a Docker container. This allows for a consistent development environment and minimizes the risk of errors due to different development environments.
VS Code takes care of setting up the Docker container and starting it. The container is based on the [nordicplayground/nrfconnect-sdk:main](https://hub.docker.com/r/nordicplayground/nrfconnect-sdk/) image.

## Prerequisites
- [Visual Studio Code Insiders](https://code.visualstudio.com/insiders/)
- [Git](https://git-scm.com/downloads)
- [Docker](https://www.docker.com/products/docker-desktop)

## Debuggers
- J-Link, e.g. built-in in [nRF52840-DK](https://www.nordicsemi.com/Software-and-tools/Development-Kits/nRF52840-DK)

## Hardware
- [nRF52840-DK](https://www.nordicsemi.com/Software-and-tools/Development-Kits/nRF52840-DK)
- rfmino Boards
