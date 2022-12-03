FROM ubuntu:20.04

LABEL Author="Phil Dieppa"
LABEL Email="mrdieppa@gmail.com"
LABEL BaseImage="ubuntu:20.04"
LABEL RunnerVersion=${RUNNER_VERSION}

ADD https://github.com/Yelp/dumb-init/releases/download/v1.0.2/dumb-init_1.0.2_amd64 /usr/bin/dumb-init
RUN chmod +x /usr/bin/dumb-init

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    
# update the base packages + add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git azure-cli jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip zip ca-certificates apt-transport-https nano software-properties-common vault terraform openjdk-17-jdk pandoc texlive texlive-xetex lmodern

RUN echo "deb https://packages.gitlab.com/runner/gitlab-ci-multi-runner/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/runner_gitlab-ci-multi-runner.list && \
    wget -q -O - https://packages.gitlab.com/gpg.key | apt-key add - && \
    apt-get update -y && \
    apt-get install -y gitlab-ci-multi-runner && \
    wget -q https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-Linux-x86_64 -O /usr/bin/docker-machine && \
    chmod +x /usr/bin/docker-machine && \
    apt-get clean && \
    mkdir -p /etc/gitlab-runner/certs && \
    chmod -R 700 /etc/gitlab-runner && \
    rm -rf /var/lib/apt/lists/*

# ADD config.toml /etc/gitlab-runner/config.toml

ADD entrypoint /
RUN chmod +x /entrypoint

# ADD certificates/ca.crt /etc/gitlab-runner/certs
# ADD certificates/gitlab.domain.local.crt /etc/gitlab-runner/certs

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

# CMD ["printenv"]

ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]

CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
