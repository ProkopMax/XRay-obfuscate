# Server XRAY with XTLS-Reality in the docker container.
## Project X Community https://github.com/XTLS
#
## 1. Prepare server to install.
### 1.1 Performance tuning (Bottleneck Bandwidth и Round-trip propagation time (BBR) congestion control algorithm):
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
### 1.2 Сheck port:
    It's important to use port 443.
    It's necessary to check that the port 443 is not busy and open in the firewall.
### 1.3 Install docker and docker-compose:
    https://docs.docker.com/engine/install/
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    docker-compose --version

## 2. Setting up the server application and run.
### 2.1 Build image:
    git clone https://github.com/ProkopMax/XRay-obfuscate.git && cd XRay-obfuscate/
    docker-compose build --no-cache
### 2.2 Generate keys and id:
    # Generate uuid:
    docker run -it --rm xray-proxy uuid

    # Generate private and public keys:
    docker run -it --rm xray-proxy x25519

    # Generate short ID:
    openssl rand -hex 8
### 2.3 Settings config.json:
![image](https://github.com/ProkopMax/XRay-obfuscate/assets/72852008/c02233cc-da32-4f23-818e-f17cf2017a52)
### 2.4 Run the server application:
    docker-compose up -d
### 2.5 Check docker containers:
    docker ps -a | grep xray-proxy
    docker logs xray-proxy-1
       
## 3. Client Setup.  
### 3.1 Nekoray https://github.com/MatsuriDayo/nekoray/releases:
![image](https://github.com/ProkopMax/XRay-obfuscate/assets/72852008/a0c32601-a50c-4e78-aa14-a80564f829a7)
![image](https://github.com/ProkopMax/XRay-obfuscate/assets/72852008/eaee2fdb-f237-4c80-acf7-86d26a504e6c)
![image](https://github.com/ProkopMax/XRay-obfuscate/assets/72852008/5f4d0789-aaeb-4f48-a6c0-0cb5958d6110)
![image](https://github.com/ProkopMax/XRay-obfuscate/assets/72852008/1b3fbc98-1c7a-481d-82f6-e5d44ee42707)


### 3.2 Android v2rayNG:
    You can export settings for the client from the windows application Nekoray with QR-code

## 4. Update the XRAY version.
### 4.1 Change version in the .env file:
    TAG=v1.8.4
### 4.2 Build new image and restart the server application:
    docker-compose build --no-cache; docker-compose up -d;

## 5. Examples settings in the config.json.
https://github.com/XTLS/Xray-examples/tree/main
