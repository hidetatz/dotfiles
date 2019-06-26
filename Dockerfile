ARG UBUNTU_VERSION=18.10
ARG GO_VERSION=1.12.5
ARG TERRAFORM_VERSION=0.11.11
ARG PROTOC_VERSION=3.6.1
ARG GCLOUD_VERSION=196.0.0
ARG DOCKER_COMPOSE_VERSION=1.24.0

# If package can be installed by apt, use apt
# If not, setup stage

# install terraform
FROM ubuntu:${UBUNTU_VERSION} as terraform_builder
ARG TERRAFORM_VERSION
RUN apt-get update && apt-get install -y wget ca-certificates unzip
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# install protobuf
FROM ubuntu:${UBUNTU_VERSION} as protobuf_builder
ARG PROTOC_VERSION
RUN apt-get update && apt-get install -y wget ca-certificates unzip
RUN wget https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    unzip protoc-${PROTOC_VERSION}-linux-x86_64.zip && \
    mv bin/protoc /usr/local/bin && \
    mv include/* /usr/local/include/ && \
    rm protoc-${PROTOC_VERSION}-linux-x86_64.zip

# install gcloud
FROM ubuntu:${UBUNTU_VERSION} as gcloud_builder
ARG GCLOUD_VERSION
RUN apt-get update && apt-get install -y wget ca-certificates python
RUN wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
    tar xzvf google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz && \
    ./google-cloud-sdk/install.sh --usage-reporting=false --path-update=false --command-completion=false && \
    ./google-cloud-sdk/bin/gcloud components update --quiet && \
    ./google-cloud-sdk/bin/gcloud components install kubectl --quiet && \
    mv google-cloud-sdk /tmp/ && \
    rm google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz

# install docker-compose
FROM ubuntu:${UBUNTU_VERSION} as docker_compose_builder
ARG DOCKER_COMPOSE_VERSION
RUN apt-get update && apt-get install -y wget ca-certificates
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# base OS
FROM ubuntu:${UBUNTU_VERSION}
ARG GO_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

# add-apt-repositoyr command depents on software-properties-common
RUN apt update -qq && apt upgrade -y && apt install -qq -y software-properties-common && add-apt-repository ppa:neovim-ppa/stable

RUN apt update -qq && apt upgrade -y && apt install -qq -y \
    bash-completion \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    default-libmysqlclient-dev \
    default-mysql-client \
    dnsutils \
    docker.io \
    gdb \
    git \
    git-crypt \
    hugo \
    jq \
    less \
    locales \
    man \
    net-tools \
    netcat \
    python \
    python-dev \
    python-pip \
    python3 \
    python3-dev \
    python3-pip \
    neovim \
    ssh \
    sudo \
    tmux \
    tree \
    tzdata \
    unzip \
    wget \
    zip \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN apt update -qq && apt install -qq -y \
    python-setuptools \
    python3-setuptools \
    && \
    pip install neovim && \
    pip3 install neovim

RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen --purge $LANG && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE \ 
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN echo "source /home/yagi5/.config/bash/profile" | tee -a /etc/profile

RUN mkdir /run/sshd && \
    sed 's/#Port 22/Port 2222/' -i /etc/ssh/sshd_config && \
    sed 's/#PubkeyAuthentication/PubkeyAuthentication/' -i /etc/ssh/sshd_config && \
    sed 's/#AuthorizedKeysFile/AuthorizedKeysFile/' -i /etc/ssh/sshd_config && \
    sed 's/.ssh\/authorized_keys/\/home\/yagi5\/.ssh\/authorized_keys/' -i /etc/ssh/sshd_config && \
    sed 's/#PasswordAuthentication yes/PasswordAuthentication no/' -i /etc/ssh/sshd_config

RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" | EDITOR='tee -a' visudo >/dev/null

RUN groupadd -g 1002 wheel && \
    groupadd -g 1001 yagi5 && \
    useradd -g yagi5 -u 1001 yagi5 && \
    gpasswd -a yagi5 wheel && \
    mkdir /home/yagi5 && \
    chown yagi5:yagi5 /home/yagi5 && \
    chsh -s /bin/bash yagi5
USER 1001

RUN mkdir /home/yagi5/.config && \
    mkdir -p /home/yagi5/ghq/bin && \
    mkdir -p /home/yagi5/ghq/src && \
    sudo chown -R yagi5:yagi5 /home/yagi5 && \
    mkdir /home/yagi5/.ssh && \
    curl -fsL https://github.com/yagi5.keys > /home/yagi5/.ssh/authorized_keys && \
    chmod 700 /home/yagi5/.ssh && \
    chmod 600 /home/yagi5/.ssh/authorized_keys

COPY --from=terraform_builder /usr/local/bin/terraform /usr/local/bin/
COPY --from=protobuf_builder /usr/local/bin/protoc /usr/local/bin/
COPY --from=protobuf_builder /usr/local/include/google/ /usr/local/include/google
COPY --from=gcloud_builder /tmp/google-cloud-sdk /home/yagi5/.config/google-cloud-sdk/
COPY --from=docker_compose_builder /usr/local/bin/docker-compose /usr/local/bin/

WORKDIR /home/yagi5
COPY entrypoint.sh /bin/entrypoint.sh
COPY sshd.sh /bin/sshd.sh

CMD ["/bin/sshd.sh"]
