FROM alpine:latest

EXPOSE 3000

RUN addgroup -S theia && \
    adduser -S theia -G theia &&
    mkdir /theia-ide

COPY theia-package.json /theia-ide/package.json
COPY theia-bootstrap.sh /theia-ide/bootstrap.sh
WORKDIR /theia-ide

RUN apk add --no-cache make gcc g++ python2 openssh git asciidoctor nodejs npm && \
    npm install -g yarn && \
    yarn && \
    yarn theia build && \
    apk del make gcc g++ python2 && \
    chmod u+x bootstrap.sh

USER theia

ENTRYPOINT ["/theia-ide/bootstrap.sh"]