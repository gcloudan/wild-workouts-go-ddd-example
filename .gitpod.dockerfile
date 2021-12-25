FROM gitpod/workspace-full

RUN sudo apt-get update && sudo apt-get install -y terraform && sudo rm -rf /var/lib/apt/lists/*

RUN curl https://sdk.cloud.google.com | bash