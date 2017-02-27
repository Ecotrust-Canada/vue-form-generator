FROM node:6

RUN npm install -g webpack
RUN mkdir -p /code/

# Here we will build node_modules folder and cache it for fast next runs.
WORKDIR /code/
ADD ./package.json /code/package.json
RUN node --stack-size=2000 /usr/local/lib/node_modules/npm/bin/npm-cli.js install
RUN npm cache clear

WORKDIR /code/

ENV DOCKER 1
