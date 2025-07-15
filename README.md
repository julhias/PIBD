PIBD - Portal de Transporte e Mobilidade
Este é o repositório do projeto da disciplina de Projeto Integrado de Banco de Dados (PIBD), que consiste em uma aplicação desktop para gerenciar um sistema de transporte.

🚀 Como Executar o Projeto
Siga os passos abaixo para configurar e executar a aplicação em sua máquina local.

1. Pré-requisitos
Garanta que você tenha o seguinte software instalado:

Python (versão 3.10 ou superior)

Git

MySQL Server e um cliente como o MySQL Workbench

2. Passo a Passo
Clone o Repositório
Abra seu terminal e execute o comando:

Bash

git clone [URL_DO_SEU_REPOSITORIO_AQUI]
cd nome-da-pasta-do-projeto
Crie e Configure o Banco de Dados

Abra o MySQL Workbench (ou seu cliente de preferência).

Execute o script setup_database.sql (que está neste repositório) para criar e popular o banco de dados sgci_transporte.

Configure a Conexão

Abra o arquivo config.py.

Insira sua senha do MySQL no campo 'password'.

Python

# config.py
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'sua_senha_aqui',  # <-- EDITE AQUI
    'database': 'sgci_transporte'
}
Prepare o Ambiente Python

Ainda no terminal, na pasta do projeto, crie um ambiente virtual:

Bash

py -m venv venv
Ative o ambiente:

Bash

# No Windows
.\venv\Scripts\activate
Instale as dependências:

Bash

pip install -r requirements.txt
Execute a Aplicação

Com o ambiente ainda ativo, inicie o programa:

Bash

py main.py
A janela da aplicação deverá aparecer na sua tela.
