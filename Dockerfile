# Use a specific version of Alpine for better stability
FROM alpine:3.17

# Install dependencies for istioctl and kubectl
RUN apk --no-cache add \
    curl \
    ca-certificates \
    && update-ca-certificates

# Install istioctl version 1.22.0
RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.22.0 sh - && \
    mv istio-1.22.0/bin/istioctl /usr/local/bin/ && \
    rm -rf istio-1.22.0

# Install kubectl version 1.29.0 with proper checksum verification
RUN curl -LO "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/v1.29.0/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c - && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    rm kubectl.sha256

# Set the default entrypoint to sh
ENTRYPOINT ["sh"]