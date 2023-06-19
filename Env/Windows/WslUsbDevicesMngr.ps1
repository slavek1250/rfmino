
param(
    [switch]$attach = $false,
    [switch]$detach = $false
)

function ExecUsbIpdCmd()
{
    param($cmd)
    # Ignore errors
    $prefBackup = $ErrorActionPreference
    $ErrorActionPreference = 'SilentlyContinue'

    # Capture the command output into a variable
    $commandOutput = Invoke-Expression $cmd

    # Restore errors preferences
    $ErrorActionPreference = $prefBackup

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

$devicesList = GetUsbDevicesList

# Display table
$devicesList | Select-Object Index, DEVICE, STATE | Format-Table -AutoSize

# Determine the maximum index
$maxIndex = $index - 1

# Prompt the user for an index value
$userInput = Read-Host "Enter the index value (0 - $maxIndex) or q"

# Validate the input
while ($userInput -ne "q" -and ($userInput -lt 0 -or $userInput -gt $maxIndex)) {

    Write-Host "Invalid index value. Please enter a value within the range of 0 to $maxIndex or q to exit."
    $userInput = Read-Host "Enter the index value (0 - $maxIndex) or q"
}

if ($userInput -ne "q") {
    $selectedDevice = $devicesList[$userInput]
    $deviceName = $selectedDevice.Device
    $selectedDeviceHwId = $selectedDevice.VidPid
    $isDeviceAttached = IsDeviceAttached $selectedDevice.State
    $isToggleCmd = -not ($attach -or $detach)

    if ($attach -and $detach) {
        Write-Host "Do not try to attach and detach at the same time ;)"
    }
    elseif ($attach -and $isDeviceAttached) {
        Write-Host "Device `"$deviceName`" already attached!"
    }
    elseif ($detach -and -not $isDeviceAttached) {
        Write-Host "Device `"$deviceName`" already detached!"
    }
    elseif (($attach -or $isToggleCmd) -and -not $isDeviceAttached) {
        ExecUsbIpdCmd "usbipd wsl attach --hardware-id $selectedDeviceHwId"
        $devicesAfterChange = GetUsbDevicesList
        if (IsDeviceAttached $devicesAfterChange[$userInput].State) {
            Write-Host "Device `"$deviceName`" attached!"
        }
        else {
            Write-Error "Cannot attach device `"$deviceName`""
        }
    }
    elseif (($detach -or $isToggleCmd) -and $isDeviceAttached) {
        ExecUsbIpdCmd "usbipd wsl detach --hardware-id $selectedDeviceHwId"
        $devicesAfterChange = GetUsbDevicesList
        if (-not (IsDeviceAttached $devicesAfterChange[$userInput].State)) {
            Write-Host "Device `"$deviceName`" detached!"
        }
        else {
            Write-Error "Cannot detach device `"$deviceName`""
        }
    }
    else {
    }
}

Write-Host "Done. Bye!"
