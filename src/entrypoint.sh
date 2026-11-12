#!/bin/sh
set -u
set -e
mkdir -p /tmp/client_body /tmp/proxy /tmp/fastcgi /tmp/uwsgi /tmp/scgi /config
cd /app/www/server
node index.js >/tmp/node.log 2>&1 &
cd /
cat > /tmp/nginx.conf <<'CONF'
worker_processes 1;
pid /tmp/nginx.pid;
events { worker_connections 1024; }
http {
  include /etc/nginx/mime.types;
  default_type application/octet-stream;
  access_log /tmp/access.log;
  client_body_temp_path /tmp/client_body;
  proxy_temp_path /tmp/proxy;
  fastcgi_temp_path /tmp/fastcgi;
  uwsgi_temp_path /tmp/uwsgi;
  scgi_temp_path /tmp/scgi;
  map $http_upgrade $connection_upgrade { default upgrade; '' close; }
  server {
    listen 8080;
    root /app/www/client;
    index index.html;
    location / { try_files $uri $uri/ /index.html; }
    location /server {
      proxy_pass http://127.0.0.1:3000;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      proxy_set_header Host $host;
    }
  }
}
CONF
exec nginx -c /tmp/nginx.conf -g 'error_log /tmp/error.log; daemon off;'
