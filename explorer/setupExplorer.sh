#!/usr/bin/env bash

rm -rf dockerConfig/crypto-config

mkdir -p dockerConfig/crypto-config

cp -r ../orderer/crypto-config-ca/ordererOrganizations/ dockerConfig/crypto-config/
cp -r ../org1/crypto-config-ca/peerOrganizations/ dockerConfig/crypto-config/
cp -r ../org2/crypto-config-ca/peerOrganizations/ dockerConfig/crypto-config/
sleep 5
docker-compose up -d
sleep 10
docker ps -a
