# Postgres installation

As a superuser we have to run different commands in ordrer to install 
**Postgres** in our system:

* Install Postgres package.

    `[root@host ]# dnf -y install postgresql-server`

* Init Postgres.

    `[root@host ]# postgresql-setup initdb`

* Start service.

    `[root@host ]# systemctl start postgresql`

* Enable service.

    `[root@host ]# systemctl enable postgresql`

* Set password to user postgres (we could use **jupiter** for example).

    `[root@host ]# passwd postgres`
    
    
* There is a configuration file placed in _/var/lib/pgsql/data/_ that is 
  named [_pg_hba.conf_](https://www.postgresql.org/docs/9.3/static/auth-pg-hba-conf.html) 
  where we can change different parameters of the client 
  authentication (HBA stands for host-based authentication).
  
  The general format for this file is a set of records where each record 
  specifies:
      
   * A connection type, 
   
   * A client IP address range,
   
   * A database name,
   
   * A user name and
   
   * The authentication method to be used for connection matching this parameters.
  
  If one record is chosen and the authentication fails, subsequent records 
  are not considered.
  
  If no record matches, access is denied. 
  
  Before explaining the divergences between the options we use, we should 
  differenciate 4 different **types** of connection:
  
   * **Local**: This option matches connection attempts using Unix-domain sockets. 
   
   * **Host**: This option matches connection attempts using TCP/IP, the most commonly used.
   
   * **Hostssl**: This option matches connection attempts made using TCP/IP 
                  but only when the connection is made with SSL encryption.
                  
   * **Hostnossl**: This option has the opposite behaviour of hostssl. 
  
  Here we will see the most commonly used **options** and their meaning. 
  
  
  Option       |    Usage
  -------------|-------------------------------------------------------------------------------------------------------
  Database     | Specifies the db name. Value all specifies that it matches all databases.
  User         | Specifies which database user name this record matches. Value all specifies that it matches all users.
  Address      | Specifies the client machine address(es) that this record matches.
  Auth-method  | Specifies the authentication method to use when a connection matches this record.
  Auth-options | There can be field(s) of the form name=value that specify options for the authentication method. 
  
  
  For the **auth-method** there are possible choices to consider, here we see the ones used the most, but there are other [possibilities](https://www.postgresql.org/docs/9.1/static/auth-pg-hba-conf.html):
  
  
   Choice    |   Definition
   ----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   trust     | Allow the connection unconditionally.
   reject    | Reject the connection unconditionally.
   md5       | Require the client to supply an encrypted password for authentication. Is sent encrypted.
   password  | Require the client to supply an unencrypted password for authentication. Is sent in clear text.
   ident     | Obtain the operating system user name of the client by contacting the ident server on the client and check if it matches the requested database user name. When specified for local connections, peer authentication will be used instead.
   peer      | Obtain the client's operating system user name from the operating system and check if it matches the requested database user name.
   krb5      | Use Kerberos V5 to authenticate the user.
   ldap      | Authenticate using an LDAP server.
   pam       | Authenticate using the Pluggable Authentication Modules (PAM) service provided by the operating system. 
  
  
   There are lots of possible configurations, but here you will see simple examples we use the most.
   
   * Allow local users to enter without authentication
       
       `local   all             all                                     trust`
   
   * Allow any user from any host with IP address 192.168.93.x to connect
     to database "postgres" as the same user name that ident reports for
     the connection.
     
       `host    postgres        all             192.168.93.0/24         ident`
   
   * Allow any user from hosts in the example.com domain to connect to
     any database if the user's password is correctly supplied.
     
       `host    all             all             .example.com            md5`
