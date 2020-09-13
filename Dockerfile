# https://hub.docker.com/_/node/
FROM node:8-onbuild

# use debug to troubleshoot
ENV LOG_LEVEL=error
# Required env settings determined by GitHub App
ENV APP_ID=1234
ENV WEBHOOK_SECRET=development
ENV WEBHOOK_PROXY_URL=https://localhost:3000/
# ENV PRIVATE_KEY="someprivatestring"

# see https://github.com/nodejs/docker-node/blob/e3ec2111af089e31321e76641697e154b3b6a6c3/docs/BestPractices.md#global-npm-dependencies
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin

# Lets install our app into /home/node
COPY . /home/node/probot-hello
RUN chown -R node:node /home/node/probot-hello

# setup our app
# non-root user  https://github.com/nodejs/docker-node/blob/e3ec2111af089e31321e76641697e154b3b6a6c3/docs/BestPractices.md#non-root-user
USER node

ARG SSH_PRIVATE_KEY
RUN mkdir /home/node/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /home/node/.ssh/id_rsa

RUN touch /home/node/.ssh/known_hosts
RUN ssh-keyscan github.com >> /home/node/.ssh/known_hosts

WORKDIR /home/node/probot-hello
RUN npm install
