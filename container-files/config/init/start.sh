export TERM=xterm

# Bash Colors
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
white=`tput setaf 7`
bold=`tput bold`
reset=`tput sgr0`
separator=$(echo && printf '=%.0s' {1..100} && echo)

#OS VARIABLES
INSTALL_DIR="/opt/atlassian/bitbucket/${BITBUCKET_VERSION}"
INSTALL_FILE='/tmp/bitbucket.bin'

# Functions
log() {
  if [[ "$@" ]]; then echo "${bold}${green}[BITBUCKET-LOG `date +'%T'`]${reset} $@";
  else echo; fi
}
stop_bitbucket() {
  log "Stopping Bitbucket"
  ${BITBUCKET_VERSION}/stop-bitbucket.sh
  log "Bitbucket Stopped"
}
install_bitbucket() {
  if [[ -e ${INSTALL_FILE} ]]; then
    log "Starting Installation of Bitbucket version: ${BITBUCKET_VERSION}"
    cd /tmp
    ./bitbucket.bin <<<"o
1
1




y
i
y
n
"
    ## Check Supported version of database specified by user on docker run.
    if [[ ${DB_SUPPORT} == "mysql" || ${DB_SUPPORT} == "mariadb" ]]; then
      prepare_mysql_database
      get_mysql_connector
      log "MySQL/MariaDB Support ${bold}${green}[Installed]${reset}"
    else
      log "MySQL/MariaDB Support ${bold}${red}[Not Installed]${reset}"
    fi
    log "BITBUCKET server installed."
    stop_bitbucket
    ## Clean all installation directories from trash.
    clean_all
  else
    log "Bitbucket already installed and configured. Attempting to start previous Bitbucket instance."
  fi
}
get_mysql_connector() {
  log "Downloading mysql-connector."
  curl -L http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.37.tar.gz -o /tmp/mysql-connector-java-5.1.37.tar.gz
  mkdir -p /tmp/mysql-connector/
  tar zxvf /tmp/mysql-connector-java-5.1.37.tar.gz -C /tmp/mysql-connector/ --strip-components=1
  cp /tmp/mysql-connector/mysql-connector-java-5.1.37-bin.jar ${INSTALL_DIR}/lib/
  log "mysql-connector Installed."
}
prepare_mysql_database() {
  log "Installing MySQL/MariaDB support"
  MYSQL_CONN="mysql -u $MARIADB_USER -p$MARIADB_PASS -h $BITBUCKET_DB_ADDRESS -e "
  ${MYSQL_CONN} "CREATE DATABASE $BITBUCKET_DB_NAME CHARACTER SET utf8 COLLATE utf8_bin;"
  ${MYSQL_CONN} "GRANT ALL on ${BITBUCKET_DB_NAME}.* TO '${BITBUCKET_USER}'@'%' IDENTIFIED BY '${BITBUCKET_PASS}';"
  ${MYSQL_CONN} "FLUSH PRIVILEGES;"
  log "MYSQL database updated."
}
clean_all() {
  log "Removing all temporary files."
  rm -rf /tmp/mysql-connector-java-5.1.37.tar.gz
  rm -rf /tmp/mysql-connector/
  rm -rf /tmp/bitbucket.bin
  log "All cleaned. System ready! "
}

## Install Bitbucket Server
install_bitbucket
