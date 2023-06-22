# Setup WireShark for capturing Thread traffic

## Hardware
### nRF52840-Dongle
Note: Build in dev-container, attach debugger (on Windows use `Setup.cmd`)!
- Enter co-processor sample in nRF repo
```bash
cd /workdir/nrf/samples/openthread/coprocessor
```
- Build it for nRF52840-Dongle with USB transport
```bash
west build -p always -b nrf52840dongle_nrf52840 -T ./sample.openthread.coprocessor.usb
```
- Flash board
```bash
west flash
```

## Software
### Windows
- Install WireShark
- Configure WireShark
See: https://openthread.io/guides/pyspinel/wireshark#configure-wireshark-protocols

- Install Pyspinel dependencies
```bash
py -3 -m pip install pyserial ipaddress
```

- Install Pyspinel
```bash
py -3 -m pip install pyspinel --install-option="--extcap-path=extcap-path"
```

See: https://openthread.io/guides/pyspinel/install-pyspinel#install_pyspinel_and_dependencies_with_extcap

## Use
See: https://openthread.io/guides/pyspinel/sniffer-extcap
