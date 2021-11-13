#!/usr/bin/env bash

setupOrg1CA() {

  echo "Setting Org1 CA"
  docker-compose -f ca-org1.yaml up -d

  sleep 10
  mkdir -p crypto-config-ca/peerOrganizations/org1.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/peerOrganizations/org1.example.com/
}

#here we are generating crypto material insted of cryptogen we are using CA
createcertificatesForOrg1() {
  echo
  echo "Enroll the CA admin"
  echo

  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.org1.example.com --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
}
#Orgnisation units will be useful in future
nodeOrgnisationUnit() {
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-org1-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/peerOrganizations/org1.example.com/msp/config.yaml

}
registerUsers() {
  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register peer1"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.org1.example.com --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org1/tls-cert.pem
}
setupOrg1CA
createcertificatesForOrg1
sleep 2
nodeOrgnisationUnit
sleep 2
registerUsers
