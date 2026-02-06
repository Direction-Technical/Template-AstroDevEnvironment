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

if [ -n "$GIT_USERNAME" ] && [ -n "$GIT_USEREMAIL" ]; then
  echo "Configuring git with provided ${GIT_USERNAME} and ${GIT_USEREMAIL}..."
  git config --global user.name "${GIT_USERNAME}" 
  git config --global user.email "${GIT_USEREMAIL}"
else
  echo "GIT_USERNAME or GIT_USEREMAIL not set. Skipping git configuration."
fi

# Keep the container running
tail -f /dev/null
