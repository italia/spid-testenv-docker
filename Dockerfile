FROM ubuntu:latest
MAINTAINER Umberto Rosini, rosini@agid.gov.it

ENV JAVA_HOME="/usr/lib/jvm/java-8-oracle"

# Port exposed
EXPOSE 9443 8080

# Update and install utilities
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get install -y vim && \
    apt-get install -y net-tools && \
    echo "Create user to run is and the backoffice (not root for security reason!)" && \
    useradd --user-group --create-home --shell /bin/false yoda && \
    echo "Oracle Java 8" && \
    apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get install oracle-java8-set-default && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    echo "Node 6" && \
    apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs && \
    apt-get install -y build-essential && \
    echo "Identity Server" && \
    mkdir /spid-testenvironment && \
    curl -o /spid-testenvironment/spid-testenv-identityserver.tar.gz https://codeload.github.com/italia/spid-testenv-identityserver/tar.gz/master && \
    mkdir /spid-testenvironment/is && \
    tar -zxvf /spid-testenvironment/spid-testenv-identityserver.tar.gz -C /spid-testenvironment/is --strip-components=1 && \
    rm -f /spid-testenvironment/spid-testenv-identityserver.tar.gz && \
    echo "Set custom conf" && \
    mv /spid-testenvironment/is/spid-confs/conf/conf/carbon.xml /spid-testenvironment/is/identity-server/repository/conf/ && \
    mv /spid-testenvironment/is/spid-confs/conf/conf/claim-config.xml /spid-testenvironment/is/identity-server/repository/conf/ && \
    mv /spid-testenvironment/is/spid-confs/conf/bin/wso2server.sh /spid-testenvironment/is/identity-server/bin/ && \
    echo "Backoffice" && \
    curl -o /spid-testenvironment/spid-testenv-backoffice.tar.gz https://codeload.github.com/italia/spid-testenv-backoffice/tar.gz/master && \
    mkdir /spid-testenvironment/bo && \
    tar -zxvf /spid-testenvironment/spid-testenv-backoffice.tar.gz -C /spid-testenvironment/bo --strip-components=1 && \
    rm -f /spid-testenvironment/spid-testenv-backoffice.tar.gz && \
    echo "Build backoffice" && \
    cd /spid-testenvironment/bo/backoffice && \
    npm install --suppress-warnings && \
    cd server && \
    npm install --suppress-warnings && \
    cd .. && \
    npm run build && \
    echo "Download bash script to start both identity server and backoffice" && \
    curl -o /spid-testenvironment/spidtestenvstart.sh https://raw.githubusercontent.com/italia/spid-testenv-docker/master/spidtestenvstart.sh && \
    chown -R yoda:yoda /spid-testenvironment/* && \
    chmod +x /spid-testenvironment/is/identity-server/bin/wso2server.sh && \
    chmod +x /spid-testenvironment/spidtestenvstart.sh && \
    echo "Cleaning up" && \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/* /tmp/*

USER yoda

WORKDIR /spid-testenvironment

ENTRYPOINT ["./spidtestenvstart.sh"]
