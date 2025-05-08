## Installation
Initiate the process by flashing [Arch Linux](https://archlinux.org/) onto a USB drive. Once done, boot from the USB, and step into the realm of Linux.

Alright, listen up. Have you booted your Arch yet? If the answer's yes, good. Now, if you're surfing the airwaves with WiFi, follow these steps to connect to the internet. If you're Chad and rocking the Ethernet, well, you're good to go. Easy as that.

```bash
  iwctl
  # inside iwctl interface
  device list
  station [device name] scan
  station [device name] get-networks
  station [device name] connect [wifiname]
  statio [device name] show
  quit
  # out of iwctl interface
```

Is your WiFi connected? If yes, then curl this install script and make it executable.

```bash
curl https://raw.githubusercontent.com/Gr1shma/archymagic/master/install.sh >> install.sh
chmod +x install.sh
./install.sh
```
