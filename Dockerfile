ARG RUBY_VERSION
ARG STATIQUE_VERSION

FROM ruby:$RUBY_VERSION-alpine AS build
ARG STATIQUE_VERSION

# RUN gem install statique --version $STATIQUE_VERSION
WORKDIR /pkg
COPY pkg/statique-$STATIQUE_VERSION.gem .
RUN apk add --no-cache --update --virtual .build-deps build-base libffi-dev && \
    gem install /pkg/statique-$STATIQUE_VERSION.gem && rm -rf /root/.local/share/gem && rm -rf /usr/local/bundle/cache/*.gem && \
    apk del .build-deps

FROM ruby:$RUBY_VERSION-alpine
COPY --from=build /usr/local/bundle /usr/local/bundle

LABEL io.whalebrew.config.environment '["RACK_ENV"]'
LABEL io.whalebrew.config.ports '["3000:3000"]'

ENTRYPOINT ["/usr/local/bundle/bin/statique"]
