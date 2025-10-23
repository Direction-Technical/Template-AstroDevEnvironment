ARG NODE_VERSION=18
FROM node:${NODE_VERSION}

ENV PATH="$PATH:/usr/local/bin"

# Install Git, SSH, and create-astro globally
RUN apt-get update && apt-get install -y \
    git \
    openssh-client \
    curl \
    nano

# Install create-astro app
RUN npm install -g create-astro@latest \
  && echo "Installed create-astro at: $(which create-astro)"

# Create workspace
WORKDIR /workspace

# Copy SSH keys into container
COPY ssh/id_ed25519 /root/.ssh/id_ed25519
COPY ssh/id_ed25519.pub /root/.ssh/id_ed25519.pub
RUN chmod 600 /root/.ssh/id_ed25519 && chmod 644 /root/.ssh/id_ed25519.pub

# Add GitHub's host key to known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts && chmod 600 /root/.ssh/known_hosts

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
