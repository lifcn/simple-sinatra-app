# CI Case Study: Combine the Power of Jenkins and Docker

Continuous Integration (CI) is a development practice that requires developers to integrate code into a shared repository several times a day. Each check-in is then verified by an automated build, allowing teams to detect problems early. This project implements a CI solution by combining the power of Jenkins and docker to facility developers building and testing source code easily.

* Jenkins & Docker based
* GitHub based

## How It Works

* Developers push new version codes to GitHub repo
* Jenkins polls GitHub repository branch(s) periodically and detects the new codes
* Jenkins builds and tests the codes automatically
* Jenkins sends email to developer the result

## Resources / Services Consumed / Used in This Solution

* 2 Linux machines (2 vCPU, 2GiB Memory, 2GiB SWAP, 1 NIC, 15+GiB Disk Space)
* An gmail account (smtp.gmail.com is used by Jenkins to send email notes)
* A GitHub account and repo

## Set Up the CI Solution

### Jenkins Master and Agent Hosts Designation

| Hostname              | IP Address      	| Purpose      			|
| :---                  | :---                  | :---                  	|
| docker21.fen9.li	| 192.168.200.21/24	| docker host,Jenkins Master	|
| docker22.fen9.li	| 192.168.200.22/24	| docker host,Jenkins Slave	|

### Install Software Packages on docker21 & docker22

* Install Docker on docker21 & docker22 by following [official guide](https://docs.docker.com/engine/installation/#server)

* Install git on docker21 & docker22 

* Install docker-compose on docker21 by following [official guide](https://docs.docker.com/compose/install/#install-compose)

* Install Java on docker22 by following [official guide](https://www.java.com/en/download/help/linux_x64_install.xml)

### Jenkins Master @ docker21

* Ensure user in docker group, create jenkins_home

```sh
[fli@docker21 ~]$ id
uid=1000(fli) gid=1000(fli) groups=1000(fli),995(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[fli@docker21 ~]$ pwd
/home/fli
[fli@docker21 ~]$ mkdir jenkins_home
[fli@docker21 ~]$
```

* Configure firewall 

```sh
firewall-cmd --permanent --add-port={8080/tcp,50000/tcp}
firewall-cmd --reload

[root@docker21 ~]# firewall-cmd --list-port
8080/tcp 50000/tcp
[root@docker21 ~]#

```

* Create docker-compose.yml

```sh
[fli@docker21 ~]$ vi docker-compose.yml
[fli@docker21 ~]$ cat docker-compose.yml
version: '3'
services:
  ci:
    image: jenkins:2.60.3
    volumes:
     - "/home/fli/jenkins_home:/var/jenkins_home"
    ports:
     - "8080:8080"
     - "50000:50000"

[fli@docker21 ~]$
```

* Start jenkins master now on docker21

```sh
[fli@docker21 ~]$ docker-compose up -d
Creating network "fli_default" with the default driver
Pulling ci (jenkins:2.60.3)...
2.60.3: Pulling from library/jenkins
...
Digest: sha256:f369cdbc48c80535a590ed5e00f4bc209f86c53b715851a3d655b70bb1a67858
Status: Downloaded newer image for jenkins:2.60.3
Creating fli_ci_1 ...
Creating fli_ci_1 ... done
[fli@docker21 ~]$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                                              NAMES
03d29f287071        jenkins:2.60.3      "/bin/tini -- /usr..."   About a minute ago   Up About a minute   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   fli_ci_1
[fli@docker21 ~]$ docker logs fli_ci_1
...

*************************************************************
*************************************************************
*************************************************************

Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

ae6910e47478416887e2234711fb455c

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword

*************************************************************
*************************************************************
*************************************************************

...
[fli@docker21 ~]$

[fli@docker21 ~]$ docker port fli_ci_1
8080/tcp -> 0.0.0.0:8080
50000/tcp -> 0.0.0.0:50000
[fli@docker21 ~]$
```

### Jenkins Initial Set Up
> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins.html) for screenshots.

Start a web browser and enter 'http://192.168.200.21:8080/'.

* Unlock Jenkins
* Create first admin user
* Double Jenkins version 
 
### Add Jenkins Slave Node @ docker22

* Ensure user in docker group, create jenkins_home

```sh
[fli@docker22 ~]$ id
uid=1000(fli) gid=1000(fli) groups=1000(fli),995(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[fli@docker22 ~]$ pwd
/home/fli
[fli@docker22 ~]$ mkdir jenkins_home
[fli@docker22 ~]$
``` 

* Create slave node on Jenkins master web UI
> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins_25.html) for screenshots.

## A Commit Pipeline Example




