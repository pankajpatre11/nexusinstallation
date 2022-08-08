sudo apt-get update
sudo apt install openjdk-8-jre-headless
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
tar -zxvf latest-unix.tar.gz
sudo mv nexus-3.41.0-01 nexus
echo "fail1"
sudo adduser nexus
echo "nexus   ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/nexus
sudo chown -R nexus:nexus nexus
sudo chown -R nexus:nexus sonatype-work
echo "fail2"
sed -i 's/#run_as_user=""/run_as_user="nexus"/' nexus/bin/nexus.rc
echo "fail3"
cat > /etc/systemd/system/nexus.service << 'EOL'
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/nexus/bin/nexus start
ExecStop=/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL
echo "fail4"
sudo systemctl start nexus
sudo systemctl enable nexus
sudo systemctl status nexus
sudo systemctl stop nexus
echo "fail5"
ufw allow 8081/tcp
