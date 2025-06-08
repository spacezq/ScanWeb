#!/bin/bash

set -euo pipefail

# Set Go environment variables
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

log() {
    echo "[+] $1"
}

error_exit() {
    echo "[ERROR] $1" >&2
    exit 1
}

log "Updating system packages..."
sudo apt update && sudo apt upgrade -y

log "Installing dependencies..."
sudo apt install -y git curl wget parallel unzip dos2unix golang-go

# Function to install Go-based tools if not already installed
install_go_tool() {
    local pkg=$1
    local bin_name=$2

    if ! command -v "$bin_name" &> /dev/null; then
        log "Installing $bin_name..."
        go install -v "$pkg@latest"
        cp "$GOPATH/bin/$bin_name" /usr/local/bin/
    else
        log "$bin_name already installed."
    fi
}

# Function to install tools available via apt package manager
install_apt_tool() {
    local tool=$1
    if ! command -v "$tool" &> /dev/null; then
        log "Installing $tool via apt..."
        sudo apt install -y "$tool"
    else
        log "$tool already installed."
    fi
}

# Install tools via apt
install_apt_tool subfinder
install_apt_tool assetfinder
install_apt_tool amass
install_apt_tool waymore

# Install Findomain if not installed
if ! command -v findomain &> /dev/null; then
    log "Installing Findomain..."
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux.zip
    unzip findomain-linux.zip
    chmod +x findomain
    sudo mv findomain /usr/local/bin/
    rm findomain-linux.zip
else
    log "Findomain already installed."
fi

# Install Go tools
install_go_tool github.com/projectdiscovery/httpx/cmd/httpx httpx
install_go_tool github.com/projectdiscovery/katana/cmd/katana katana
install_go_tool github.com/projectdiscovery/nuclei/v2/cmd/nuclei nuclei
install_go_tool github.com/ffuf/ffuf ffuf
install_go_tool github.com/tomnomnom/qsreplace qsreplace

log "All tools installed or already present."
