# @file WslUsbDevicesMngr.ps1
#
# @note Copyright (c) 2023 rfmino

param(
    [switch]$attach = $false,
    [switch]$detach = $false,
    [switch]$verbose = $false,
    [switch]$json = $false,
    [switch]$noInteract = $false,
    [string]$hardwareId = $null # only for no interact
)

function ExecUsbIpdCmd()
{
    param($cmd)
    # Ignore errors/warnings
    $errorPrefBackup = $ErrorActionPreference
    $warnPrefBackup = $WarningPreference
    $ErrorActionPreference = 'SilentlyContinue'
    $WarningPreference = 'SilentlyContinue'

    if (-not $verbose)
    {
        $cmd += " 2> `$null"
    }

    # Capture the command output into a variable
    $commandOutput = Invoke-Expression $cmd

    # Restore errors/warnings preferences
    $ErrorActionPreference = $errorPrefBackup
    $ErrorActionPreference = $warnPrefBackup

    return $commandOutput
}

function GetUsbDevicesList()
{
    $commandOutput = ExecUsbIpdCmd "usbipd wsl list -u"

    # Define the regex pattern for each column
    $regexPattern = '^(\d+-\d) [ ]+([0-9a-f]{4}:[0-9a-f]{4}) [ ]+(.+) [ ]+(.+)$'

    $index = 0

    # Parse the table using regular expressions
    $tableRows = $commandOutput | Select-String -Pattern $regexPattern -AllMatches | ForEach-Object {
        $match = $_.Matches[0]
        [PSCustomObject]@{
            Index = $index++
            BusId = $match.Groups[1].Value.Trim()
            VidPid = $match.Groups[2].Value.Trim()
            Device = $match.Groups[3].Value.Trim()
            State = $match.Groups[4].Value.Trim()
        }
    }

    return $tableRows
}

function IsDeviceAttached()
{
    param($deviceStatus)
    return -not ($deviceStatus -match "Not Attached")
}

function AttachDetachUsbDevice()
{
    param($device)
    $deviceName = $device.Device
    $selectedDeviceHwId = $device.VidPid
    $deviceIndex = $device.Index
    $isDeviceAttached = IsDeviceAttached $device.State
    $isToggleCmd = -not ($attach -or $detach)

    if ($attach -and $detach)
    {
        Write-Host "Do not try to attach and detach at the same time ;)"
    }
    elseif ($attach -and $isDeviceAttached)
    {
        Write-Host "Device `"$deviceName`" already attached!"
    }
    elseif ($detach -and -not $isDeviceAttached)
    {
        Write-Host "Device `"$deviceName`" already detached!"
    }
    elseif (($attach -or $isToggleCmd) -and -not $isDeviceAttached)
    {
        ExecUsbIpdCmd "usbipd wsl attach --hardware-id $selectedDeviceHwId"
        $devicesAfterChange = GetUsbDevicesList
        if (IsDeviceAttached $devicesAfterChange[$deviceIndex].State)
        {
            Write-Host "Device `"$deviceName`" attached!"
        }
        else
        {
            Write-Error "Cannot attach device `"$deviceName`""
        }
    }
    elseif (($detach -or $isToggleCmd) -and $isDeviceAttached)
    {
        ExecUsbIpdCmd "usbipd wsl detach --hardware-id $selectedDeviceHwId"
        $devicesAfterChange = GetUsbDevicesList
        if (-not (IsDeviceAttached $devicesAfterChange[$deviceIndex].State))
        {
            Write-Host "Device `"$deviceName`" detached!"
        }
        else
        {
            Write-Error "Cannot detach device `"$deviceName`""
        }
    }
    else
    {
    }
}

function PrintDevicesList()
{
    param($devicesList)

    if ($json)
    {
        $devicesList | ConvertTo-Json
    }
    else
    {
        $devicesList | Format-Table -AutoSize
    }
}

function GetDeviceId()
{
    param($maxDevieId)

    # Prompt the user for an index value
    $userInput = Read-Host "Enter the index value (0 - $maxIndex) or q"

    # Validate the input
    while ($userInput -ne "q" -and ([int]$userInput -lt 0 -or [int]$userInput -gt [int]$maxIndex)) {

        Write-Host "Invalid index value. Please enter a value within the range of 0 to $maxIndex or q to exit."
        $userInput = Read-Host "Enter the index value (0 - $maxIndex) or q"
    }

    $deviceId = $null

    if ($userInput -ne "q")
    {
        $deviceId = $userInput
    }

    return $deviceId
}

function SayBye()
{
    Write-Host "Done. Bye!"
}

function NoInteractLogic()
{
    $devicesList = GetUsbDevicesList

    if (-not $hardwareId)
    {
        PrintDevicesList $devicesList

        if (-not $json)
        {
            SayBye
        }
    }
    else
    {
        $foundDevice = $devicesList | Where-Object { $_.VidPid -eq $hardwareId }

        if ($foundDevice)
        {
            AttachDetachUsbDevice $foundDevice
        }
        else
        {
            Write-Host "No USB device with Hardware Id: $hardwareId"
        }

        SayBye
    }

}

function InteractLogic()
{
    $devicesList = GetUsbDevicesList

    PrintDevicesList $devicesList

    if ($devicesList.length -eq 0)
    {
        Write-Host "No USB devices"
    }
    else
    {
        $maxIndex = $devicesList.length - 1
        $deviceIndex = GetDeviceId $maxIndex

        if ($deviceIndex)
        {
            $selectedDevice = $devicesList[$deviceIndex]
            AttachDetachUsbDevice $selectedDevice
        }
    }

    SayBye
}

function main()
{
    if ($noInteract)
    {
        NoInteractLogic
    }
    else
    {
        InteractLogic
    }
}

main
