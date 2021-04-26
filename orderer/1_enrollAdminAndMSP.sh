  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in
  export FABRIC_CA_CLIENT_HOME=${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in

enrollCAAdmin()
{
  echo
  echo "Enroll the CA admin"
  echo

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
 sleep 2
}
nodeOrgnisationUnit()
{
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
    OrganizationalUnitIdentifier: orderer' >${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/config.yaml
  sleep 2
}
registerUsers()
{
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

  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in/orderers

}
orderer1MSP()
{

  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/msp --csr.hosts orderer.in --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2

  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls --enrollment.profile tls --csr.hosts orderer.in --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2

  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/msp/tlscacerts/tlsca.orderertest.in-cert.pem

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/tlscacerts/tlsca.orderertest.in-cert.pem

}
orderer2MSP()
{
  # -----------------------------------------------------------------------
  #  Orderer 2

  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/msp --csr.hosts orderer2.in --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
  sleep 2

  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer2:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls --enrollment.profile tls --csr.hosts orderer2.in --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/msp/tlscacerts/tlsca.orderertest.in-cert.pem

  # mkdir ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/tlscacerts
  # cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer2.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/tlscacerts/tlsca.orderertest.in-cert.pem

}
orderer3MSP()
{
 # ---------------------------------------------------------------------------
  #  Orderer 3
  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in

  echo
  echo "## Generate the orderer msp"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/msp --csr.hosts orderer3.in --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep  2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo

  fabric-ca-client enroll -u https://orderer3:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls --enrollment.profile tls --csr.hosts orderer3.in --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

 sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/ca.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/signcerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/server.crt
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/keystore/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/server.key

  mkdir ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/msp/tlscacerts
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/tls/tlscacerts/* ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/orderers/orderer3.in/msp/tlscacerts/tlsca.orderertest.in-cert.pem

}
adminMSP()
{
  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in/users
  mkdir -p crypto-config-ca/ordererOrganizations/orderertest.in/users/Admin@orderertest.in

  echo
  echo "## Generate the admin msp"
  echo

  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/users/Admin@orderertest.in/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem

  sleep 2
  cp ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/msp/config.yaml ${PWD}/crypto-config-ca/ordererOrganizations/orderertest.in/users/Admin@orderertest.in/msp/config.yaml

}
enrollCAAdmin
nodeOrgnisationUnit
registerUsers
orderer1MSP
orderer2MSP
orderer3MSP
adminMSP

