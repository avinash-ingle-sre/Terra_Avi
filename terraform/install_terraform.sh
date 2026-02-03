#!/usr/bin/env bash
set -euo pipefail

log() { echo "[INFO] $*"; }
err() { echo "[ERROR] $*" >&2; }

# 1) Update apt and install prerequisites
log "Updating apt and installing prerequisites..."
sudo apt update -y
sudo apt install -y curl unzip ca-certificates gnupg lsb-release wget

# 2) Setup HashiCorp official APT repository (recommended for Ubuntu)
log "Adding HashiCorp APT repository..."
if [ ! -f /usr/share/keyrings/hashicorp-archive-keyring.gpg ]; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
fi

UBU_CODENAME="$(. /etc/os-release && echo "${VERSION_CODENAME}")"
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBU_CODENAME} main" \
  | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

# 3) Install Terraform (latest from repo)
log "Installing Terraform from HashiCorp repo..."
sudo apt update -y
sudo apt install -y terraform

# 4) Verify Terraform install
log "Verifying Terraform..."
if ! command -v terraform >/dev/null 2>&1; then
  err "Terraform not found in PATH after install."
  exit 1
fi
terraform -version

# 5) Install AWS CLI (via apt) and verify
log "Installing AWS CLI..."
sudo apt install -y awscli
aws --version || { err "AWS CLI verification failed"; exit 1; }

# 6) Optional: Quick network and cert sanity check
log "Checking network/certs to releases.hashicorp.com..."
curl -I https://releases.hashicorp.com >/dev/null 2>&1 && log "Network OK" || log "Network check skipped/failed (not critical)"

log "All set. Terraform and AWS CLI are installed and ready."
log "Next steps:"
echo "  1) aws configure"
echo "  2) terraform -version"
echo "  3) Proceed with your Terraform project (init/plan/apply)"

