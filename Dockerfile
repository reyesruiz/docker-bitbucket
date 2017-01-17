FROM million12/centos-supervisor
MAINTAINER Reyes Ruiz <reyes_ruiz@digitalruiz.com> 

# Supported DB: HSQL(default) and MySQL(MariaDB). to select MySQL use DB_SUPPORT=mysql or DB_SUPPORT=mariadb on docekr run.
ENV   DB_SUPPORT=default \
      BITBUCKET_VERSION=4.12.1

WORKDIR /tmp
RUN yum clean all && yum update -y && yum install java-1.8.0-openjdk git tar mariadb git vim wget telnet bind-utils net-tools lsof -y
RUN wget https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}-x64.bin
RUN mv atlassian-bitbucket-${BITBUCKET_VERSION}-x64.bin bitbucket.bin && chmod +x bitbucket.bin
ADD install.sh /tmp/
RUN chmod +x /tmp/install.sh && /tmp/install.sh

