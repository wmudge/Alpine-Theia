ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-alpine

RUN apk add --no-cache make gcc g++ python

WORKDIR /home/theia
ADD package.json ./package.json

ARG GITHUB_TOKEN

RUN yarn --pure-lockfile && \
    NODE_OPTIONS="--max_old_space_size=4096" yarn theia build && \
    yarn --production && \
    yarn autoclean --init && \
    echo *.ts >> .yarnclean && \
    echo *.ts.map >> .yarnclean && \
    echo *.spec.* >> .yarnclean && \
    yarn autoclean --force && \
    yarn cache clean

FROM node:${NODE_VERSION}-alpine

# See : https://github.com/theia-ide/theia-apps/issues/34
RUN addgroup theia && \
    adduser -G theia -s /bin/sh -D theia;
RUN chmod g+rw /home && \
    mkdir -p /home/project && \
    chown -R theia:theia /home/theia && \
    chown -R theia:theia /home/project && \
    mkdir -p /home/ssh-keys && \
    chown -R theia:theia /home/ssh-keys;

RUN apk add --no-cache git openssh bash bash-completion asciidoctor

ENV HOME /home/theia
WORKDIR /home/theia

COPY --from=0 --chown=theia:theia /home/theia /home/theia

ADD bootstrap.sh /home/theia/bootstrap.sh
ADD bashrc /home/theia/.bashrc

RUN chmod 755 /home/theia/bootstrap.sh

EXPOSE 3000

ENV SHELL /bin/bash
ENV USE_LOCAL_GIT true

USER theia

#ENTRYPOINT [ "node", "/home/theia/src-gen/backend/main.js", "/home/project", "--hostname=0.0.0.0" ]
ENTRYPOINT [ "/home/theia/bootstrap.sh" ]
