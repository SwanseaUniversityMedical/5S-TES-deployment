#!/usr/bin/env bash
set -e

echo "Funnel + S3 Installer"

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


# ---- Login to S3 TRE ----

echo "Configuring S3 client..."

mc alias set tre-s3 http://localhost:9002 s3-tre s3-tre-pass || {
    echo "ERROR: Unable to connect to S3 TRE."
    echo "Make sure S3 TRE is running at http://localhost:9002"
    exit 1
}


# ---- Create Access Keys ----

echo "Fetching S3 TRE Access Key..."

SA_JSON=$(mc admin user svcacct add tre-s3 s3-tre --json)

ACCESS_KEY=$(echo "$SA_JSON" | grep -o '"accessKey":"[^"]*"' | cut -d'"' -f4)
SECRET_KEY=$(echo "$SA_JSON" | grep -o '"secretKey":"[^"]*"' | cut -d'"' -f4)



# ---- Install Funnel ----

echo "Checking for Funnel installation..."

FUNNEL_VERSION="v0.11.12"
FUNNEL_DEST="$HOME/.local/bin"

export PATH="$FUNNEL_DEST:$PATH"

CURRENT_FUNNEL_VERSION=""
if command -v funnel &>/dev/null; then
    CURRENT_FUNNEL_VERSION="$(funnel version 2>/dev/null | awk '/version:/ {print "v"$2; exit}')"
fi

if [[ "$CURRENT_FUNNEL_VERSION" != "$FUNNEL_VERSION" ]]; then
    echo "Installing Funnel $FUNNEL_VERSION..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/calypr/funnel/develop/install.sh)" -- "$FUNNEL_VERSION" "$FUNNEL_DEST"
else
    echo "Funnel $FUNNEL_VERSION is already installed."
fi


# ---- Create Funnel config.yml ----

FUNNEL_WORK_DIR="./funnel-work-dir"

echo "Creating funnel-config.yml..."

cat <<EOF > "./config/funnel-config.yml"
GenericS3:
  - Disabled: false
    Endpoint: "localhost:9002"
    Key: "$ACCESS_KEY"
    Secret: "$SECRET_KEY"
    Region: "us-east-1"

Worker:
  WorkDir: "$FUNNEL_WORK_DIR"

EOF


# ---- Run Funnel Server ----

echo "Starting Funnel..."
cd ./config
funnel server run -c funnel-config.yml