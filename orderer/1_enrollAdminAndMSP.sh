#!/usr/bin/env bash

setupOrdererCA() {

  echo "Setting Orderer CA"
  docker-compose -f ca-orderer.yaml up -d
  sleep 10
  mkdir -p crypto-config-ca/ordererOrganizations/example.com
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/ordererOrganizations/example.com
}
enrollCAAdmin() {
  echo
  echo "Enroll the CA admin"
  echo

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2
}
nodeOrgnisationUnit() {
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml
  sleep 2
}
registerUsers() {
  echo
  echo "Register orderer"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  echo
  echo "Register orderer2"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer2 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  echo
  echo "Register orderer3"
  echo

  fabric-ca-client register --caname ca-orderer --id.name orderer3 --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  echo
  echo "Register the orderer admin"
  echo

  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers

}
orderer1MSP() {

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

}
orderer2MSP() {
  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls --enrollment.profile tls --csr.hosts orderer2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  # mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts
  # cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer2.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

}
orderer3MSP() {
  # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls --enrollment.profile tls --csr.hosts orderer3.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer3.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

}
adminMSP() {
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/users
  mkdir -p crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/example.com/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}
setupOrdererCA
enrollCAAdmin
nodeOrgnisationUnit
registerUsers
orderer1MSP
orderer2MSP
orderer3MSP
adminMSP
