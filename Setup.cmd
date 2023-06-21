@rem @file Setup.cmd
@rem
@rem @note Copyright (c) 2023 rfmino

@echo off

git config core.autocrlf true

call %~dp0\Env\Windows\WslUsbDevicesMngr.cmd
