FROM debian:buster-slim

LABEL repository="https://github.com/claudiodekker/splitsh-action"
LABEL homepage="https://github.com/claudiodekker/splitsh-action"
LABEL maintainer="Claudio Dekker <claudio@ubient.net>"

RUN apt-get update && \
    apt-get install -y git wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/splitsh/lite/releases/download/v1.0.1/lite_linux_amd64.tar.gz && \
    tar -zxpf lite_linux_amd64.tar.gz -C /usr/local/bin/ && \
    rm lite_linux_amd64.tar.gz

RUN mkdir -p ~/.ssh
RUN ssh-keyscan github.com gitlab.com bitbucket.org ssh.dev.azure.com vs-ssh.visualstudio.com >> ~/.ssh/known_hosts

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
