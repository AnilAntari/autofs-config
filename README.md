# autofs-config

autofs-config is a script that automates the process of configuring AutoFS using YAML format files. It is able to configure network folders running on SMB and NFS protocols.

Superuser rights are required to run.

```
# afs-cf
OR
sudo afs-cf
```

Usage examples:

```
sudo afs-cf
OR
sudo afs-cf -a -p --file /path_to_yaml_file
# The -a and -p options are responsible for configuring the file for mounting network 
# resources and the file with credentials for connection.
```

## Tools and libraries

* Perl
* YAML
* AutoFS
* cifs-utils
* nfs-common

## YAML file structure

### Samba

```yaml
---
mount:
  autofs_mount_config: /etc/autofs/documents
  autofs_mount_directory: /samba
  autofs_mount_master_config: /etc/auto.master
  autofs_mount_options:
    - timeout=360
    - browse
  autofs_mount_passwd: password
  autofs_mount_username: username
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

* **autofs_mount_config** is used to determine where the settings file for the network folder is located.

* **autofs_mount_directory** is used to specify which directory the network folder will be mounted in.

* **autofs_mount_master_config** is used to indicate where auto.master is located.

* **autofs_mount_options** is used to specify the options to be added to auto.master.

* **autofs_mount_passwd** and **autofs_mount_username** are optional parameters that store the password and username to automatically create a credential file.

* **credentials_file points** to the file where the credentials are stored.

* **fstype** indicates which protocol will be used.

* **name** specifies the name of the directory when the network folder is attached to the file system.

* **network_paths** describes the following parameters: the name of the network folder to be created, after **autofs_mount_directory** and **name**, the ip address and the name of the network folder that will connect.

* **options** describes the options to be used in **autofs_mount_config**.

### NFS

```yaml
---
mount:
  autofs_mount_config: /etc/autofs/documents
  autofs_mount_directory: /mnt
  autofs_mount_master_config: /etc/auto.master
  autofs_mount_options:
    - timeout=60
    - browse
  fstype: nfs
  name: share
  network_paths:
    - ip: 192.168.122.204
      share: /srv/nfsshare
  options:
    - rw
    - soft
```

* **autofs_mount_config** is used to determine where the settings file for the network folder is located.

* **autofs_mount_directory** is used to specify which directory the network folder will be mounted in.

* **autofs_mount_master_config** is used to indicate where auto.master is located.

* **autofs_mount_options** is used to specify the options to be added to auto.master.

* **fstype** indicates which protocol will be used.

* **name** specifies the name of the directory when the network folder is attached to the file system.

* **network_paths** describes the following parameters: the name of the network folder to be created, after **autofs_mount_directory** and **name**, the ip address and the name of the network folder that will connect.

* **options** describes the options to be used in **autofs_mount_config**.
