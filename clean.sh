removeOrdererCA(){

	echo "Removing Ordere CA"
	docker-compose -f docker-compose-ca-orderer.yaml  down -v 

}
removeOrg1CA(){

	echo "Removing Org1 CA"
	docker-compose -f docker-compose-ca-org1.yaml down -v  

}
removeOrg2CA(){

	echo "Removing Org2 CA"
	docker-compose -f docker-compose-ca-org2.yaml  down -v

}

removeOrdererCA
sleep 10
removeOrg1CA
sleep 10
removeOrg2CA

echo "Removing crypto CA material"
rm -rf fabric-ca
