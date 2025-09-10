
#!/bin/bash
set -euxo pipefail

# Atualizações
sudo dnf -y update

# Instalar Docker
sudo dnf -y install docker
sudo systemctl enable --now docker
sudo usermod -aG docker ec2-user
sudo

# Diretório da app
sudo mkdir -p /opt/helloworld
sudo chown ec2-user:ec2-user /opt/helloworld
cd /opt/helloworld

# Dockerfile e app
cat > hello.py << 'PY'
from flask import Flask
app = Flask(__name__)

@app.get('/')
def root():
    return 'Hello, World from Docker! \n(secure-ish EC2 via Terraform + SSM + IMDSv2)\n'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
PY

cat > Dockerfile << 'DOCKER'
FROM python:3.11-slim
WORKDIR /app
COPY hello.py .
RUN pip install flask gunicorn
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:80", "hello:app"]
DOCKER

# Build da imagem e container systemd
sudo -u ec2-user docker build -t helloworld:latest .

cat > /etc/systemd/system/helloworld.service << 'SERVICE'
[Unit]
Description=Hello World Flask in Docker
After=docker.service
Requires=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run --rm --name helloworld -p 80:80 helloworld:latest
ExecStop=/usr/bin/docker stop helloworld

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable --now helloworld.service
