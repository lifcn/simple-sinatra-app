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

* hostname, IP addresses & its designation
| Hostname              | IP Address      	| Purpose      			|

| :---                  | :---                  | :---                  	|
| docker21.fen9.li	| 192.168.200.21/24	| docker host,Jenkins Master	|
| docker22.fen9.li	| 192.168.200.22/24	| docker host,Jenkins Slave,developing host	|

Note: developing host does not have to be and it should not be a Jenkins Slave host. 

* Update '/etc/hosts' if there is not any DNS 
```sh
echo '192.168.200.21  docker21.fen9.li   docker21' >> /etc/hosts
echo '192.168.200.22  docker22.fen9.li   docker22' >> /etc/hosts
```

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

* Turn on firewall ports

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
[fli@docker21 ~]$ id
uid=1000(fli) gid=1000(fli) groups=1000(fli),995(docker) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[fli@docker21 ~]$ pwd
/home/fli
[fli@docker21 ~]$ mkdir jenkins_home
[fli@docker21 ~]$
``` 

* Create slave node on Jenkins master web UI
> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins_25.html) for screenshots.

## A Commit Pipeline Example

### On developer's developing host (docker22.fen9.li in this project context)
* git clone this repo

```sh
[fli@docker22 ~]$ git clone -b jenkins https://github.com/fen9li/simple-sinatra-app.git   Cloning into 'simple-sinatra-app'...
remote: Counting objects: 44, done.
remote: Compressing objects: 100% (27/27), done.
remote: Total 44 (delta 12), reused 21 (delta 3), pack-reused 14
Unpacking objects: 100% (44/44), done.
[fli@docker22 ~]$

[fli@docker22 ~]$ cd simple-sinatra-app/
[fli@docker22 simple-sinatra-app]$

[fli@docker22 simple-sinatra-app]$ tree
.
├── build_helloworld.sh
├── config.ru
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── helloworld.rb
├── Jenkinsfile
├── README.md
└── test_helloworld.sh

0 directories, 9 files
[fli@docker22 simple-sinatra-app]$
```

* Turn on firewall port

```sh
firewall-cmd --permanent --add-service=http
firewall-cmd --reload

[root@docker22 ~]# firewall-cmd --list-service
ssh dhcpv6-client http
[root@docker22 ~]#
```

### On Jenkins Master UI
* Define commit pipeline as below 

> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins_26.html) for screenshots.

```sh
Pipeline
  Definition: Pipeline script from SCM
  SCM: Git
  Repositories: 
    URL: https://github.com/fen9li/simple-sinatra-app.git
    Credentials: none
  Branch to build: 
    Branch Specifier (blank for 'any'): */jenkins
  Script Path: Jenkinsfile
```

### Add triggers 
* Configure Jenkins polling SCM (GitHub) every 10 minutes

> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins_26.html) for screenshots.

### Add Email notification
> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins_26.html) for screenshots.

```sh
E-mail Notification: smtp.gmail.com
Use SMTP Authentication: ticked
User Name:  xxx@gmail.com
Password: xxxxxxxx
Use SSL: ticked	
SMTP Port: 465
Reply-To Address: xxx@gmail.com
Charset	: UTF-8
Test configuration by sending test e-mail: ticked	
Test e-mail recipient: xxx@yahoo.com
```

### Test Jenkins / Docker Auto Build

* Update source code 'helloworld.rb', and push it to GitHub repo
```sh
[fli@docker22 simple-sinatra-app]$ vi helloworld.rb
[fli@docker22 simple-sinatra-app]$ cat helloworld.rb
require 'sinatra'
set :bind, '0.0.0.0'
get '/' do
  "Hello Womkald!"
end
[fli@docker22 simple-sinatra-app]$ git commit -am 'Update helloworld.rb - Hello Womkald'
[jenkins 18c5f3d] Update helloworld.rb - Hello Womkald
 1 file changed, 1 insertion(+), 1 deletion(-)
[fli@docker22 simple-sinatra-app]$ git push -u origin jenkins
Username for 'https://github.com': fen9li
Password for 'https://fen9li@github.com':
Counting objects: 5, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 313 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To https://github.com/fen9li/simple-sinatra-app.git
   94e4335..18c5f3d  jenkins -> jenkins
Branch jenkins set up to track remote branch jenkins from origin.
[fli@docker22 simple-sinatra-app]$
```

* Jenkins polling GitHub every 10 minutes and detects the new version source code, which triggers the auto build process.

* Once build finishes, Jenkins sends email notification as per designed

> Refer [this company document](http://fengli-au.blogspot.com.au/2017/11/ci-case-study-combine-power-of-jenkins_73.html) for screenshots.

## Where to Go Next
* Add features to support continuous deployment.


