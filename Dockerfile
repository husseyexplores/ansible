FROM debian:latest AS base

FROM base AS base_with_basics
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential python3-launchpadlib sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base_with_basics AS hsy
RUN addgroup --gid 1000 hsy && \
    adduser --gecos "" --uid 1000 --gid 1000 --disabled-password hsy && \
    echo 'hsy:1' | chpasswd && \
    usermod -aG sudo hsy

USER hsy
WORKDIR /home/hsy

FROM hsy AS final
COPY --chown=hsy . .
CMD ["bash", "-c", "ansible-playbook local.yml --ask-become-pass --ask-vault-pass"]
