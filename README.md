# autofs-config

autofs-config is a script that automates the configuration of AutoFS using YAML files.

At the moment, autofs-config can only configure connectivity for network resources using the smb protocol.

Superuser rights are required to run.

```
# afs-cf
OR
sudo afs-cf
```

## Tools and libraries

* Perl
* YAML
* AutoFS
* cifs-utils

## YAML file structure

```yaml
---
mount:
  autofs_mount_config: /etc/autofs/documents
  autofs_mount_directory: /samba
  autofs_mount_master_config: /etc/auto.master
  autofs_mount_options:
    - timeout=360
    - browse
  credentials_file: /etc/autofs/secret_file
  fstype: cifs
  name: share
  network_paths:
    - folder: /documents
      ip: 192.168.122.204
      share: '"share"'
  options:
    - soft
    - intr
    - noperm
```

**autofs_mount_config** is used to determine where the settings file for the network folder is located.

**autofs_mount_directory** is used to specify which directory the network folder will be mounted in.

**autofs_mount_master_config** is used to indicate where auto.master is located.

**autofs_mount_options** is used to specify the options to be added to auto.master.

**credentials_file points** to the file where the credentials are stored.

**fstype** indicates which protocol will be used.

**name** specifies the name of the directory when the network folder is attached to the file system.

**network_paths** describes the following parameters: the name of the network folder to be created, after **autofs_mount_directory** and **name**, the ip address and the name of the network folder that will connect.

**options** describes the options to be used in **autofs_mount_config**.
