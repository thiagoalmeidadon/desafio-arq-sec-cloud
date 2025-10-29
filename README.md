
## Seja bem-vindo[a] ao desafio para Arquitetura de Segurança & Cloud (UOL)

Este desafio tem como objetivo avaliar sua capacidade de solucionar um problema entregando uma solução visando a segurança da informação e da infra-estrutura. Não tem problema não entregar o desafio completo, o tempo é muito curto. O que vai ser avaliado é a tua lógica na proposta da solução.

A quem vou me reportar relacionado ao teste? 

| Nome  | Github   |
| :--------: | :---------: |
| Thiago S. Almeida - thiagodons@gmail.com   | [thiagoalmeidadon](https://github.com/thiagoalmeidadon)   |



### Qual é o escopo do desafio?
Criar uma infraestrutura na AWS usando recursos de Compute e subir uma aplicação Web, IaC e tomando um "leve" cuidado com a segurança ( afinal, tu tá aplicando para uma vaga em Segurança 😊 ).

#### Vamos ir mais a fundo na explicação:

0. Faça um fork deste repositório (este mesmo do desafio).

1. Projete uma infraestrutura em IaC na AWS. Pense na VPC, suas subnets, seus recursos e duas instâncias EC2. Tudo para suportar de forma segura um servidorzinho WEB (só pra dar um oi) e um Banco de dados (básico mesmo, mas seguro). Para isso utilize o Terraform ou CloudFormation. 

2. Próximo passo, você precisa provisionar recursos necessários para suas instâncias EC2. Aqui você tem a liberdade de escolher entre Ansible, Bash ou outra linguagem de provisionamento de sua preferência, fique à vontade.

3. Assim que subiu sua infraestrutura, faça uma análise de segurança, código e organização antes do PR. Lembre-se, o foco é segurança, mas ter uma estrutura organizada é muito importante.
Obs.: O servidor WEB pode ser um simples Wordpress, ou um framework de sua preferência. Só lembre-se de utilizar o banco de dados também.

5. Terminou? Agora faça um **PullRequest** dentro da data de entrega, que agora é com a gente.

Como próximo passo, pense em alguma melhoria no seu projeto, vamos conversar sobre isso com você.

#### Documentações que vão ajudar:

https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/how-it-works.html
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
https://docs.ansible.com/ansible_community.html

#### Acabou o prazo e não consegui terminar, e agora?
Calma, não tem problema não entregar o projeto completo. O Objetivo desse teste é avaliar como você soluciona problemas, como você pensa para solucionar, até porque, o prazo é bem apertado para entregar. 

#### E qual o prazo para fazer meu PullRequest?
Do dia **29/10/2025** até às **00hrs** do dia **31/10/2025**.

Fique a vontade para chamar a gente em qualquer horário para qualquer dúvida.

## Boa sorte! 

