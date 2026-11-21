# SSH – Secure Shell

**Command:** `ssh`  
**Category:** Networking / Remote Administration  
**Episode:** Linux Basics EP 32  
**Software:** OpenSSH  
**Default Port:** 22  
**Supported Systems:** Linux, macOS, Windows (with OpenSSH client)

---

## 1. Description

SSH (Secure Shell) is a network protocol that allows users to securely connect to and control another computer remotely.

SSH is commonly used for remote administration, server management, executing commands, transferring files, and managing headless systems.

SSH uses an encrypted connection to protect communications between the client and server.

A common implementation of SSH is OpenSSH.

### Common Uses

- Remotely access Linux computers.
- Administer servers.
- Execute commands on another machine.
- Transfer files between systems.
- Manage headless machines without a monitor or keyboard.
- Remotely maintain and troubleshoot systems.

## 2. How SSH Works

SSH uses a client-server model.

**SSH Client:** The computer you are connecting FROM.

**SSH Server:** The computer you are connecting TO.

The server runs an SSH service, commonly provided by OpenSSH, which listens for incoming connections.

SSH uses port `22` by default, although administrators can configure it to use another port.

## 3. Basic Command Syntax

```bash
ssh username@ip-address
```

### Example

```bash
ssh redwolf@192.168.1.100
```

### Command Breakdown

| Component | Description |
|---|---|
| `ssh` | Starts an SSH connection |
| `redwolf` | Username on the remote machine |
| `@` | Separates the username and address |
| `192.168.1.100` | IP address of the remote machine |

The username must exist on the remote machine, and the address must identify the machine you intend to reach.

## 4. First-Time Connection and Authentication

The first time you connect to an SSH server, SSH will usually ask you to verify the server's identity using its host key fingerprint.

This helps establish trust between the client and server.

**Important:** Verify the fingerprint through a trusted source before accepting it. Do not blindly accept an unfamiliar host key.

After the initial verification, SSH will authenticate you using an available method, commonly:

- Password authentication.
- SSH key authentication.

SSH keys are generally recommended for ongoing administration.

## 5. Installing SSH

If you want to connect TO a Linux machine, that machine needs an SSH server.

The computer connecting FROM needs an SSH client. Many Linux distributions already include the OpenSSH client.

### Debian / Ubuntu

Install the OpenSSH server:

```bash
sudo apt install openssh-server -y
```

The `-y` flag automatically answers yes to package installation prompts. It is optional.

Start SSH and enable it to launch automatically at boot:

```bash
sudo systemctl enable --now ssh
```

Check the service status:

```bash
sudo systemctl status ssh
```

### Fedora

Install OpenSSH Server:

```bash
sudo dnf install openssh-server -y
```

Start and enable the service:

```bash
sudo systemctl enable --now sshd
```

Check its status:

```bash
sudo systemctl status sshd
```

**Note:** On Fedora, the service is named `sshd`, while on Debian and Ubuntu it is commonly named `ssh`.

## 6. Additional SSH Commands

### Connect to a Different Port

If the SSH server uses a port other than 22:

```bash
ssh -p 2222 username@ip-address
```

The `-p` option specifies the port to connect to.

### Disconnect from SSH

Once connected, you can leave the remote session using:

```bash
exit
```

Alternatively, press `Ctrl+D`.

### Run a Remote Command Without Opening an Interactive Session

```bash
ssh username@ip-address hostname
```

This connects to the remote machine, executes `hostname`, and exits.

### Copy Files Using SCP

SSH also provides secure file transfer utilities.

Copy a local file to a remote machine:

```bash
scp file.txt username@ip-address:/home/username/
```

Copy a remote file to your local machine:

```bash
scp username@ip-address:/home/username/file.txt .
```

## 7. SSH and Remote Networking

SSH is not limited to computers on your home network.

With appropriate network access and security configuration, you can connect to remote machines over the internet.

One example is **Tailscale**, which creates a private network between your devices.

Tailscale provides the network connection, while SSH handles the remote terminal session.

This makes it possible to administer your home lab while traveling or away from your local network.

## 8. Important Security Considerations

- Use strong passwords or SSH key authentication.
- Verify host fingerprints before accepting new connections.
- Keep OpenSSH updated.
- Avoid exposing SSH directly to the public internet unnecessarily.
- Consider using a VPN such as Tailscale for remote access.
- Restrict SSH access to trusted users and devices.

## 9. Quick Reference

| Command | Purpose |
|---|---|
| `ssh user@host` | Connect to a remote machine |
| `ssh -p 2222 user@host` | Connect using a custom port |
| `exit` | Close the SSH session |
| `ssh user@host hostname` | Execute a remote command |
| `scp file user@host:/path/` | Copy a file to a remote machine |
| `sudo systemctl status ssh` | Check SSH service on Debian/Ubuntu |
| `sudo systemctl status sshd` | Check SSH service on Fedora |

---

## 10. Summary

SSH is one of the most useful tools available to Linux users and system administrators.

It provides a secure way to remotely access computers, administer servers, execute commands, and transfer files without physically interacting with the target machine.

Whether you're managing a home lab, maintaining a production server, or simply experimenting with Linux, SSH is a valuable tool to learn.

**Keep plugging away, and I'll see you in the terminal.**

---

**Reference:** OpenSSH  
**Documentation:** https://www.openssh.com/  
**Manual:** `man ssh`  
**Related Manuals:** `man sshd`, `man scp`, `man ssh-keygen`
