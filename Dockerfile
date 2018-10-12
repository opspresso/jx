# Dockerfile

FROM alpine

RUN apk add --no-cache bash curl

ENV VERSION v1.3.414
RUN curl -sL https://github.com/jenkins-x/jx/releases/download/${VERSION}/jx-linux-amd64.tar.gz | tar xz && \
    mv jx /usr/local/bin/jx

ENTRYPOINT ["bash"]
