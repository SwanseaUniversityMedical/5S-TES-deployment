#!/usr/bin/env bash
set -e

echo "Funnel + MinIO Installer"

# ---- Detect Operating System ----

OS=$(uname -s)
ARCH=$(uname -m)

echo "Detected OS: $OS ($ARCH)"


# ---- Determine MinIO client URL ----

MC_URL=""

if [[ "$OS" == "Linux" ]]; then
    MC_URL="https://dl.min.io/client/mc/release/linux-amd64/mc"

elif [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        MC_URL="https://dl.min.io/client/mc/release/darwin-arm64/mc"
    else
        MC_URL="https://dl.min.io/client/mc/release/darwin-amd64/mc"
    fi
else
    echo "Unsupported OS: $OS"
    exit 1
fi


# ---- Install MinIO Client (mc) -----

if ! command -v mc &>/dev/null; then
    echo "Installing MinIO client (mc)..."
    echo "Download URL: $MC_URL"

    sudo curl -L "$MC_URL" -o /usr/local/bin/mc
    sudo chmod +x /usr/local/bin/mc
else
    echo "mc is already installed."
fi


# ---- Login to MinIO ----

echo "Configuring MinIO client alias..."

mc alias set tre-minio http://localhost:9002 minio minio123 || {
    echo "ERROR: Unable to connect to MinIO."
    echo "Make sure MinIO is running at http://localhost:9002"
    exit 1
}


# ---- Create Access Keys ----

echo "Creating new MinIO Access Key..."

SA_JSON=$(mc admin user svcacct add tre-minio minio --json)

ACCESS_KEY=$(echo "$SA_JSON" | grep -o '"accessKey":"[^"]*"' | cut -d'"' -f4)
SECRET_KEY=$(echo "$SA_JSON" | grep -o '"secretKey":"[^"]*"' | cut -d'"' -f4)

echo "Access Key: $ACCESS_KEY"
echo "Secret Key: $SECRET_KEY"


# ---- Install Funnel ----

echo "Checking for Funnel installation..."

if ! command -v funnel &>/dev/null; then
    echo "Installing Funnel..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohsu-comp-bio/funnel/refs/heads/develop/install.sh)" -- v0.11.7-rc.12
else
    echo "Funnel is already installed."
fi


# ---- Create Funnel config.yml ----

echo "Creating config.yml..."

cat <<EOF > config.yml
GenericS3:
  - Disabled: false
    Endpoint: "localhost:9002"
    Key: "$ACCESS_KEY"
    Secret: "$SECRET_KEY"
EOF

echo "config.yml created successfully."


# ---- Run Funnel Server ----

echo "Starting Funnel..."
funnel server run -c config.yml