#!/bin/bash

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add /root/.ssh/id_ed25519

cd /workspace

# Handle repo cloning or creation
if [ -d "./repo/.git" ]; then
  echo "Repo already present. Skipping clone."
  cd ./repo
elif [ -n "$REPO_URL" ]; then
  echo "Cloning repo: $REPO_URL"
  git clone "$REPO_URL" ./repo
  cd ./repo
else
  echo "REPO_URL is not set. Creating repo directory and skipping clone."
  mkdir -p ./repo
  cd ./repo
fi

if [ -z "$(ls -A astro-app)" ]; then
    echo "This is a fresh repo. Initializing Astro project with Citrus template..."
    npx create-astro astro-app \
      --template artemkutsan/astro-citrus \
      --yes \
      --install \
      --no-git

    echo "... project initialized."
    cd astro-app
else
    echo "The \'astro-app\' directory is not empty. Skipping Astro project creation."
    cd astro-app
    
fi

# Keep the container running
tail -f /dev/null
