# device-389ds
Provides a 389ds directory server appliance

This appliance does the following:

- Automatically creates instances as required.
- Automatically creates suffixes beneath each instance as required.
- Binds each instance securely to the unix domain socket /run/slapd-${instance}.socket.
- Autostarts on server restart.

## before

- Deploy the device-389ds package.

```
[root@server ~]# dnf install device-389ds
```

## add instance

To add an instance called "seawitch", run this.

```
[root@server ~]# device services ldap-server instance add name=seawitch
```

## remove instance

To remove an instance called "seawitch", run this.

```
[root@server ~]# device services ldap-server instance remove seawitch 
```

## add suffix to instance

To add a suffix called "dc=example,dc=com" with a userroot of "example" to an instance called "seawitch", run this. The name "seawitch-example" is used so we can refer to this suffix elsewhere.

```
[root@server ~]# device services ldap-server suffix add name=seawitch-example instance=seawitch userroot=example suffix="dc=example,dc=com"
```

## remove suffix from instance

To remove a suffix we named "seawitch-example" above from an instance called "seawitch", run this.

```
[root@server ~]# device services ldap-server suffix remove seawitch-example
```


