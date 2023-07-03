@rem @file WslUsbDevicesMngr.cmd
@rem
@rem @note Copyright (c) 2023 rfmino

@echo off
powershell -command "Start-Process powershell -Verb RunAs -ArgumentList \"-ExecutionPolicy Bypass -File  %~dp0\WslUsbDevicesMngr.ps1 %*\""
