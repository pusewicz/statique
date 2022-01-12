ARG RUBY_VERSION
ARG STATIQUE_VERSION

FROM ruby:$RUBY_VERSION-alpine AS build
ARG STATIQUE_VERSION

# RUN gem install statique --version $STATIQUE_VERSION
WORKDIR /pkg
COPY pkg/statique-$STATIQUE_VERSION.gem .
RUN gem install /pkg/statique-$STATIQUE_VERSION.gem && rm -rf /root/.local/share/gem && rm -rf /usr/local/bundle/cache/*.gem

FROM ruby:$RUBY_VERSION-alpine
COPY --from=build /usr/local/bundle /usr/local/bundle

ENTRYPOINT ["/usr/local/bundle/bin/statique"]
