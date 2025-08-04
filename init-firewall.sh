#!/bin/bash
# Initialize firewall rules for the development environment

echo "Initializing firewall rules..."

# Allow all traffic for development (you can customize this for production)
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Flush existing rules
iptables -F
iptables -X

# Allow established connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow loopback
iptables -A INPUT -i lo -j ACCEPT

# Allow SSH (if needed)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow development ports
iptables -A INPUT -p tcp --dport 3000 -j ACCEPT  # Node.js
iptables -A INPUT -p tcp --dport 8000 -j ACCEPT  # FastAPI
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT  # General web
iptables -A INPUT -p tcp --dport 8888 -j ACCEPT  # Jupyter

echo "Firewall rules initialized successfully!" 