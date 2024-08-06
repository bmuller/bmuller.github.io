---
redirect_to: https://bmuller.wtf
layout: post
title: "Raspberry Pi Home Router + VPN"
date: 2018-10-11 19:52
categories: [raspberry pi, vpn, networking]
---

<div class="center"><img src="/images/2018/pi-vpn.jpg" class="postimg medium" /></div>

[Internet Service Proviers (ISPs)](https://www.eff.org/free-speech-weak-link/isp) are constantly trying to get away with some icky things, and rarely get caught or punished.  A prime example is [Verizon's tracking of mobile users with "perma-cookies"](https://www.eff.org/deeplinks/2014/11/verizon-x-uidh), which resulted in only a paltry [$1.35M fine](https://www.theverge.com/2016/3/7/11173010/verizon-supercookie-fine-1-3-million-fcc).  You can get around your ISP's prying eyes by using a Virtual Private Network (your computer connects directly to a third party, and all of your traffic is forwarded from there to the rest of the internet).  If you want more background on VPN's, the Electronic Frontier Foundation has a great guide (and list to VPN vendor comparisons) [here](https://ssd.eff.org/en/module/choosing-vpn-thats-right-you).

I've been wanting to build a [fail-safe](https://en.wikipedia.org/wiki/Fail-safe) wireless access point for a while, to provide a wireless network in my apartment that is only up if it's connected to a VPN.  Any device connected to the wireless network can know for sure that it is bypassing inspection from my ISP.  The only downside is that services that rely on your IP address to locate you will think you're in the same location as the VPN server (which seems like a small price for added privacy).

The hardware/software are so cheap/easy at this point, it's pretty easy to set up.  So here are some instructions for what I did!

## VPN Selection
I ended up using [Private Internet Access](https://www.privateinternetaccess.com/) (PIA), which admittedly sounds like a total scam site.  In terms of protocols/encryption levels supported and the number of server locations, I think they're a true winner.  The one caveat is that they do operate out of London, which is under [Five Eyes](https://en.wikipedia.org/wiki/Five_Eyes) jurisdiction.  They claim that they don't keep any logs at all, but it's probably safest to assume that they will protect you from the prying eyes of your ISP (but probably not the curiosity of the Five Eyes).

## Hardware
For the device, I went with the [Rasberry Pi 3 model B+](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/).  Paired with an external [antenna](https://www.adafruit.com/product/1030), my whole apartment is pretty decently covered.

For some visual insight into whether the device was "connected" to my VPN of choice or not, I added some LED's via the [8 LET Blinkt](https://shop.pimoroni.com/products/blinkt).  When the Access Point (AP) is connected to the VPN, there's a beautiful rainbow pattern that shifts to a random arrangement every minute.  When the connection is down, it's all red.

In terms of hardware setup, just plug the external antenna into one of the USB ports and the Blinkt strip into the top of the Pi (though make sure the curves on the top that match the corners of your Raspberry Pi).

## Software
If you install the base [Raspbian Lite](https://www.raspberrypi.org/downloads/raspbian/) distribution (no desktop necessary) then you should be good to go.  Just use the [installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) for getting the OS onto your micro-SD card, and connect your Pi's ethernet port to your modem or router.

Once you're booted up, the steps are simple:
1. Set up the wireless access point
2. Set up the VPN connection
3. Make sure all traffic is routed from the wireless network to the VPN
4. Turn on the pretty indicator lights

### Install Packages
Upgrade everything and install necessary packages.

```bash
$ sudo su -
$ apt-get update
$ apt-get upgrade
$ apt-get install hostapd openvpn dnsmasq python3-blinkt
```

### Wireless Access Point
Now we're going to edit some configuration files.  I found editing using the default installed [nano](https://www.nano-editor.org/dist/v3/nano.html) to be the easiest to edit these files.

Assuming your wireless antenna is showing up as `wlan1` (since onboard wifi would be `wlan0`) - edit your file () **/etc/dnsmasq.conf** to be:

```
no-resolv
server=209.222.18.222
server=209.222.18.218
interface=wlan1
cache-size=2000
dhcp-range=192.168.42.10,192.168.42.50,24h
```

This sets up your [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol) server and [DNS](https://en.wikipedia.org/wiki/Domain_Name_System) server (which forwards all requests to Private Internet Access' DNS servers at `209.222.18.222` and `209.222.18.218`).

Next, we can configure our access point.  Set the contents of **/etc/hostapd/hostapd.conf** to:

```
interface=wlan1
ssid=My-AP
hw_mode=g
channel=11
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
ieee80211n=1
```

Make sure to replace `ssid` with the name of the access point you'd like, and set `wpa_passphrase` to be the wireless password you'd like for your network.  Now we can start these services:

```shell
$ update-rc.d dnsmasq enable
$ service dnsmasq restart
$ update-rc.d hostapd enable
$ service hostapd restart
```


### VPN Setup
We'll be using the [OpenVPN](https://openvpn.net/) client to connect to the VPN.  PIA provides a handy [online tool](https://payments.privateinternetaccess.com/pages/ovpn-config-generator) for generating a config file, which you should definitely use.  Choose "OpenVPN 2.4 or newer", then "Linux", then choose a VPN location closest to you physically.  The recommended "UDP/1198" choice is fine (though, if you're really concerned about security, full RSA-4096 could also be selected, but your little Raspberry Pi may have trouble with the computational power necessary for the increased encryption).  Check the box "Use IP" (to avoid any DNS issues) and then click "Generate".  The resulting file should be copied to your Pi at **/etc/openvpn/pia.conf**.  Then, add the following line at the end:

```
auth-user-pass /etc/openvpn/login.txt
```

And create a file at **/etc/openvpn/login.txt** with your PIA username and password:

```
username
password
```

Then, we can start the OpenVPN connection:

```shell
$ update-rc.d openvpn enable
$ service openvpn restart
```

### Traffic Routing
Now we can make sure we're routing all traffic from the wireless network to our VPN connection.  Edit **/etc/sysctl.conf** and un-comment or add to the bottom:

```
net.ipv4.ip_forward=1
```

Now we can set up routing internally.  Run the following commands:

```shell
$ sysctl -p /etc/sysctl.conf
$ iptables -P FORWARD DROP
$ iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
$ iptables -A FORWARD -i tun0 -o wlan1 -m state --state RELATED,ESTABLISHED -j ACCEPT
$ iptables -A FORWARD -i wlan1 -o tun0 -j ACCEPT
$ iptables-save > /etc/iptables.ipv4.nat
```

Then, edit the file **/etc/rc.local** add before the line `exit 0` add this line (so that settings are applied after each restart):

```
iptables-restore < /etc/iptables.ipv4.nat
```

### Indicator Lights
As the regular `pi` user, create a file named `update` in your home directory:

```python
#!/usr/bin/env python3
import os
import colorsys
import time
from urllib.request import urlopen
from blinkt import set_pixel, set_brightness, show, clear, set_clear_on_exit, set_all

set_clear_on_exit(False)
set_brightness(0.04)

with open('/etc/openvpn/pia.conf', 'r') as f:
    line = [l for l in f.readlines() if l.startswith('remote')][0]
    vpnip = line.split()[1]

vpn = 'tun0' in os.listdir('/sys/class/net/')
try:
    with urlopen('http://ipinfo.io/ip') as r:
        ip = r.read().decode('utf-8').strip()
        vpn = vpn and ip == vpnip
except:
    vpn = False

clear()
if vpn:
    spacing = 360.0 / 16.0
    hue = int(time.time() * 100) % 360
    for x in range(8):
        offset = x * spacing
        h = ((hue + offset) % 360) / 360.0
        r, g, b = [int(c * 255) for c in colorsys.hsv_to_rgb(h, 1.0, 1.0)]
        set_pixel(x, r, g, b)
else:
    set_all(255, 0, 0, 1)
show()
```

This script will test your VPN connection and ensure that the internet visible IP you're connecting from is the PIA VPN IP.  You can set this script to run every minute by running:

```shell
$ crontab -e
````

And add this line after all of the comments:

```
* * * * * /home/pi/update
```

That's all!

## Testing
It's always good to test to make sure that you're not only connected to the internet, but that you're not [leaking](https://en.wikipedia.org/wiki/DNS_leak).  PIA provides a [test page to ensure you're connected](https://www.privateinternetaccess.com/pages/whats-my-ip/), which is a great first place to start.  You should also run a [leak test](http://dnsleak.com/) to ensure your DNS isn't leaking.
