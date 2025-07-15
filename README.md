# PIBD - Portal de Transporte e Mobilidade

Este é o repositório do projeto da disciplina de Projeto Integrado de Banco de Dados (PIBD). A solução consiste em uma aplicação desktop desenvolvida para gerenciar um sistema de transporte de forma eficiente.

## 🚀 Como Executar o Projeto

Siga os passos abaixo para configurar e executar a aplicação em sua máquina local.

### 1. Pré-requisitos

Garanta que você tenha os seguintes softwares instalados em sua máquina:

* **Python:** versão 3.10 ou superior
* **Git:** para clonar o repositório
* **MySQL:** Server e um cliente de sua preferência (como MySQL Workbench ou DBeaver)

### 2. Guia de Instalação

#### Passo 1: Clonar o Repositório

Abra seu terminal ou Git Bash e execute o comando abaixo para clonar este repositório.

```bash
git clone <URL_DO_SEU_REPOSITORIO_AQUI>
cd <NOME_DA_PASTA_DO_PROJETO>
'''

#### Passo 2: Configurar o Banco de Dados

1.  Abra seu cliente MySQL (MySQL Workbench, por exemplo).
2.  Execute o script `setup_database.sql`, que se encontra na raiz deste repositório. Este script criará o banco de dados `sgci_transporte` e o populará com os dados iniciais necessários.

#### Passo 3: Configurar a Conexão com o Banco

1.  Localize e abra o arquivo `config.py`.
2.  Insira a senha do seu usuário root do MySQL no campo `'password'`.

```python
# config.py
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': 'sua_senha_aqui',  # <-- EDITE AQUI
    'database': 'sgci_transporte'
}

#### Passo 4: Preparar o Ambiente Python

É uma boa prática usar um ambiente virtual para isolar as dependências do projeto.

1.  No terminal, dentro da pasta do projeto, crie um ambiente virtual:
    ```bash
    python -m venv venv
    ```

2.  Ative o ambiente virtual:
    * **No Windows:**
        ```bash
        .\venv\Scripts\activate
        ```
    * **No macOS/Linux:**
        ```bash
        source venv/bin/activate
        ```

3.  Com o ambiente ativo, instale as dependências listadas no arquivo `requirements.txt`:
    ```bash
    pip install -r requirements.txt
    ```

### 3. Executando a Aplicação

Uma vez que o ambiente esteja configurado e o banco de dados pronto, inicie a aplicação com o seguinte comando:

```bash
python main.py
