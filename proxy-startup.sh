#!/bin/bash
sudo apt-get update
sudo apt-get install certbot python-certbot-nginx nginx -y
sudo tee /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name package-registry.serlo.org;

    location / {
        proxy_pass https://us-central1-serlo-assets.cloudfunctions.net/resolve/;
    }
}
EOF
sudo certbot --nginx -d package-registry.serlo.org --agree-tos -m jonas@serlo.org --non-interactive
