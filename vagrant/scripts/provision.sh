sudo apt-get -y update
sudo apt-get -y install git bash


rm -rf fiware-chanchan.git
git clone https://github.com/Bitergia/fiware-chanchan.git
cd fiware-chanchan/vagrant/scripts
bash setup-server.sh