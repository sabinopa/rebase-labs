# 📋👩🏽‍⚕️ Projeto de Listagem de Exames Médicos

![Static Badge](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Sinatra](https://img.shields.io/badge/Ruby%20Sinatra-000000.svg?style=for-the-badge&logo=Ruby-Sinatra&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
<img src="https://puma.io/images/logos/puma-logo-large.png" alt="Puma" height="27">


![Static Badge](https://img.shields.io/badge/COBERTURA_DE_TESTES-100%25-blue)
![Static Badge](https://img.shields.io/badge/STATUS-EM_DESENVOLVIMENTO-green)

Este projeto é uma aplicação web para a listagem de exames médicos, construída utilizando Sinatra e Docker. A aplicação permite importar dados de exames médicos a partir de um arquivo CSV, armazená-los em um banco de dados PostgreSQL e exibi-los em formato JSON via API.

## 📑 Índice

▶️ [Funcionalidades](#funcionalidades)

▶️ [Pré-requisitos](#pré-requisitos)

▶️ [Configuração do Ambiente](#configuração-do-ambiente)

▶️ [Executando a Aplicação](#executando-a-aplicação)

▶️ [Estrutura do Projeto](#estrutura-do-projeto)

▶️ [Endpoints Disponíveis](#endpoints-disponíveis)

▶️ [Importação de Dados CSV](#importação-de-dados-csv)

▶️ [Testes](#testes)

## Funcionalidades
- **Importar Dados CSV:** Importa dados de exames médicos de um arquivo CSV para um banco de dados PostgreSQL.
- **API REST:** Disponibiliza endpoints para acessar dados dos exames em formato JSON.
- **Dockerizado:** A aplicação é completamente dockerizada, facilitando a configuração e a execução em qualquer ambiente.

## Pré-requisitos
Certifique-se de ter os seguintes softwares instalados no seu ambiente de desenvolvimento:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Gems Utilizadas

- [Sinatra](https://sinatrarb.com/)
- [PostgreSQL](https://www.postgresql.org/)
- [Puma](https://github.com/puma/puma)
- [Rackup](https://github.com/rack/rackup)
- [Rspec](https://github.com/rspec/rspec-rails)
- [SimpleCov](https://github.com/simplecov-ruby/simplecov)
- [Rack::Test](https://github.com/rack/rack-test)

## Configuração do Ambiente
### Clonar o Repositório
Clone o repositório para sua máquina local:
```
git clone git@github.com:sabinopa/rebase-labs.git
```

```
cd rebase-labs
```

## Executando a Aplicação
### Iniciar o Servidor
Para iniciar a aplicação, utilize o Docker Compose:

```
docker-compose up --build -d
```
Você pode acessar a API através http://localhost:3000/tests.
Você pode acessar a frontend através http://localhost:2000.

## Populando o Banco de Dados
### Executando a Importação de Dados CSV
Para importar os dados do arquivo data.csv para o banco de dados, execute o seguinte comando:

```
docker-compose exec api ruby /app/backend/helpers/csv_importer.rb
```
Os dados serão importados para as tabelas correspondentes no PostgreSQL.

## Verificar os Logs
Para verificar os logs da aplicação:

```
docker-compose logs api
```

## Parar a Aplicação
Para parar a aplicação:

```
docker-compose down
```

### Estrutura do Projeto
Aqui está uma visão geral da estrutura do projeto:

```
.
├── app/
│   ├── controllers/
│   │   └── tests_controller.rb
│   ├── models/
│   │   ├── doctor.rb
│   │   ├── exam.rb
│   │   ├── patient.rb
│   │   └── test.rb
├── config/
│   ├── database.rb
│   ├── test_service.rb
│   └── config.yml
├── data/
│   └── data.csv
├── spec/
│   ├── models/
│   │   ├── doctor_spec.rb
│   │   ├── exam_spec.rb
│   │   ├── patient_spec.rb
│   │   └── test_spec.rb
├── Dockerfile
├── docker-compose.yml
├── Gemfile
└── Gemfile.lock
```

## Endpoints Disponíveis
```
GET /tests
```
Retorna todos os exames em formato JSON.

```
GET /tests/:token
```
Retorna um exame específico baseado no token do resultado.

### Exemplo de Request:

```
curl http://localhost:3000/tests/IQCZ17
```
```
json
{
  "result_token": "IQCZ17",
  "result_date": "2022-01-01",
  "patient": {
    "cpf": "123.456.789-00",
    "name": "João Silva",
    "email": "joao.silva@example.com",
    "birthdate": "1985-01-01",
    "address": "Rua das Flores, 123",
    "city": "São Paulo",
    "state": "SP"
  },
  "doctor": {
    "crm": "123456",
    "name": "Dra. Maria Souza",
    "email": "maria.souza@example.com",
    "crm_state": "SP"
  },
  "tests": [
    {
      "type": "Exame de Sangue",
      "limits": "10-20",
      "results": "15"
    }
  ]
}
```

## Testes
### Executando os Testes
Os testes estão escritos utilizando RSpec.
Para executar os testes de backend, use o seguinte comando:

```
docker-compose exec api rspec
docker-compose exec front rspec
```


