Atlassian's Bitbucket
----------------------------------------
[reyesruiz/docker-bitbucket][1]

[Apache Trafic Server][0]

#### Build
 - Centos: 7
 - Atlassian's Bitbucket 


### Tags
 - latest	(4.6.2)

### Installation
 - Install Data Container
 `docker run -d  --name bitbucket-data -v /data/bitbucket/bitbucket-install:/opt/atlassian -v /data/bitbucket/bitbucket-data:/var/atlassian busybox:latest`
 - Install DB Storage
 `docker run -d -v /var/lib/mysql --name bitbucket-db-storage busybox:latest`
 - Install DB Container
 `docker run -d --volumes-from bitbucket-db-storage --name bitbucket-db -e MARIADB_USER=<admin> -e MARIADB_PASS=<TestPassword> million12/mariadb`
 - Install Bitbucket Container
 `docker run -d  --name bitbucket --link bitbucket-db:bitbucket.db --volumes-from bitbucket-data -e MARIADB_USER=<admin> -e MARIADB_PASS=<TestPassword> -e BITBUCKET_DB_ADDRESS=bitbucket.db -e BITBUCKET_DB_NAME=bitbucketdb -e BITBUCKET_USER=bitbucketuser -e BITBUCKET_PASS=TestPassword -e DB_SUPPORT=mariadb -p 7990:7990 -p 7999:7999 reyesruiz/docker-bitbucket`



### Usage

 - For latest release run:
 `docker exec -i -t bitbucket /bin/bash`

### Configuration
 This build has standard configuration directories located under /opt/atlassian/bitbucket/4.6.2 

[0]: https://bitbucket.org/ 
[1]: https://hub.docker.com/r/reyesruiz/docker-bitbucket/
