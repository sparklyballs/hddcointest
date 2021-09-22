ARG UBUNTU_VER="focal"
FROM ubuntu:${UBUNTU_VER}

# build arguments
ARG DEBIAN_FRONTEND=noninteractive
ARG RELEASE
ARG SECRETUSER
ARG SECRETPASS

# environment variables
ENV \
	farmer_address="null" \
	farmer="false" \
	farmer_port="null" \
	full_node_port="null" \
	harvester="false" \
	keys="generate" \
	plots_dir="/plots" \
	testnet="false" \
	TZ="UTC"

# set workdir for build stage
WORKDIR /hddcoin-blockchain

# install dependencies
RUN \
	apt-get update \
	&& apt-get install -y \
	--no-install-recommends \
		acl \
		bc \
		ca-certificates \
		curl \
		git \
		jq \
		lsb-release \
		openssl \
		python3 \
		sudo \
		tar \
		tzdata \
		unzip \
	\
# set timezone
	\
	&& ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime \
	&& echo "$TZ" > /etc/timezone \
	&& dpkg-reconfigure -f noninteractive tzdata \
	\
# cleanup
	\
	&& rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# build package
RUN \
	git clone https://${SECRETUSER}:${SECRETPASS}@github.com/HDDcoin-Network/hddcoin-blockchain-beta.git \
		/hddcoin-blockchain \		
	&& git submodule update --init mozilla-ca \
	&& sh install.sh

# set additional runtime environment variables
ENV \
	PATH=/hddcoin-blockchain/venv/bin:$PATH \
	CONFIG_ROOT=/root/.hddcoin/mainnet

# copy local files
COPY docker-*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-*.sh

# entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["docker-start.sh"]
