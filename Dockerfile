ARG NODE_VERSION=20

FROM node:$NODE_VERSION

RUN apt update && apt upgrade -y
RUN apt install sudo git -y
RUN usermod -aG sudo node
RUN echo "node ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER node


