#!/bin/sh

# Update Near Node to actual commit automatically

# STOP SERVICE NEARD
sudo systemctl stop neard
# REMOVE OLD DB
rm ~/.near/data/*
# BUILD NEW COMMIT
export NEAR_ENV=shardnet
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc
cd ~/nearcore
git fetch
commiturl=https://raw.githubusercontent.com/near/stakewars-iii/main/commit.md
COMMIT=$(curl ${commiturl})
git checkout $COMMIT
cargo build -p neard --release --features shardnet
#  DOWNLOAD NEW GENESIS AND CONFIG
cd ~/.near
rm config.json
rm genesis.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
#START SERVICE NEARD
sudo systemctl start neard
