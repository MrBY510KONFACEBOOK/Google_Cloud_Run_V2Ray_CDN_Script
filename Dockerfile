FROM alpine:latest

# Install dependencies (minimal set for Cloud Run)
RUN apk add --no-cache ca-certificates && \
    mkdir -p /etc/xray /app

# Download Xray-core (smaller than V2Ray)
RUN wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip -O /tmp/xray.zip && \
    unzip /tmp/xray.zip -d /app && \
    rm /tmp/xray.zip /app/geoip.dat /app/geosite.dat && \
    chmod +x /app/xray && \
    mv /app/xray /app/v2ray  # For entrypoint compatibility

# Copy config (will be replaced in Cloud Run)
COPY config.json /app/

# Cloud Run requires listening on $PORT (default 8080)
ENV PORT 8080
EXPOSE $PORT

# Run as non-root (Cloud Run requirement)
USER 1000

WORKDIR /app
ENTRYPOINT ["./v2ray", "run"]
