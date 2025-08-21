# Multi-stage build for security and optimization
FROM alpine:3.18 AS builder

# Install dependencies and download V2Ray
RUN apk add --no-cache curl unzip ca-certificates && \
    curl -L -o /tmp/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip /tmp/v2ray.zip -d /tmp/v2ray && \
    chmod +x /tmp/v2ray/v2ray

# Final stage - minimal runtime image
FROM alpine:3.18

# Create non-root user for security
RUN addgroup -g 1000 v2ray && \
    adduser -D -u 1000 -G v2ray v2ray

# Install runtime dependencies
RUN apk add --no-cache ca-certificates tzdata

# Copy V2Ray binaries and data files
COPY --from=builder /tmp/v2ray/v2ray /usr/local/bin/v2ray
COPY --from=builder /tmp/v2ray/geoip.dat /usr/local/share/v2ray/
COPY --from=builder /tmp/v2ray/geosite.dat /usr/local/share/v2ray/

# Create config directory and copy configuration
RUN mkdir -p /etc/v2ray && chown -R v2ray:v2ray /etc/v2ray
COPY --chown=v2ray:v2ray config.json /etc/v2ray/config.json

# Set working directory
WORKDIR /etc/v2ray

# Expose port (adjust based on your config.json)
EXPOSE 8080

# Switch to non-root user
USER v2ray

# Health check for AWS services
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/ || exit 1

# Start V2Ray
ENTRYPOINT ["/usr/local/bin/v2ray", "run", "-config", "/etc/v2ray/config.json"]
