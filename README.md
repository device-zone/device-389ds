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


# device-389ds-tls
Extends a 389ds directory server appliance with TLS support

This appliance extension does the following:

- Automatically identifies the correct server certificate, certificate chain, root
  certificate and key to use, and configures the 389ds instance NSS certificate database
  to include these certificates and keys.
- Automatically configures certmap.conf to allow optional binding using client
  certificates, where the certificate is verified and stored in the userCertificate
  attribute, and the subject of the certificate is stored in nsCertSubjectDN.
- Binds to port 636 using the given certificate.
- If firewalld is installed, automatically opens the relevant port for the duration of
  the running of the server.

## before

- Deploy the device-389ds package.

```
[root@server ~]# dnf install device-389ds-tls
```

- Place certificates in files beneath the directory /etc/pki/tls/certs with extension
  pem. Place keys in files beneath the directory /etc/pki/tls/private. All certificates
  and keys will be scanned, filenames are not important.

```
[root@server ~]# ls -l /etc/pki/tls/certs /etc/pki/tls/private
/etc/pki/tls/certs:
total 48
drwxr-xr-x. 2 root root 4096 Oct  2 21:35 .
drwxr-xr-x. 5 root root  104 Sep 23 21:03 ..
lrwxrwxrwx. 1 root root   49 Jul 28 21:08 ca-bundle.crt -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
lrwxrwxrwx. 1 root root   55 Jul 28 21:08 ca-bundle.trust.crt -> /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt
-rw-r--r--. 1 root root 2278 Aug 20 12:50 seawitch.example.com-sectigo-2023-hostCert.pem
-rw-r--r--. 1 root root 4136 Aug 20 12:51 seawitch.example.com-sectigo-2023-hostChain.pem

/etc/pki/tls/private:
total 12
-rw-------. 1 root root 1705 Aug 20 12:44 seawitch.example.com-sectigo-2023-hostKey.pem
```

## add tls to instance

To expose the instance called "seawitch" with the hostname "seawitch.example.com", run
this. The certificate, chain and key will be found and configured automatically.

```
[root@server ~]# device services ldap-server tls add instance=seawitch hostname=seawitch.example.com
```

## remove suffix from instance

To remove the entry above with index zero, run this.

```
[root@server ~]# device services ldap-server tls remove 0
```


