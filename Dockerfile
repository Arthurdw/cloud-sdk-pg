FROM google/cloud-sdk:alpine

RUN apk add --no-cache postgresql-client

WORKDIR /workspace

CMD ["/bin/sh"]
