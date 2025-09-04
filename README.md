
## Seja bem-vindo[a] ao desafio para Arquitetura de Segurança & Cloud (UOL)

Este desafio tem como objetivo avaliar sua capacidade de solucionar um problema entregando uma solução visando a segurança da informação e da infra-estrutura. Não tem problema não entregar o desafio completo, o tempo é muito curto. O que vai ser avaliado é a tua lógica na proposta da solução.

A quem vou me reportar relacionado ao teste? 

| Nome  | Github   |
| :--------: | :---------: |
| Thiago S. Almeida - thiagodons@gmail.com   | [thiagoalmeidadon](https://github.com/thiagoalmeidadon)   |



### Qual é o escopo do desafio?
Criar uma infraestrutura na AWS usando recursos de Compute e subir uma aplicação Web simples, tudo em IaC e tomando um leve cuidado com a segurança ( afinal, tu tá aplicando para uma vaga em Segurança 😊 ).

#### Vamos ir mais a fundo na explicação:

0. Faça um fork deste repositório (este mesmo do desafio).

1. Projete uma infraestrutura em IaC na AWS. Pense na VPC e seus recursos para subir uma instância EC2 segura. Para isso utilize o Terraform, ou se preferir pode utilizar o CloudFormation.

2. Próximo passo, você precisa provisionar recursos necessários para sua instância EC2, e aqui você tem a liberdade de escolher entre Ansible, Bash ou outra linguagem de provisionamento de sua preferência, aqui gostamos do **Ansible**, mas fique à vontade.

3. E a cereja do bolo, uma aplicação Web. Mas calma, basta subir um simples hello world HTTP e já está ótimo [helloworld-http](https://hub.docker.com/r/strm/helloworld-http/). 
Fique à vontade para subir um App simples com Python, Django, PHP, Laravel, ou outra linguagem, framework ou container de sua preferência, só lembre-se, o tempo é curto (**menos é mais**).

4. Terminou? Agora faça um **PullRequest** dentro da data de entrega, que agora é com a gente.

Como próximo passo, pense em alguma melhoria no seu projeto, vamos conversar sobre isso com você.

#### Documentações que vão ajudar:

https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/how-it-works.html
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
https://docs.ansible.com/ansible_community.html
https://hub.docker.com/r/strm/helloworld-http/

#### Acabou o prazo e não consegui terminar, e agora?
Calma, não tem problema não entregar o projeto completo. O Objetivo desse teste é avaliar como você soluciona problemas, como você pensa para solucionar, até porque, o prazo é bem apertado para entregar. 

#### E qual o prazo para fazer meu PullRequest?
Do dia **03/09/2025** até às **22hrs** do dia **05/09/2025**.

Fique a vontade para chamar a gente em qualquer horário para qualquer dúvida.

## Boa sorte! 

---

### Requirements to run the challenge:
1. [Intall terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. [Intall python3](https://python.org.br/instalacao-linux/)
3. [Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
4. [Install aws-cli](https://docs.aws.amazon.com/pt_br/cli/latest/userguide/getting-started-install.html)
5. [Configure aws IAM credentials](https://console.aws.amazon.com/iam/home?#/security_credentials)


### Step 1: Create on Terraform main file to create IAC with Secure EC2 on VPC:
1. Setting terraform provider aws
2. Setting the aws region on us-east-1
3. Create the VPC with cidr block range
4. Create a public subnet on VPC
5. Attach an Internet Gateway on the VPC
6. Create a route table for public subnet on VPC with Ipv4 and Ipv6
7. Associate the route table with subnet
8. Create security groups to allow specific traffic (SSH/WEB)
9. Create ec2 instances (ubuntu server) on the subnet named Terraform Challange
10. Run the command: `$ terraform apply`

### Step 2: Create AWS Pair Key to access the EC2 instance
```bash
$ aws ec2 create-key-pair --key-name ChallengeKeyPair --query 'KeyMaterial' --output text > ~/.ssh/ChallengeKeyPair.pem
$ chmod 400  ~/.ssh/ChallengeKeyPair.pem
```

### Step 3: Check the connection with the instance
```bash
$ ssh -i "~/.ssh/ChallengeKeyPair.pem" ubuntu@InstancePublicIPv4
```

### Step 3: Create the Ansible hosts file
1. Create new host name inside the []
2. On next line inser the EC2 Public IPv4 to associate with the created host name

### Step 4: Create the Ansible playbook file with respective tasks:
1. Installing python3 and python3-virtualenv
2. Installing pip dependencies (Django and Django Rest)
3. Starting the Django Project
4. Allowing all hosts to access Django on settings
5. Running the server on port 8080

### Step 5: Run the Ansible command to apply the configuration on EC2 Instance
```bash
$ ansible-playbook playbook.yml -u ubuntu --private-key ~/.ssh/ChallengeKeyPair.pem -i hosts.yml
```

### Step 6: Access the EC2 public Instance on port 8080 to see Django successfully installed
http://InstancePublicIPv4:8080
