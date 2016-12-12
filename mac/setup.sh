#!/bin/bash

# Install dnsmasq
brew install dnsmasq

# Load dnsmasq on start
sudo cp $(brew list dnsmasq | grep /homebrew.mxcl.dnsmasq.plist$) /Library/LaunchDaemons/
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
dscacheutil -flushcache

# Add a resolver
sudo mkdir -p /etc/resolver
sudo tee /etc/resolver/.hasura.test > /dev/null <<EOF
nameserver 127.0.0.1
domain test
EOF

# use minikube ip in dnsmasq.conf
echo "address=/.hasura.test/$(minikube ip)" > dnsmasq.conf
sudo mv dnsmasq.conf /usr/local/etc/dnsmasq.conf

# restart dnsmasq
sudo launchctl stop homebrew.mxcl.dnsmasq
sudo launchctl start homebrew.mxcl.dnsmasq
