#!/usr/bin/env bash

setupOrg3CA() {
  echo "Setting Org3 CA"
  docker-compose -f ca-org3.yaml up -d

  sleep 10
  mkdir -p /crypto-config-ca/peerOrganizations/org3.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/peerOrganizations/org3.example.com/
}
createCertificatOrg3() {
  echo "Enroll the CA admin"

  fabric-ca-client enroll -u https://admin:adminpw@localhost:6054 --caname ca.org3.example.com --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem
}
nodeOrgUnits() {

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-6054-ca-org3-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/peerOrganizations/org3.example.com/msp/config.yaml

}
registerUsers() {
  echo
  echo "Register peer0"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  echo
  echo "Register peer1"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  echo
  echo "Register user"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

  echo
  echo "Register the org admin"
  echo

  fabric-ca-client register --caname ca.org3.example.com --id.name org3admin --id.secret org3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem

}
setupOrg3CA
createCertificatOrg3
sleep 2
nodeOrgUnits
sleep 2
registerUsers
