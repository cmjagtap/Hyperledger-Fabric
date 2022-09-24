#!/usr/bin/env bash

#if your using centos then enable below command
sudo setenforce 0

removeOrdererCA() {

  echo "Removing Orderer CA"
  docker-compose -f ./orderer/ca-orderer.yaml down -v

}
removeOrg1CA() {

  echo "Removing Org1 CA"
  docker-compose -f ./org1/ca-org1.yaml down -v

}
removeOrg2CA() {

  echo "Removing Org2 CA"
  docker-compose -f ./org2/ca-org2.yaml down -v

}
removeOrderers() {
  echo "Removing orderers "
  docker-compose -f ./orderer/docker-compose-orderer.yaml down -v
}
removeOrg1() {

  echo "Removing Org1 Peers"
  docker-compose -f ./org1/docker-compose-peer.yaml down -v
}
removeOrg2() {
  echo "Removing Org1 Peers"
  docker-compose -f ./org2/docker-compose-peer.yaml down -v
}
removeExplorer() {
  echo "Removing explorer"
  cd explorer
  docker-compose down -v
  cd ..
}
removeGrafanaPrometheus() {
  echo "Removing Grafana and Prometheus"
  cd monitoring
  docker-compose down -v
  cd ..
}
removeOrdererCA
removeOrg1CA
removeOrg2CA
removeOrderers
removeOrg1
removeOrg2
removeExplorer
removeGrafanaPrometheus
echo "Removing crypto CA material"
rm -rf ./orderer/fabric-ca
rm -rf ./org1/fabric-ca
rm -rf ./org2/fabric-ca
rm -rf ./orderer/crypto-config-ca
rm -rf ./org1/crypto-config-ca
rm -rf ./org2/crypto-config-ca
rm -rf ./org1/Org1MSPanchors.tx
rm -rf ./org2/Org2MSPanchors.tx
rm -rf ./orderer/genesis.block
rm -rf ./orderer/mychannel.tx
rm -rf ./org1/mychannel.tx
rm -rf ./org1/mychannel.block
rm -rf ./org2/mychannel.tx
rm -rf ./org2/mychannel.block
rm -rf ./explorer/dockerConfig/crypto-config
rm -rf ./deployChaincode/*.tar.gz
rm -rf ./deployChaincode/node_modules
rm -rf ./deployChaincode/log.txt
rm -rf ./deployChaincode/npm-debug.log
rm -rf ./revokeIdentity/config*  ./revokeIdentity/modi* ./revokeIdentity/base64Cert
