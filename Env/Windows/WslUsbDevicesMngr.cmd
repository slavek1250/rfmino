@rem @file WslUsbDevicesMngr.cmd
@rem
@rem @note Copyright (c) 2023 rfmino

@echo off
powershell -ExecutionPolicy Bypass -File  %~dp0\WslUsbDevicesMngr.ps1 %*
