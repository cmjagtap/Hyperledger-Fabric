orgname=OrdererOrg
channel=sys-channel  #system-channel id.if you didn't created system channel then by default it gets created with testchainid name
port=7050
domain=orderer.example.com

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export CORE_PEER_TLS_CERT_FILE=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
export CORE_PEER_TLS_KEY_FILE=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key
export CORE_PEER_LOCALMSPID=OrdererMSP
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/../orderer/crypto-config-ca/ordererOrganizations/example.com/users/Admin@example.com/msp
export CORE_PEER_ADDRESS=$domain:$port
sudo apt install jq

generateOrg3Config(){
        configtxgen -printOrg Org3MSP > org3.json
}
getConfig(){
        peer channel fetch config sys_config_block.pb -o $domain:$port  -c $channel --tls --cafile $ORDERER_CA

}
convertBlockToJSON(){
        configtxlator proto_decode --input sys_config_block.pb --type common.Block | jq .data.data[0].payload.data.config > sys_config.json
}
addOrg(){
        jq -s '.[0] * {"channel_group":{"groups":{"Consortiums":{"groups": {'SampleConsortium': {"groups": {Org3MSP:.[1]}}}}}}}' sys_config.json org3.json > modified_config.json
}
computeDelta(){

        configtxlator proto_encode --input sys_config.json --type common.Config --output sys_config.pb
    
        configtxlator proto_encode --input modified_config.json --type common.Config --output modified_config.pb

        configtxlator compute_update --channel_id $channel  --original sys_config.pb --updated modified_config.pb --output config_update.pb
}

convertConfigDeltaToJSON(){

        configtxlator proto_decode --input config_update.pb --type common.ConfigUpdate | jq . > config_update.json
          
        echo '{"payload":{"header":{"channel_header":{"channel_id":"sys-channel", "type":2}},"data":{"config_update":'$(cat config_update.json)'}}}' | jq . > config_update_in_envelope.json

        configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.pb

}

updateSystemChannel(){
        peer channel update -f config_update_in_envelope.pb -c $channel -o $domain:$port  --tls --cafile $ORDERER_CA 
}

export FABRIC_CFG_PATH=$PWD
generateOrg3Config
export FABRIC_CFG_PATH=$PWD/../config
getConfig
convertBlockToJSON
addOrg
computeDelta
convertConfigDeltaToJSON
updateSystemChannel