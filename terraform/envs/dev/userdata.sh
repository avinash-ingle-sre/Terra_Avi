#!/usr/bin/env bash
set -euxo pipefail
if command -v apt-get >/dev/null 2>&1; then
apt-get update -y
apt-get install -y nginx
HTML="/var/www/html/index.html"
else
yum update -y || true
amazon-linux-extras install nginx1 -y || true
yum install -y nginx || true
HTML="/usr/share/nginx/html/index.html"
fi
systemctl enable nginx
echo "Deployed via Terraform on $(hostname)" > "$HTML"
systemctl start nginx
