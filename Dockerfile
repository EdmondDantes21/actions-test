FROM alpine:latest

# --- Layer 1: The expensive layer to cache ---
# This is a fixed layer that should be cached by the 'main' push
# It installs common packages which take a few seconds
RUN echo "Installing dependencies..." && \
    apk update && \
    apk add --no-cache curl python3 py3-pip && \
    echo "Dependencies installed."

# --- Layer 2: The changing layer (to test the speed of L1) ---
# This line will change frequently, but Layer 1 should still be hit.
# We use an ARG here just to ensure the build context is refreshed on the PR.
ARG BUILD_ID=1
RUN echo "Current build ID is ${BUILD_ID}."
CMD ["/bin/sh"]

#####