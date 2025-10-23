#!/bin/bash

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add /root/.ssh/id_ed25519

cd /workspace

# Clone repo only if .git is missing
if [ ! -d "./repo/.git" ]; then
  echo "Cloning repo: $REPO_URL"
  git clone "$REPO_URL" ./repo
  cd ./repo
else
  echo "Repo already present. Skipping clone."
  cd repo
fi

if [ -z "$(ls -A astro-app)" ]; then
    echo "This is a fresh repo. Initializing Astro project with Citrus template..."
    create-astro astro-app \
      --template artemkutsan/astro-citrus \
      --yes \
      --install \
      --no-git

    echo "... project initialized."
    cd astro-app
else
    echo "The 'astro-app' directory is not empty. Skipping Astro project creation."
    cd astro-app
    
fi

npm install

# Keep the container running
echo "Starting dev server."
npm run dev
