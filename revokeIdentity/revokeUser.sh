export CHANNEL_NAME="mychannel"
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

export FABRIC_CFG_PATH=${PWD}/../config
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../org1/crypto-config-ca/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt

export CORE_PEER_ADDRESS=localhost:7051

export FABRIC_CA_CLIENT_HOME=${PWD}/../org1/crypto-config-ca/peerOrganizations/org1.example.com/
export CORE_PEER_MSPCONFIGPATH=${PWD}/../org1/crypto-config-ca/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp

generateCRL(){

		fabric-ca-client revoke -e user1 --gencrl --tls.certfiles ${PWD}/../org1/fabric-ca/org1/tls-cert.pem
		base64 -i ${PWD}/../org1/crypto-config-ca/peerOrganizations/org1.example.com/msp/crls/crl.pem | tr -d '\n'  >  base64Cert
}

getConfig(){
        peer channel fetch config config_block.pb -o orderer.example.com  -c $CHANNEL_NAME --tls --cafile $ORDERER_CA

}
convertBlockToJSON(){
        configtxlator proto_decode --input config_block.pb --type common.Block | jq .data.data[0].payload.data.config > config.json
}

revokeUser(){


	jq --arg CRL $(cat base64Cert) '.channel_group.groups.Application.groups.Org1MSP.values.MSP.value.config.revocation_list? += [$CRL]' config.json > modified_config.json

}

computeDelta(){

        configtxlator proto_encode --input config.json --type common.Config --output config.pb

        configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb

        configtxlator compute_update --channel_id $CHANNEL_NAME --original config.pb --updated modified_config.pb --output config_update.pb
}

convertConfigDeltaToJSON(){

        configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate --output config_update.json

	echo '{"payload":{"header":{"channel_header":{"channel_id":"mychannel", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json

        configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb

}
signEnvolope(){

        peer channel signconfigtx -f config_update_in_envelope.pb
}

updateChannel(){
        peer channel update -f config_update_in_envelope.pb -c $CHANNEL_NAME -o localhost:7050  --tls --cafile $ORDERER_CA 
}


generateCRL

export CORE_PEER_MSPCONFIGPATH=${PWD}/../org1/crypto-config-ca/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
#here we are performing admin operation so we are expoerting admin identity.
getConfig
convertBlockToJSON
revokeUser
computeDelta
convertConfigDeltaToJSON
signEnvolope
updateChannel

