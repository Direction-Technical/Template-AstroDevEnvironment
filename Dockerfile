ARG NODE_VERSION=24
ARG GIT_USERNAME=Direction Technical
ARG GIT_USEREMAIL=info@directiontechnical.co.uk

FROM node:${NODE_VERSION}

ENV PATH="$PATH:/usr/local/bin"

# Install Git, SSH, and create-astro globally
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    curl \
    nano \
    dos2unix

# Copy package.json and install dependencies
COPY package.json .
RUN npm install \
  && echo "Installed dependencies from package.json"

# Create workspace
WORKDIR /workspace

# Copy SSH keys into container
COPY ssh/id_ed25519 /root/.ssh/id_ed25519
COPY ssh/id_ed25519.pub /root/.ssh/id_ed25519.pub
RUN chmod 600 /root/.ssh/id_ed25519 && chmod 644 /root/.ssh/id_ed25519.pub

# Add GitHub's host key to known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts

# Setup git user.name and user.email
RUN git config --global user.name "${GIT_USERNAME}" && git config --global user.email "${GIT_USEREMAIL}"

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh
RUN chmod +x /entrypoint.sh
