FROM jenkins/jenkins:lts

USER root

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY *.yaml /var/jenkins_home/casc_configs/

RUN apt-get update && apt-get install -y \
    ca-certificates curl gnupg lsb-release git && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bullseye stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    groupadd docker && usermod -aG docker jenkins && \
    jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt && \
    git clone https://github.com/cqNikolaus/jenkins_automation /tmp/repo && \
    cp /tmp/repo/*.yaml /var/jenkins_home/casc_configs/ && \
    rm -rf /tmp/repo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV CASC_JENKINS_CONFIG=/var/jenkins_home/casc_configs
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

USER jenkins
