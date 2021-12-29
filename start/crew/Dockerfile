FROM openliberty/open-liberty

ARG VERSION=1.0
ARG REVISION=SNAPSHOT

LABEL \
  org.opencontainers.image.authors="J Mulvey" \
  org.opencontainers.image.vendor="Open Liberty" \
  org.opencontainers.image.url="local" \
  org.opencontainers.image.source="https://github.com/jtmulvey/guide-mongodb-intro" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$REVISION" \
  vendor="Open Liberty" \
  name="crew" \
  version="$VERSION-$REVISION" \
  summary="The microservice from the Deploying microservices to OpenShift guide" \
  description="This image contains the crew microservice running with the Open Liberty runtime."

COPY --chown=1001:0 src/main/liberty/config /config/
COPY --chown=1001:0 target/guide-mongodb-intro.war /config/apps

RUN configure.sh