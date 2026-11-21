# SCP — Secure Copy Protocol
### Linux Command Reference

**Category:** Networking / File Transfer  
**Difficulty:** Beginner to Advanced  
**Command:** `scp`  
**Protocol:** SSH  
**Platform:** Linux, Unix-like systems, macOS

---

## 1. Overview

SCP (Secure Copy Protocol) is a command-line utility used to securely transfer files and directories between local and remote computers over a network.

SCP uses SSH (Secure Shell) to establish an encrypted connection between systems. This allows users to transfer files without exposing their contents in plain text while traveling across the network.

SCP is commonly used for:

- Transferring files between Linux computers.
- Uploading scripts and configuration files to remote servers.
- Downloading system logs from remote machines.
- Transferring backups between systems.
- Moving entire directories.
- Managing files on remote servers without physically accessing them.

### SCP vs SSH

Although SCP relies on SSH, the two commands serve different purposes.

| Command | Purpose |
|---|---|
| `ssh` | Remotely connect to and manage another computer. |
| `scp` | Securely transfer files and directories between computers. |

Think of SSH as establishing a secure connection to another computer, while SCP uses that connection to move files.

---

## 2. Basic Syntax

The general SCP command structure is:

```bash
scp [options] source destination
```

When transferring a file to a remote computer:

```bash
scp file.txt username@remote_ip:/path/to/destination/
```

### Breaking Down the Command

| Component | Description |
|---|---|
| `scp` | Executes the secure copy command. |
| `file.txt` | The file being transferred. |
| `username` | Account username on the remote computer. |
| `remote_ip` | IP address or hostname of the remote computer. |
| `:` | Separates the remote host from its file path. |
| `/path/to/destination/` | Destination directory on the remote computer. |

The remote connection follows this format:

```bash
username@hostname:/remote/path/
```

You can use either an IP address or a resolvable hostname.

---

## 3. Basic File Transfers

### 3.1 Sending a File to a Remote Computer

To copy a local file to a remote computer:

```bash
scp system-report.txt admin@192.0.2.100:/home/admin/
```

This transfers `system-report.txt` from the local computer into the `/home/admin/` directory on the remote computer.

### 3.2 Downloading a File from a Remote Computer

To retrieve a file from a remote computer:

```bash
scp admin@192.0.2.100:/home/admin/system.log .
```

The period (`.`) represents the current working directory.

The downloaded file will be placed in whichever directory the terminal is currently working in.

### 3.3 Copying an Entire Directory

SCP can transfer entire directories using the recursive option.

```bash
scp -r HomeLab admin@192.0.2.100:/home/admin/
```

The `-r` option tells SCP to copy directories recursively.

This includes the directory itself, its files, and its subdirectories.

### 3.4 Copying Files Between Two Remote Computers

SCP can also transfer files between two remote systems.

```bash
scp admin@192.0.2.100:/home/admin/file.txt user@192.0.2.101:/home/user/
```

This initiates a transfer between the two remote machines.

Depending on the SCP implementation and configuration, the local computer may relay the file rather than having the remote systems communicate directly.

---

## 4. Useful SCP Options

SCP supports several command-line options that provide additional control over file transfers.

| Option | Description |
|---|---|
| `-r` | Copies directories recursively. |
| `-P` | Specifies a custom SSH port. |
| `-p` | Preserves modification times, access times, and file permissions. |
| `-v` | Displays verbose connection and transfer information. |
| `-C` | Enables compression during transfer. |
| `-q` | Suppresses most progress and diagnostic messages. |
| `-l` | Limits transfer bandwidth in Kbit/s. |
| `-i` | Specifies an identity file (SSH private key). |
| `-o` | Passes an SSH configuration option. |

**Important:** Uppercase and lowercase options are not interchangeable. For example, `-P` and `-p` perform entirely different functions.

### Examples

Specify a custom SSH port:

```bash
scp -P 2222 file.txt admin@192.0.2.100:/home/admin/
```

Use a specific SSH private key:

```bash
scp -i ~/.ssh/id_ed25519 file.txt admin@192.0.2.100:/home/admin/
```

Enable verbose output:

```bash
scp -v file.txt admin@192.0.2.100:/home/admin/
```

Enable compression:

```bash
scp -C large-file.tar.gz admin@192.0.2.100:/home/admin/
```

Limit transfer bandwidth to 5000 Kbit/s:

```bash
scp -l 5000 large-file.tar.gz admin@192.0.2.100:/home/admin/
```

Preserve file timestamps and permissions:

```bash
scp -p file.txt admin@192.0.2.100:/home/admin/
```

---

## 5. Working with SSH Keys

SCP supports SSH key authentication, allowing users to transfer files without repeatedly entering their account passwords.

First, generate an SSH key pair if you don't already have one:

```bash
ssh-keygen -t ed25519
```

Next, install the public key on the remote machine:

```bash
ssh-copy-id admin@192.0.2.100
```

You can then use SCP normally:

```bash
scp file.txt admin@192.0.2.100:/home/admin/
```

If your key is stored in a non-default location, use the `-i` option to specify it.

**Security reminder:** Never share your private SSH key. Only the public key should be installed on remote systems.

---

## 6. Custom SSH Configuration

SCP can use settings from your SSH configuration file:

```text
~/.ssh/config
```

For example:

```sshconfig
Host homeserver
    HostName 192.0.2.100
    User admin
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
```

After configuring this entry, you can use the hostname alias instead of repeatedly entering the IP address, username, port, and key.

Example:

```bash
scp system-report.txt homeserver:/home/admin/
```

