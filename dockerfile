FROM gitlab/gitlab-runner:ubuntu-v15.6.1

LABEL Author="Phil Dieppa"
LABEL Email="mrdieppa@gmail.com"
LABEL BaseImage="ubuntu:20.04"

# update the base packages + add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
    curl nodejs wget unzip vim git jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip \
    zip ca-certificates apt-transport-https gpg software-properties-common

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

# Install Terraform
RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
    vault terraform

# Install PowerShell
RUN wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell

# ADD config.toml /etc/gitlab-runner/config.toml


# ADD certificates/ca.crt /etc/gitlab-runner/certs
# ADD certificates/gitlab.domain.local.crt /etc/gitlab-runner/certs


# CMD ["printenv"]

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]
ENTRYPOINT ["/usr/bin/dumb-init", "/entrypoint"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
