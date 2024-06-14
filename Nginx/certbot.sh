sudo apt install -y certbot
sudo apt install -y python3-certbot-nginx


sudo certbot certonly
#OR
sudo certbot --nginx

#Renew
sudo certbot renew
