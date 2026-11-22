# Linux – Configure Pi-hole as the DNS Server

**Category:** Networking / DNS Administration  
**Platform:** Linux  
**Network Manager:** NetworkManager  
**Service:** Pi-hole  
**Purpose:** Configure a Linux machine to use Pi-hole as its primary DNS resolver instead of accepting DNS servers automatically supplied by the router.

---

# 1. Overview

Pi-hole provides network-wide DNS filtering by acting as a DNS resolver for connected devices.

For Pi-hole to filter DNS requests, individual machines must send their DNS queries through the Pi-hole server.

This guide explains how to:

- Identify the Pi-hole server's IP address.
- Check connectivity to Pi-hole.
- Test Pi-hole's DNS service.
- Identify the active NetworkManager connection.
- Configure IPv4 DNS.
- Prevent automatic router-provided DNS from overriding the configuration.
- Prevent automatic IPv6 DNS from bypassing Pi-hole.
- Verify the configuration.
- Confirm DNS requests appear in Pi-hole's Query Log.

**Important:** This guide does not require changing router settings or modifying Pi-hole itself.

# 2. Requirements

Before starting, confirm the following:

- A Linux machine using NetworkManager.
- Access to a functioning Pi-hole server.
- The Pi-hole server's local network IP address.
- Terminal access with sudo privileges.
- Both machines connected to the same accessible network.

For this guide, `xxx.x.x.xxx` represents the Pi-hole server's IP address.

Replace all placeholders with the actual values from your own network before executing commands.

It is recommended that Pi-hole have a static IP address or a DHCP reservation so its address does not unexpectedly change.


**NOTE**
[resolvectl status & resolvectl query example.com are not available on every linux Distro. If you don't have them, NetworksManager's DNS info and dig can be used instead.]

# 3. Identify the Pi-hole IP

The Pi-hole IP is normally the address used to access its administration dashboard.

Example:

```text
http://xxx.x.x.xxx/admin
```

Record this address. It will be needed throughout the configuration.

# 4. Check Network Connectivity

Before changing DNS settings, verify that the Linux machine can communicate with Pi-hole.

Run:

```bash
ping -c 3 xxx.x.x.xxx
```

Expected result:

- Three packets transmitted.
- Three packets received.
- Zero packet loss.

If the machine cannot reach Pi-hole, investigate network connectivity before continuing.

# 5. Test Pi-hole DNS

Next, confirm that Pi-hole is answering DNS requests.

First, check whether `dig` is installed:

```bash
dig -v
```

If unavailable, install the appropriate DNS utilities for your distribution.

**Fedora:**

```bash
sudo dnf install bind-utils
```

**Debian / Ubuntu:**

```bash
sudo apt install dnsutils
```

Test Pi-hole directly:

```bash
dig @xxx.x.x.xxx example.com
```

Look for:

```text
status: NOERROR
```

And:

```text
SERVER: xxx.x.x.xxx#53
```

This confirms that Pi-hole is responding to DNS requests.

If the query fails, stop here and investigate Pi-hole connectivity or DNS service availability.

# 6. Identify the Active Network Connection

NetworkManager controls network connections through named connection profiles.

Identify the active connections:

```bash
nmcli connection show --active
```

Example output:

```text
NAME                  TYPE      DEVICE
<CONNECTION_NAME>     wifi      <INTERFACE>
```

Identify the connection associated with the network interface that provides your normal internet connection.

Record:

- Connection profile name.
- Network interface name.
- Connection type.

**Important:** Do not modify Docker bridges, VPN connections, or unrelated interfaces when configuring normal Wi-Fi or Ethernet DNS.

# 7. Configure IPv4 DNS

We will now tell NetworkManager to use Pi-hole as the DNS server.

Replace `<CONNECTION_NAME>` with the active connection profile identified in the previous step.

Run:

```bash
sudo nmcli connection modify "<CONNECTION_NAME>" ipv4.dns "xxx.x.x.xxx"
```

This assigns Pi-hole as the IPv4 DNS server.

## Prevent Automatic DNS Overrides

Routers commonly advertise their own DNS servers through DHCP.

We want to prevent NetworkManager from accepting those automatic DNS settings.

Run:

```bash
sudo nmcli connection modify "<CONNECTION_NAME>" ipv4.ignore-auto-dns yes
```

