---
layout: post
title: "Raspberry Pi Home Router + VPN"
date: 2018-10-11 19:52
categories: [raspberry pi, vpn, networking]
---

I went with the [Rasberry Pi 3 model B+](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/).

[antenna](https://www.adafruit.com/product/1030)

and for fun some LED's for current status with the [8 LET Blinkt](https://shop.pimoroni.com/products/blinkt).


```bash
$ apt-get update
$ apt-get install hostapd openvpn dnsmasq
```

/etc/dnsmasq.conf should be:
```
no-resolv
server=209.222.18.222
server=209.222.18.218
interface=wlan1
cache-size=2000
dhcp-range=192.168.42.10,192.168.42.50,24h
```

contents of /etc/hostapd/hostapd.conf
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

in nano /etc/sysctl.conf un-comment or add to the bottom:
```
net.ipv4.ip_forward=1
```

```shell
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables-save > /etc/iptables.ipv4.nat
```

in /etc/rc.local add before the exit 0:

```
iptables-restore < /etc/iptables.ipv4.nat
```

## now for vpn
export pia.conf from private internet accesss
last lines:

```
auth-user-pass /etc/openvpn/login.txt
```

make /etc/openvpn/login.txt:
```
username
password
```

then

```shell
update-rc.d dnsmasq enable
service dnsmasq restart

update-rc.d hostapd enable
service hostapd restart

update-rc.d openvpn enable
service openvpn restart
```



testing:
http://dnsleak.com/
