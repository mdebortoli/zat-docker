FROM ruby:2.7-alpine

# Update the package repository and install runtime dependencies
RUN apk update && apk add --no-cache \
       libxml2 \
       libxslt \
       nodejs

# Install build dependencies, the zendesk_apps_tools gem, and remove build dependencies
RUN apk add --no-cache --virtual .build-deps \
       build-base \
       libxml2-dev \
       libxslt-dev \
    && gem install zendesk_apps_tools \
    && apk del .build-deps

WORKDIR /data

CMD ["tail", "-f", "/dev/null"]