This tells NetworkManager to ignore automatically supplied IPv4 DNS servers for this connection.

# 8. Configure IPv6 DNS Behaviour

IPv6 can introduce another DNS route.

Routers may advertise IPv6 DNS servers independently of IPv4 settings.

If Pi-hole has a working IPv6 address, you can configure that address as an additional DNS server.

If Pi-hole IPv6 DNS is not configured or available, you can prevent the router from supplying automatic IPv6 DNS.

Run:

```bash
sudo nmcli connection modify "<CONNECTION_NAME>" ipv6.ignore-auto-dns yes
```

**Important:**

This does not disable IPv6 networking.

It only prevents automatically advertised IPv6 DNS servers from being accepted on this connection.

Other network interfaces, including VPN connections, may retain their own DNS configuration.

# 9. Apply the Changes

NetworkManager needs to reactivate the connection to apply the new configuration.

Run:

```bash
sudo nmcli connection down "<CONNECTION_NAME>"
```

Then:

```bash
sudo nmcli connection up "<CONNECTION_NAME>"
```

The network connection will briefly disconnect and reconnect.

Do not perform this step over a remote session that depends on the connection unless you have another way to reconnect.

# 10. Verify NetworkManager Configuration

First, verify that the correct IPv4 DNS server is assigned.

[Remove the < > placeholder brackets from your command before using.]
Run:
```bash
nmcli device show <NETWORK_INTERFACE> | grep IP4.DNS
```

Expected result:

```text
IP4.DNS[1]: xxx.x.x.xxx
```

Next, inspect the complete DNS configuration:

```bash
resolvectl status
```

Under the appropriate network interface, look for:

```text
Current DNS Server: xxx.x.x.xxx
DNS Servers: xxx.x.x.xxx
```

If automatic IPv6 DNS was disabled, the router-provided IPv6 DNS address should no longer appear under that interface.

Other interfaces may still have their own DNS servers.

# 11. Test DNS Resolution

Test Pi-hole directly:

```bash
dig @xxx.x.x.xxx example.com
```

Then test the machine's normal DNS resolver:

```bash
dig example.com
```

You may see:

```text
SERVER: 127.0.0.53#53
```

This is normal on systems using systemd-resolved.

`127.0.0.53` is the local DNS stub resolver. It receives requests from applications and forwards them to the configured upstream DNS server.

It does not mean Pi-hole is being bypassed.

To inspect the DNS resolution path, run:

```bash
resolvectl query example.com
```

Check that the Wi-Fi or Ethernet interface is configured to use the Pi-hole address in `resolvectl status`.

# 12. Verify Through Pi-hole

The final verification takes place in the Pi-hole administration dashboard.

Open:

```text
http://xxx.x.x.xxx/admin
```

Navigate to:

**Query Log**

Generate some DNS activity from the Linux machine by visiting a website or running:

```bash
resolvectl query example.com
```

Look for requests associated with the Linux machine's client IP address.

You should see DNS requests such as:

- A records (IPv4 addresses).
- AAAA records (IPv6 addresses).
- Domain lookups generated by applications and system services.

If the requests appear under the expected client, Pi-hole is receiving DNS traffic from the machine.

# 13. Troubleshooting

### Pi-hole cannot be reached

Check:

```bash
ping -c 3 xxx.x.x.xxx
```

Possible causes:

- Incorrect Pi-hole IP.
- Network connectivity issue.
- Firewall restrictions.
- Pi-hole machine is offline.

### DNS query fails

Test:

```bash
dig @xxx.x.x.xxx example.com
```

Check that Pi-hole is running and accepting DNS requests on port 53.

### DNS still shows the router

Check:

```bash
nmcli connection show "<CONNECTION_NAME>" | grep -E 'ipv4.dns|ipv4.ignore-auto-dns|ipv6.dns|ipv6.ignore-auto-dns'
```

Confirm:

```text
ipv4.ignore-auto-dns: yes
ipv6.ignore-auto-dns: yes
```

Check the active DNS configuration:

```bash
resolvectl status
```

### DNS works but Pi-hole shows no requests

Check that:

- The correct Pi-hole address was configured.
- The correct network connection was modified.
- The query was generated after the configuration change.
- The Pi-hole Query Log is showing the expected