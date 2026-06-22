#!/bin/bash

echo "Updating packages..."
sudo apt update

echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh

echo "Enabling Tailscale service..."
sudo systemctl enable tailscaled
sudo systemctl start tailscaled

echo "Enabling IP forwarding..."
echo "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/99-tailscale.conf
echo "net.ipv6.conf.all.forwarding = 1" | sudo tee -a /etc/sysctl.d/99-tailscale.conf

sudo sysctl --system

echo "Configuring automatic restart..."
sudo mkdir -p /etc/systemd/system/tailscaled.service.d

cat <<EOF | sudo tee /etc/systemd/system/tailscaled.service.d/restart.conf
[Service]
Restart=always
RestartSec=5
EOF

sudo systemctl daemon-reload
sudo systemctl restart tailscaled

echo ""
echo "==========================================="
echo "Run the following command to authenticate:"
echo ""
echo "sudo tailscale up --advertise-exit-node"
echo ""
echo "Open the login URL shown in your browser."
echo "Approve the Exit Node in the Tailscale dashboard."
echo "==========================================="



# curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/tailscale-setup/main/setup-tailscale.sh -o setup-tailscale.sh

# chmod +x setup-tailscale.sh

# sudo ./setup-tailscale.sh
