
#if your using centos then enable below command 
sudo setenforce 0

setupOrdererCA(){

	echo "Setting Orderer CA"
	docker-compose -f docker-compose-ca-orderer.yaml  up -d
}

setupOrg1CA(){
	echo "Setting Org1 CA"
	docker-compose -f docker-compose-ca-org1.yaml up -d 
}

setupOrg2CA(){
	echo "Setting Org2 CA"
	docker-compose -f docker-compose-ca-org2.yaml  up -d
}

setupOrdererCA
sleep 10
setupOrg1CA
sleep 10
setupOrg2CA