This is particularly useful when regularly transferring files between multiple servers.

---

## 7. Security Considerations

SCP uses SSH encryption to protect file transfers while they travel across the network.

However, using SCP does not automatically make an improperly configured remote system secure.

Recommended practices include:

- Use SSH key authentication where practical.
- Protect private SSH keys.
- Verify remote host fingerprints before trusting a new connection.
- Use strong authentication and appropriate account permissions.
- Avoid exposing SSH services directly to the internet unnecessarily.
- Keep OpenSSH updated.
- Avoid transferring sensitive files to untrusted systems.

SCP does not bypass filesystem permissions. The remote account must have permission to write to the destination directory or read the requested source file.

### Private vs Public IP Addresses

When connecting to systems on a local network, private addresses such as `192.168.x.x` are commonly used.

Public IP addresses identify internet-facing network connections and should not be unnecessarily exposed in public documentation or recordings.

For educational examples, documentation-reserved addresses are preferable:

- `192.0.2.0/24`
- `198.51.100.0/24`
- `203.0.113.0/24`

These ranges are reserved for documentation and examples.

---

## 8. SCP vs SFTP vs rsync

SCP is not the only tool available for remote file transfers.

Linux provides several utilities with overlapping but different capabilities.

| Tool | Primary Purpose |
|---|---|
| SCP | Straightforward secure file copying. |
| SFTP | Interactive or scripted secure file management and transfers. |
| rsync | Efficient file synchronization and incremental transfers. |

### When Should You Use Each?

**SCP:** Use it when you need to quickly copy a file or directory between machines.

**SFTP:** Use it when you need to browse remote directories, upload files, download files, and manage remote files interactively.

**rsync:** Use it when synchronizing directories, performing recurring backups, or transferring only changes between systems.

### A Note About Modern SCP

Modern OpenSSH versions use the SFTP protocol internally for SCP transfers by default.

The familiar `scp` command remains available, and its syntax remains largely unchanged.

The `-O` option can force the legacy SCP protocol when compatibility with older systems is required.

```bash
scp -O file.txt admin@192.0.2.100:/home/admin/
```

The legacy protocol should generally only be used when necessary.

---

## 9. Common Problems and Troubleshooting

### Connection Refused

**Example error:**

```text
ssh: connect to host 192.0.2.100 port 22: Connection refused
```

Possible causes:

- SSH server is not running.
- SSH is listening on a different port.
- A firewall is blocking the connection.

On a system using systemd, check the SSH service:

```bash
sudo systemctl status ssh
```

On some distributions, the service is named `sshd` instead:

```bash
sudo systemctl status sshd
```

### Permission Denied

**Example error:**

```text
Permission denied
```

Possible causes:

- Incorrect username or authentication credentials.
- SSH key authentication is not configured correctly.
- The remote account lacks permission to access the destination.

Check your SSH connection independently:

```bash
ssh admin@192.0.2.100
```

### No Such File or Directory

**Example error:**

```text
No such file or directory
```

Possible causes:

- Incorrect source file path.
- Incorrect destination path.
- Typographical errors in directory names.

Verify that the requested files and directories actually exist.

### Connection Timeout

Possible causes:

- Remote computer is offline.
- Incorrect IP address or hostname.
- Network connectivity problems.
- Firewall restrictions.

Test basic network connectivity and verify the SSH port.

---

## 10. Practical Examples for System Administrators

SCP is particularly useful when managing multiple Linux systems.

### Retrieve a System Log

```bash
scp admin@192.0.2.100:/var/log/syslog ~/HomeLab/logs/system/
```

Copies a remote system log into a local logging directory.

Note that reading the remote log requires sufficient permissions.

### Upload a Bash Script

```bash
scp backup.sh admin@192.0.2.100:/home/admin/scripts/
```

Transfers a local script to a remote server.

### Transfer a Backup Archive

```bash
scp backup.tar.gz admin@192.0.2.100:/home/admin/backups/
```

Copies a compressed backup archive to a remote backup directory.

### Retrieve an Entire Log Directory

```bash
scp -r admin@192.0.2.100:/home/admin/logs/ ~/HomeLab/logs/
```

Downloads a remote directory and its contents.

---

## 11. Quick Reference

| Task | Command |
|---|---|
| Send a file | `scp file.txt user@host:/path/` |
| Retrieve a file | `scp user@host:/path/file.txt .` |
| Copy a directory | `scp -r folder user@host:/path/` |
| Use a custom port | `scp -P 2222 file.txt user@host:/path/` |
| Specify SSH key | `scp -i ~/.ssh/id_ed25519 file.txt user@host:/path/` |
| Preserve timestamps and permissions | `scp -p file.txt user@host:/path/` |
| Enable compression | `scp -C file.txt user@host:/path/` |
| Display verbose output | `scp -v file.txt user@host:/path/` |
| Limit bandwidth | `scp -l 5000 file.txt user@host:/path/` |

---

## 12. Conclusion

SCP is a straightforward and useful Linux utility for securely transferring files between computers.

Whether you're moving a configuration file, retrieving system logs, uploading scripts, or transferring backups, SCP provides a convenient way to move data through an SSH connection.

It is particularly useful for system administrators, developers, and homelab enthusiasts who regularly work with remote Linux systems.

For simple transfers, SCP gets the job done. For more advanced synchronization and backup workflows, rsync is often the better choice.

**Related Commands:** `ssh`, `ssh-keygen`, `ssh-copy-id`, `sftp`, `rsync`, `tar`

---

**RedWolf Studios — Linux Command Reference**

*Part of the Linux Basics educational series.*
