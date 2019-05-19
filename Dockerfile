ARG UBUNTU_VERSION=18.10
ARG GO_VERSION=1.11.4
ARG TERRAFORM_VERSION=0.11.11
ARG PROTOC_VERSION=3.6.1
ARG GCLOUD_VERSION=196.0.0

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
    mv google-cloud-sdk/bin/gcloud /usr/local/bin/ && \
    rm google-cloud-sdk-${GCLOUD_VERSION}-linux-x86_64.tar.gz

# base OS
FROM ubuntu:${UBUNTU_VERSION}
ARG GO_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG="en_US.UTF-8"
ENV LC_ALL="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -qq -y \
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
	neovim \
	sudo \
	tmux \
	tree \
	unzip \
	wget \
	zip \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen --purge $LANG && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE

RUN echo "source ~/.config/bash/profile" | tee -a /etc/profile

RUN groupadd -g 1001 yagi5 && useradd -g yagi5 -u 1001 yagi5 && mkdir /home/yagi5 && chown yagi5:yagi5 /home/yagi5
USER 1001


RUN mkdir -p /home/yagi5/ghq/bin

COPY --from=terraform_builder /usr/local/bin/terraform /usr/local/bin/
COPY --from=protobuf_builder /usr/local/bin/protoc /usr/local/bin/
COPY --from=protobuf_builder /usr/local/include/google/ /usr/local/include/google
COPY --from=gcloud_builder /usr/local/bin/gcloud /usr/local/bin/
# COPY config /home/yagi5/.config

#  RUN git clone https://github.com/junegunn/fzf /home/yagi5/.config/fzf && \
#      cd /home/yagi5/.config/fzf && \
#      git remote set-url origin git@github.com:junegunn/fzf.git && \
#      /home/yagi5/.config/fzf/install --bin --64 --no-bash --no-zsh --no-fish --no-key-bindings --no-completion --no-update-rc --xdg

WORKDIR /home/yagi5
COPY entrypoint.sh /bin/entrypoint.sh
CMD ["/bin/entrypoint.sh"]
