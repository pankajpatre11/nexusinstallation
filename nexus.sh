apt-get update
apt install openjdk-8-jdk -y
java -version
useradd -M -d /opt/nexus -s /bin/bash -r nexus
echo "nexus   ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/nexus
wget https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/3/nexus-3.29.2-02-unix.tar.gz
mkdir /opt/nexus
tar xzf nexus-3.29.2-02-unix.tar.gz -C /opt/nexus --strip-components=1ls /opt/nexus
ls /opt/nexus
chown -R nexus: /opt/nexus
sed -i 's/#run_as_user=""/run_as_user="nexus"/' /opt/nexus/bin/nexus.rc
sudo -u nexus /opt/nexus/bin/nexus start
tail -f /opt/nexus/sonatype-work/nexus3/log/nexus.log
netstat -altnp | grep :8081
cat > /etc/systemd/system/nexus.service << 'EOL'
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL
/opt/nexus/bin/nexus stop
systemctl daemon-reload
systemctl enable --now nexus.service
tail -f /opt/nexus/sonatype-work/nexus3/log/nexus.log
ufw allow 8081/tcp
