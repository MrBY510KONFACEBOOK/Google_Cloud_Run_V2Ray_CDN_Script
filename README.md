# Google Cloud Run V2Ray CDN Script

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue)](https://www.docker.com/)

A lightweight, automated script to deploy a V2Ray VLESS server on Google Cloud Run (or any Docker-supported environment) using Alpine Linux. This project aims to provide a fast, secure, and easy-to-deploy V2Ray instance behind a CDN.

## 🚀 Features

-   **Lightweight**: Built on `alpine:latest` for minimal footprint.
-   **Protocol**: Uses VLESS protocol for enhanced performance.
-   **Transport**: Configured with WebSocket (`ws`) stream settings, making it compatible with CDNs (like Cloudflare or Cloud Run).
-   **Automated Setup**: Dockerfile automatically fetches the latest V2Ray core.
-   **Configurable**: Easy-to-modify `config.json` for custom UUIDs and settings.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

-   [Docker](https://docs.docker.com/get-docker/) installed on your local machine or server.
-   [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) (Optional, if deploying to Google Cloud Run).
-   A basic understanding of V2Ray and networking.

## 🛠️ Installation & Usage

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Google_Cloud_Run_V2Ray_CDN_Script.git
cd Google_Cloud_Run_V2Ray_CDN_Script
```

### 2. Configuration

Open `config.json` and modify the default UUID to your own secure UUID. You can generate one using an online UUID generator or via command line (`uuidgen`).

```json
{
  "inbounds": [
    {
      "port": 8080,
      "settings": {
        "clients": [
          {
            "id": "YOUR_UUID_HERE"
          }
        ]
      }
    }
  ]
}
```

> [!IMPORTANT]
> The default port is set to `8080` to comply with Google Cloud Run's default container port. If you change this, make sure to update the `EXPOSE` instruction in the `Dockerfile` as well.

### 3. Build and Run with Docker

Build the Docker image:

```bash
docker build -t v2ray-cdn .
```

Run the container locally to test:

```bash
docker run -d -p 8080:8080 v2ray-cdn
```

### 4. Deploy to Google Cloud Run

If you have the Google Cloud SDK configured:

```bash
gcloud run deploy v2ray-service \
  --source . \
  --port 8080 \
  --allow-unauthenticated \
  --region us-central1
```

*Replace `us-central1` with your preferred region.*

## 📂 Project Structure

-   `Dockerfile`: Defines the build steps for the V2Ray container.
-   `config.json`: V2Ray configuration file.
-   `LICENSE`: GNU General Public License v3.0.
-   `README.md`: Project documentation.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the repository.
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`).
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4.  Push to the branch (`git push origin feature/AmazingFeature`).
5.  Open a Pull Request.

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.
