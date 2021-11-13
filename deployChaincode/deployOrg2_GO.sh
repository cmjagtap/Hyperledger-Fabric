#!/usr/bin/env bash

chaincodeInfo() {
  export CHANNEL_NAME="mychannel"
  export CC_RUNTIME_LANGUAGE="golang"
  export CC_VERSION="1"
  export CC_SRC_PATH=../chaincodes/golang
  export CC_NAME="fabcargo"
  export CC_SEQUENCE="1"

}
preSetupGO() {
  echo Vendoring Go dependencies ...
  pushd ../chaincodes/golang
  GO111MODULE=on go mod vendor
  popd
  echo Finished vendoring Go dependencies
}

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG2_CA=${PWD}/../org2/crypto-config-ca/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/../config

setGlobalsForPeer0Org2() {
  export CORE_PEER_LOCALMSPID="Org2MSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
  export CORE_PEER_MSPCONFIGPATH=${PWD}/../org2/crypto-config-ca/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
  export CORE_PEER_ADDRESS=localhost:9051
}

packageChaincode() {

  rm -rf ${CC_NAME}.tar.gz

  peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${CC_VERSION}

}

installChaincode() {

  peer lifecycle chaincode install ${CC_NAME}.tar.gz

}

queryInstalled() {

  peer lifecycle chaincode queryinstalled >&log.txt

  cat log.txt

  PACKAGE_ID=$(sed -n "/${CC_NAME}_${CC_VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)

  echo PackageID is ${PACKAGE_ID}
}
approveForMyOrg2() {

  peer lifecycle chaincode approveformyorg -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} --init-required

}

checkCommitReadyness() {

  peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --sequence ${CC_SEQUENCE} --version ${CC_VERSION} --init-required --output json

}

insertTransaction() {

  peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA -c '{"function": "createCar", "Args":["CAR102","Audi","R8","Black", "CM"]}'

  sleep 2
}
readTransaction() {
  echo "Reading a transaction"

  # Query all cars

  peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

  # Query Car by Id
  peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "queryCar","Args":["CAR0"]}'
}

lifecycleCommands() {
  packageChaincode
  sleep 2
  installChaincode
  sleep 2
  queryInstalled
  sleep 2
  approveForMyOrg2
  sleep 2
  checkCommitReadyness

}
getInstallChaincodes() {

  peer lifecycle chaincode queryinstalled

}
preSetupGO
chaincodeInfo
setGlobalsForPeer0Org2
lifecycleCommands
insertTransaction
readTransaction
getInstallChaincodes
