# device-389ds-server
Provides a convenient way to install all the packages below in one go.

```
[root@server ~]# dnf install device-389ds-server
```

# device-389ds
Provides a 389ds directory server appliance.

This appliance does the following:

- All parameters passed to the device commands are syntax checked and canonicalised, with bash completion.
- Automatically creates directory server instances as required.
- Automatically creates suffixes beneath each instance as required.
- Binds each instance securely to the unix domain socket /run/slapd-${instance}.socket.
- Allows the system's root user to adopt the identity of the Directory Manager.
- No access to directory via the network until device-389ds-tls is installed and configured as below.
- Autostarts on server restart.
- Zero Trust configuration.

## before

- Deploy the device-389ds package.

```
[root@server ~]# dnf install device-389ds
```

## add instance

To add an instance called "seawitch", run this.

```
[root@server ~]# device services ldap instance add name=seawitch
```

## remove instance

To remove an instance called "seawitch", run this.

```
[root@server ~]# device services ldap instance remove seawitch 
```

## add suffix to instance

To add a suffix called "dc=example,dc=com" with a userroot of "example" to an instance called "seawitch", run this. The name "seawitch-example" is used so we can refer to this suffix elsewhere.

```
[root@server ~]# device services ldap suffix add name=seawitch-example instance=seawitch userroot=example suffix="dc=example,dc=com"
```

## remove suffix from instance

To remove a suffix we named "seawitch-example" above from an instance called "seawitch", run this.

```
[root@server ~]# device services ldap suffix remove seawitch-example
```


# device-389ds-tls
Extends a 389ds directory server appliance with TLS support

This appliance extension does the following:

- All parameters passed to the device commands are syntax checked and canonicalised,
  with bash completion.
- Automatically identifies the correct server certificate, certificate chain, root
  certificate and key to use from certificates and keys placed under /etc/pki/tls,
  and configures the 389ds instance NSS certificate database to include these
  certificates and keys.
- Automatically configures certmap.conf to allow optional binding using client
  certificates, where the certificate is verified and stored in the userCertificate
  attribute, and the subject of the certificate is stored in nsCertSubjectDN.
- Binds to port 636 using the given certificate.
- If firewalld is installed, automatically opens the relevant port for the duration of
  the running of the server.
- Zero Trust configuration.

## before

- Deploy the device-389ds-tls package.

```
[root@server ~]# dnf install device-389ds-tls
```

- Place certificates in files beneath the directory /etc/pki/tls/certs with extension
  pem. Place keys in files beneath the directory /etc/pki/tls/private. All certificates
  and keys will be scanned, only file extensions are important.

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

To expose the instance called "seawitch" with the hostname "seawitch.example.com" over
port 636 securely using LDAPS, run this. The certificate, chain and key will be found
based on the hostname provided and configured automatically.

```
[root@server ~]# device services ldap tls add instance=seawitch hostname=seawitch.example.com port=636
```

## remove tls from instance

To remove the entry above with index zero, run this.

```
[root@server ~]# device services ldap tls remove 0
```



# device-389ds-replication
Extends a 389ds directory server appliance with replication support
  
This appliance extension does the following:

- All parameters passed to the device commands are syntax checked and canonicalised,
  with bash completion.
- Offers configuration of autogoing replication agreements, secured by TLS and client
  certificates.
- Offers configuration of incoming replication requests, secured by TLS and client
  certificates.
- Automatically identifies the correct client certificate, certificate chain, root
  certificate and key to use from certificates and keys placed under /etc/pki/tls,
  updates the replication user to accept one or more of the certificates presented,
  and configures the 389ds instance NSS certificate database to include all intermediate
  and root certificates as required to fully verify the certificate in use.
- Zero Trust configuration.

## before

- Deploy the device-389ds-replication package.

```
[root@server ~]# dnf install device-389ds-replication
```

- Place certificates in files beneath the directory /etc/pki/tls/certs with extension
  pem. All certificates will be scanned, only file extensions are important.

```
[root@server ~]# ls -l /etc/pki/tls/certs
/etc/pki/tls/certs:
total 48
drwxr-xr-x. 2 root root 4096 Oct  2 21:35 .
drwxr-xr-x. 5 root root  104 Sep 23 21:03 ..
lrwxrwxrwx. 1 root root   49 Jul 28 21:08 ca-bundle.crt -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
lrwxrwxrwx. 1 root root   55 Jul 28 21:08 ca-bundle.trust.crt -> /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt
-rw-r--r--. 1 root root 4893 Aug 20 12:50 upstream.example.com-sectigo-2023-hostCert.pem
-rw-r--r--. 1 root root 4603 Aug 20 12:51 upstream.example.com-sectigo-2023-hostChain.pem
-rw-r--r--. 1 root root 2278 Aug 20 12:50 seawitch.example.com-sectigo-2023-hostCert.pem
-rw-r--r--. 1 root root 4136 Aug 20 12:51 seawitch.example.com-sectigo-2023-hostChain.pem
```

# add replication support to a given suffix

To enable replication for a given suffix on a given instance we named "seawitch-example" above, 

```
[root@server ~]# device services ldap replication replica add replica-id=21 role=supplier suffix=seawitch-example 
```

# remove replication support from a given suffix

To remove the entry above with index zero, run this.

```
[root@server ~]# device services ldap replication replica remove 0 
```

# add certificate to allow incoming replication

To add an incoming user called "upstream" that allows replication protected by a
given client certificate that matches "upstream.example.com", ensure the client
certificate and if necessary full chain and root certificate are available in
/etc/pki/tls/certs, and then run this. If the instance is running it will be
updated immediately, if not running the instance will be updated at next startup.

```
[root@server ~]# device services ldap replication incoming add name=upstream tls-dns=upstream.example.com suffix=seawitch-example 
```

# remove the certificate added above

To remove the certificate added above, run this. The user will be updated in the directory.

```
[root@server ~]# device services ldap replication incoming remove upstream 
```

# add replication agreement

To add a replication agreement called "downstream" that we will replicate the suffix
"seawitch-example" to the host "downstream.example.com" on port 636, run this.

```
[root@server ~]# device services ldap replication outgoing add name=downstream host=downstream.example.com port=636 suffix=seawitch-example 
```

# remove replication agreement

To remove the replication agreement added above, run this.

```
[root@server ~]# device services ldap replication outgoing remove downstream
```

