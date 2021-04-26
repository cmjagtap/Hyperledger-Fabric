#if your using centos then enable below command 
sudo setenforce 0

removeOrdererCA(){

	echo "Removing Ordere CA"
	docker-compose -f ./orderer/docker-compose-ca-orderer.yaml  down -v 

}
removeOrg1CA(){

	echo "Removing Org1 CA"
	docker-compose -f ./org1/docker-compose-ca-org1.yaml down -v  

}
removeOrg2CA(){

	echo "Removing Org2 CA"
	docker-compose -f ./org2/docker-compose-ca-org2.yaml  down -v

}

removeOrdererCA
removeOrg1CA
removeOrg2CA

echo "Removing crypto CA material"
rm -rf ./orderer/fabric-ca
rm -rf ./org1/fabric-ca
rm -rf ./org2/fabric-ca
rm -rf ./org1/crypto-config-ca
rm -rf ./org2/crypto-config-ca

