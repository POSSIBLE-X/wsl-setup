# POSSIBLE Dev Environment WSL Setup

This repository contains scripts that allows for creating a development environment in order to develop for the POSSIBLE project.

## WSL
To run POSSIBLE locally for development you need a Windows machine (tested on Windows 10 Pro 22H2) and install "Windows Subsystem for Linux" from the Microsoft Store.

If you already have a WSL set up, please verify it is the correct version by running

    wsl --version

in a Powershell or Command Line. If this does not print a `WSL-Version: 2.x.x.x` or the command or --version flag is not available, you might have installed an incompatible version of WSL. Please install the aforementioned version from the Store instead.

## Windows Terminal (optional)
For easier access to the WSL instance it is recommended to install "Windows Terminal" from the store. This allows to specifically select the POSSIBLE WSL as a terminal once it is installed.

## Setup

To set up the POSSIBLE WSL on your Windows system you can simply run

    .\possible-wsl-setup.bat

in a Powershell.
