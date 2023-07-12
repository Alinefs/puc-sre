FROM jenkins/jenkins:2.411-slim 

ARG AUTOR=AlineFS

ENV JENKINS_HOME=/app

USER root

LABEL maintainer=${AUTOR}

WORKDIR ${JENKINS_HOME}

CMD [ "tail", "-f", "${JENKINS_HOME}/logs/log" ]

EXPOSE 80/tcp

#Coping files
COPY conf/jenkins.sh /usr/local/bin/ 
COPY conf/credentials-configuration.xml conf/jenkins.sh conf/jenkins.telemetry.Correlator.xml conf/set_jenkins_env.groovy ${JENKINS_HOME}/

# Hardening
RUN echo "ipv6" >> /etc/modules && \
    bash -c 'echo -e "* hard nofile 65535\n* soft nofile 65535" >> /etc/security/limits.conf' && \
    bash -c 'echo -e "fs.file-max=65535\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.bindv6only=0" >> /etc/sysctl.conf' && \
    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    sed -i "s/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/g" /etc/ssh/ssh_config && \
    mkdir /root/.ssh /root/.aws && \
    mkdir /etc/sudoers.d &&  echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/jenkins && \
    rm -rf ${JENKINS_HOME}/.ssh/* ${JENKINS_HOME}/.aws/* /root/.ssh/* /root/.aws/* && \
    bash -c 'echo -e "[default]\nregion = us-east-1" > /root/.aws/config' && \
    bash -c 'echo -e "StrictHostKeyChecking=no\nHost GitHub\n  IdentityFile /root/.ssh/id_rsa\n  User git\n  Port 22" > /root/.ssh/config' && \
    apt-get update && \
    apt-get install -y vim apt-utils wget bc apt-transport-https sudo gnupg2 snapd python3 python3-pip gpp ntp git && \
    apt-get install -y xvfb openssh-client unzip coreutils groff netcat nmap lvm2 && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    curl -LO "https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip" && \
    unzip terraform_1.1.7_linux_amd64.zip && \
    sudo install -o root -g root -m 0755 terraform /usr/local/bin/terraform && \
    pip3 install boto3 pandas 

#Installing plugins
ENV JENKINS_REF_PATH /usr/share/jenkins/ref  
COPY conf/plugins.txt ${JENKINS_REF_PATH}/plugins.txt
RUN jenkins-plugin-cli -f ${JENKINS_REF_PATH}/plugins.txt --verbose

#Moving files
RUN mv ${JENKINS_HOME}/set_jenkins_env.groovy ${JENKINS_REF_PATH}/init.groovy.d/ && chown root. ${JENKINS_HOME} -R