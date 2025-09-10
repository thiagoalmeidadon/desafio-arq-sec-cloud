#!/bin/bash
set -euxo pipefail


# Atualizações básicas
sudo dnf -y update


# Garantir SSM Agent
sudo systemctl enable --now amazon-ssm-agent