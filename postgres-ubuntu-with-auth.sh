#retrive username and password
postgresAdmin=$1
postgresPassword=$2

#update and download postgres
sudo apt update
sudo apt-get -y install postgresql postgresql-contrib
sudo -i -u postgres
createUserstatement="CREATE USER $postgresAdmin WITH PASSWORD '$postgresPassword';"
sudo -u postgres psql -c "$createUserstatement"

# change to allow remote connection
sudo sed -i -e "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/10/main/postgresql.conf
sudo service postgresql restart
printf "%s\t%s\t\t%s\t\t%s\t\t%s\n" "host" "all" "all" "0.0.0.0/0" "md5" | sudo tee -a /etc/postgresql/10/main/pg_hba.conf
sudo service postgresql restart

# update firewall 
sudo ufw allow 22
sudo ufw allow 53
sudo ufw allow 5432/tcp
sudo ufw default deny incoming 
echo "y" | sudo ufw enable
