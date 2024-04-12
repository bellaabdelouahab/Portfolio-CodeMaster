apt update
apt install nginx
echo 'server {

    listen               443 ssl;

    ssl_certificate      /etc/ssl/cert.crt;
    ssl_certificate_key  /etc/ssl/private.key;

    server_name codemaster.ninja;

    root /var/www/html/build;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:8000/api;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location /uploads {
        proxy_pass http://localhost:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
server {
    listen 80;
    server_name codemaster.ninja;
    return 301 https://$server_name$request_uri;
}
' > /etc/nginx/sites-enabled/app

unlink /etc/nginx/sites-enabled/default

systemctl restart nginx

systemctl enable nginx

ufw allow 'Nginx HTTP'

nginx -t 


# install git
sudo apt install git


# install nodejs
sudo apt install nodejs

# install npm
sudo apt install npm

# install pm2 express nodemon 
sudo npm install pm2 express nodemon -g



# Configure git
git config --global user.name "Bella Abdelouahab"
git config --global user.email "abdobella977@gmail.com"


# Create a directory to hold the production code
mkdir /root/production
git init /root/production


# Create a bare repository
mkdir /root/production/.git
git init --bare /root/production/.git

# Create a post-receive hook
echo '#!/bin/sh
git --work-tree=/root/production/ --git-dir=/root/production/.git checkout -f

cd /root/production


echo "copy the folder /app/public from the container to the host" # note the service name in docker-compose is backend-api
docker cp $(docker-compose ps -q backend-api):/app/public /root/production/server/

echo "turn of previous container to save resource"
docker-compose down


# updating submodules
# make sure the repo is public
git --work-tree=/root/production/ --git-dir=/root/production/.git submodule update --init --recursive

echo "Installing dependencies and building the react app"

cd /root/production/client
npm install

npm run build

echo "serving react app"

rm -r /var/www/html/build

# copy the build folder to the nginx directory
cp -r /root/production/client/build /var/www/html

cd /root/production/

echo "Starting the server and the database"


docker-compose build
docker-compose up -d


echo "Restarting the pm2 process manager to serve the server and the database"

pm2 restart all


echo "Deployed successfully"

' > /root/production/.git/hooks/post-receive

chmod a+x /root/production/.git/hooks/post-receive

# done