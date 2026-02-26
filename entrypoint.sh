#!/bin/bash

# Start SSH agent
eval "$(ssh-agent -s)"

# Add SSH key to agent
ssh-add /root/.ssh/id_ed25519

git config --global user.name "${GIT_USERNAME}" 
git config --global user.email "${GIT_USEREMAIL}"
echo "Git user.name and user.email set to ${GIT_USERNAME} and ${GIT_USEREMAIL}."

cd /workspace

# Handle repo cloning or creation
if [ -d "./${PROJECT_NAME}/.git" ]; then
  echo "Repo already present. Skipping clone."
elif [ -n "$REPO_URL" ]; then
  echo "Cloning repo: $REPO_URL"
  git clone "$REPO_URL" ./${PROJECT_NAME}
elif [ -n "$ASTRO_TEMPLATE" ]; then
  echo "This is a fresh repo. Initializing Astro project with $ASTRO_TEMPLATE template..."
    npx create-astro ${PROJECT_NAME} \
      --template $ASTRO_TEMPLATE \
      --yes \
      --install
else
  echo "This is a fresh repo. Initializing Astro project with default template..."
    npx create-astro ${PROJECT_NAME} \
      --yes \
      --install
fi

cd ${PROJECT_NAME}
echo "... project initialized in $PWD."

# Keep the container running
tail -f /dev/null
