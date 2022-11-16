#!/bin/bash


sudo useradd --no-create-home --shell /bin/false alertmanager

#creating directory for alertmanager
sudo mkdir /etc/alertmanager
cd /tmp/
#downloading alertmanager file on tmp directory
wget https://github.com/prometheus/alertmanager/releases/download/v0.16.1/alertmanager-0.16.1.linux-amd64.tar.gz
#unzipping it
tar -xvf alertmanager-0.16.1.linux-amd64.tar.gz

cd alertmanager-0.16.1.linux-amd64
#moving the file to /usr/local/bin/
sudo mv alertmanager /usr/local/bin/
sudo mv amtool /usr/local/bin/
#giving permissions to access the bin directories
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

#moving yml file to alertmanager directory
sudo mv alertmanager.yml /etc/alertmanager/

#giving permissions to access the /etc/alertmanager/ directories
sudo chown -R alertmanager:alertmanager /etc/alertmanager/

#creating one alertmanager.service file on /etc/systemd/system
sudo echo -e "[Unit]\nDescription=Alertmanager\nWants=network-online.target\nAfter=network-online.target\n\n[Service]\nUser=alertmanager\nGroup=alertmanager\nType=simple\nWorkingDirectory=/etc/alertmanager/\nExecStart=/usr/local/bin/alertmanager\\n    --config.file=/etc/alertmanager/alertmanager.yml\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/alertmanager.service


#adding few extra lines to prometheus yml config
sudo echo -e "alerting:\n  alertmanagers:\n  - static_configs:\n    - targets:\n      - localhost:9093\n" >> /etc/prometheus/prometheus.yml
#reloading
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl start alertmanager
sudo systemctl enable alertmanager
systemctl status alertmanager.service 


#creating one rules.yml file to give alerting rules file on /etc/systemd/system
echo -e "groups:\n - name: test\n   rules:\n   - alert: InstanceDown\n     expr: up == 0\n     for: 1m\n" >> /etc/prometheus/rules.yml

#pointing the rules.yml file in pormetheus.yml config
echo -e "rule_files:\n - rules.yml" >> /etc/prometheus/prometheus.yml

#restarting
sudo systemctl restart prometheus.service
sudo systemctl start alertmanager