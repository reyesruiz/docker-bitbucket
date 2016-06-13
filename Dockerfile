FROM million12/centos-supervisor
MAINTAINER Reyes Ruiz <reyes_ruiz@digitalruiz.com> 

# Supported DB: HSQL(default) and MySQL(MariaDB). to select MySQL use DB_SUPPORT=mysql or DB_SUPPORT=mariadb on docekr run.
ENV   DB_SUPPORT=default \
      BITBUCKET_VERSION=4.6.2

RUN \
  rpm --rebuilddb && yum clean all && \
  yum install -y java-1.8.0-openjdk tar mariadb git && \
  yum clean all && \
  curl -L https://www.atlassian.com/software/stash/downloads/binary/atlassian-bitbucket-${BITBUCKET_VERSION}-x64.bin -o /tmp/bitbucket.bin && \
  chmod +x /tmp/bitbucket.bin

ADD container-files/ /
