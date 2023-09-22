# Server XRAY with XTLS-Reality in the docker container.
# Community https://github.com/XTLS

## 1 Prepare server to install
### 1.1 Performance tuning (Bottleneck Bandwidth и Round-trip propagation time (BBR) congestion control algorithm):
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
### 1.2 Сonfiguring the firewall:
    It is important to use port 443.
    It is necessary to check that the port 443 is not busy and open.
### 1.3 Install docker and docker-compose 
    https://docs.docker.com/engine/install/
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
## 2. Install docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version
## 3. Build and run app
    docker-compose up --force-recreate --build -d
    
    ### Clear build, run whithout cache and delete old images ###
    docker-compose build --no-cache; docker-compose up -d; docker rmi $(docker images | grep none | awk {'print $3'})
## 4. Check docker containers   
    docker ps -a | grep parsing

## 5. View site 
    http://localhost:8000

### Nginx + ssl + security
    1. Install nginx 
    2. Install certbot and generate cert for your domain name
    3. Use and change files nginx/parsing-sheets.conf nginx/nginx.conf for your needs
