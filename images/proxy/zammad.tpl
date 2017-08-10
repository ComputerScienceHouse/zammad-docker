server_tokens off;

upstream zammad {
    server ${ZAMMAD_HOSTNAME}:3000;
}

upstream websockets {
    server ${WEBSOCKETS_HOSTNAME}:6042;
}

server {
  listen 8080;
  server_name _;

  root /opt/zammad/public;
  client_max_body_size 50M;

  location ~ ^/(assets/|robots.txt|humans.txt|favicon.ico) {
      gzip_static on;
      expires max;
      add_header Cache-Control public;
  }

  location /ws {
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "Upgrade";
      proxy_set_header CLIENT_IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_read_timeout 86400;
      proxy_pass http://websockets;
  }

  location / {
      try_files $uri @zammad;
  }

  location @zammad {
      proxy_set_header Host $http_host;
      proxy_set_header CLIENT_IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_read_timeout 180;
      proxy_pass http://zammad;

      gzip on;
      gzip_types text/plain text/xml text/css image/svg+xml application/javascript application/x-javascript application/json application/xml;
      gzip_proxied any;
  }
}
