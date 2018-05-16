# MongoDB installation

As a superuser we have to run different commands in ordrer to install 
**MongoDB** in the system:

* Install MongoDB package.

    First of all we need to add Mongo's repository to the machine.
    
    `[root@host ]# vim /etc/yum.repos.d/mongodb.repo`
    
    And we add the following lines:
    
    ```
    [mongodb]
    name=MongoDB Repository
    baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
    gpgcheck=0
    enabled=1
    ```
    
    Later we install the package:
    
    `[root@host ]# dnf -y install mongodb-org mongodb-org-server`

* Start MongoDB service.

    `[root@host ]# systemctl start mongod`

* Enable MongoDB service.

    `[root@host ]# systemctl enable mongod`
    
    
There is a possibility of creating a configuration file for mongod instance at startup.
That file contains settings that are equivalent to mongod command-line options. 
Using it, makes managing options easier. 

The general format for this file is in [_YAML_](https://en.wikipedia.org/wiki/YAML) language.

In this case, we can configure different options such as:

* [SystemLog](https://docs.mongodb.com/v2.6/reference/configuration-options/#core-options),
 
* [processManagement](https://docs.mongodb.com/v2.6/reference/configuration-options/#processmanagement-options), 

* [net](https://docs.mongodb.com/v2.6/reference/configuration-options/#net-options), 

* [setParameter](https://docs.mongodb.com/v2.6/reference/configuration-options/#setparameter-option), 

* [security](https://docs.mongodb.com/v2.6/reference/configuration-options/#security-options), 

* [operationProfiling](https://docs.mongodb.com/v2.6/reference/configuration-options/#operationprofiling-options), 

* [storage](https://docs.mongodb.com/v2.6/reference/configuration-options/#storage-options), 

* [replication](https://docs.mongodb.com/v2.6/reference/configuration-options/#replication-options) and 

* [auditLog options](https://docs.mongodb.com/v2.6/reference/configuration-options/#auditlog-options).

For this project is used the default configuration file because 
we use different functions to obtain extra data from queries. 
But if you are interested in knowing the different options to use,
you can visit the [official website](https://docs.mongodb.com/v2.6/reference/configuration-options/). 
