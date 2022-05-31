FROM golang:1.17-bullseye

RUN apt update && apt install git
WORKDIR /src/app
COPY test test
COPY ssh_config /root/.ssh/config
ENV GIT_SSH_COMMAND="ssh -i /src/app/test -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
RUN chmod 0600 test
# RUN git config --global url."git@github.com:".insteadOf "https://github.com/" 
RUN go env -w GOPRIVATE=github.com/ingenuity-build/*
## TODO(security) switch this for a proper download without PAT 
RUN git clone https://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:x-oauth-basic@github.com/Stride-Labs/interchain-queries.git 
RUN cp -r interchain-queries/* .
RUN rm -rf interchain-queries
RUN go mod download
RUN go build

RUN ln -s /src/app/interchain-queries /usr/local/bin
RUN adduser --system --home /icq --disabled-password --disabled-login icq -U 1000
USER icq
