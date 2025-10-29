#!/bin/bash

exec > /var/log/user_data.log 2>&1
set -xe

sudo apt-get update -y
sudo apt-get install -y python3 python3-venv python3-pip mysql-client jq # Adicionado 'jq' para parsear JSON

sudo mkdir -p /opt/flaskapp
cd /opt/flaskapp

sudo python3 -m venv venv
sudo /opt/flaskapp/venv/bin/pip install --upgrade pip flask mysql-connector-python

# Obter ID da instância e hostname de arquivos locais do cloud-init
INSTANCE_ID=$(cat /var/lib/cloud/data/instance-id)
HOSTNAME=$(jq -r ".hostname" /var/lib/cloud/data/set-hostname)

sudo cat << 'APP' > /opt/flaskapp/app.py
from flask import Flask
import mysql.connector
import os

app = Flask(__name__)

@app.route('/')
def hello():
    try:
        # Informações do banco de dados
        db_host = os.environ.get('DB_HOST')
        db_user = os.environ.get('DB_USER')
        db_pass = os.environ.get('DB_PASS')
        db_name = os.environ.get('DB_NAME')

        conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_pass,
            database=db_name
        )
        cur = conn.cursor()
        cur.execute("SELECT NOW();")
        db_time = cur.fetchone()[0]
        cur.close()
        conn.close()

        # Informações da instância EC2 (passadas via variáveis de ambiente do user_data)
        instance_id = os.environ.get('INSTANCE_ID', 'N/A')
        hostname = os.environ.get('HOSTNAME', 'N/A')

        return f"""<h1>Hello World!</h1>\
                <p>Banco MySQL acessado com sucesso.</p>\
                <p>Hora atual no servidor: {db_time}</p>\
                <p>Hostname: {hostname}</p>\
                <p>ID da Instância: {instance_id}</p>\
                <p>Nome do Banco de Dados: {db_name}</p>\
                <p>Host do Banco de Dados: {db_host}</p>"""
    except Exception as e:
        return f"<h1>Erro:</h1><p>{str(e)}</p>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=${app_port})
APP

sudo cat << SERVICE > /etc/systemd/system/flaskapp.service
[Unit]
Description=Flask App Service (MySQL)
After=network.target

[Service]
User=root
WorkingDirectory=/opt/flaskapp
Environment="DB_HOST=${db_host}"
Environment="DB_USER=${db_user}"
Environment="DB_PASS=${db_pass}"
Environment="DB_NAME=${db_name}"
Environment="INSTANCE_ID=$${INSTANCE_ID}"
Environment="HOSTNAME=$${HOSTNAME}"
ExecStart=/opt/flaskapp/venv/bin/python /opt/flaskapp/app.py
Restart=always
StandardOutput=append:/var/log/flaskapp.log
StandardError=append:/var/log/flaskapp.err

[Install]
WantedBy=multi-user.target
SERVICE

sudo chmod 644 /etc/systemd/system/flaskapp.service
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl start flaskapp

