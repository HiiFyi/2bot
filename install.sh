#!/bin/bash
set -e

usage() {
    echo "Usage: $0 [--apt-packages \"pkg1 pkg2...\"] [--pip-packages \"pkg1 pkg2...\"]"
    exit 1
}

APT_PACKAGES="nano"
PIP_PACKAGES="croniter python-dateutil apscheduler flask-socketio==5.5.1 eventlet==0.33.1 dnspython==2.2.1 asyncio gevent gunicorn flask==2.0.1 requests schedule supervisor aiofiles watchdog psutil python-dotenv python-socketio==5.12.0 python-engineio==4.11.0 Werkzeug==2.2.2"

echo "[INFO] Starting install.sh script"

while [[ $# -gt 0 ]]; do
    case $1 in
        --apt-packages)
            APT_PACKAGES="$2"
            echo "[INFO] Overriding APT packages to install: $APT_PACKAGES"
            shift 2
            ;;
        --pip-packages)
            PIP_PACKAGES="$2"
            echo "[INFO] Overriding PIP packages to install: $PIP_PACKAGES"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

if [ ! -z "$APT_PACKAGES" ]; then
    echo "[INFO] Updating apt repositories"
    apt-get update
    echo "[INFO] Installing apt packages: $APT_PACKAGES"
    echo "$APT_PACKAGES" | xargs apt-get install -y
    echo "[INFO] APT packages installed successfully"
fi

if [ ! -z "$PIP_PACKAGES" ]; then
    echo "[INFO] Checking for pip3"
    if ! command -v pip3 &> /dev/null; then
        echo "[INFO] pip3 not found, installing python3-pip"
        apt-get install -y python3-pip
    fi
    echo "[INFO] Installing pip packages: $PIP_PACKAGES"
    echo "$PIP_PACKAGES" | xargs pip3 install
    echo "[INFO] PIP packages installed successfully"
fi

echo "[INFO] install.sh script completed"
