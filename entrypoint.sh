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
elif [ -n "$ASTRO_TEMPLATE" ]; then
  echo "This is a fresh repo. Initializing Astro project with $ASTRO_TEMPLATE template..."
    npx create-astro repo \
      --template $ASTRO_TEMPLATE \
      --yes \
      --install
else
  echo "This is a fresh repo. Initializing Astro project with default template..."
    npx create-astro repo \
      --yes \
      --install
fi

cd repo
echo "... project initialized in $PWD."

# Keep the container running
tail -f /dev/null
