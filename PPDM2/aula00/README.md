# aula00 - Cadastro de Alunos

App Flutter para cadastrar alunos (nome, idade e curso), integrado ao backend NestJS em
`backend/src/features/classes/ppdm2/aula00`.

## Estrutura

- `lib/main.dart` — app inteiro num único arquivo (UI + chamadas HTTP ao backend).
- `pubspec.yaml` — dependências do projeto (inclui `http`).

## Como rodar

1. Suba o backend primeiro (na pasta `backend`):
   ```
   npm install
   npm run start:dev
   ```
   Ele sobe em `http://localhost:3000`.

2. No app, rode:
   ```
   flutter pub get
   flutter run
   ```

O app se conecta em `http://localhost:3000` por padrão. Se estiver rodando no **emulador Android**,
ele troca automaticamente para `http://10.0.2.2:3000` (endereço que o emulador usa para acessar o
`localhost` da máquina host) — isso já está tratado em `AlunosApiService` no `main.dart`.

Se for testar em um **dispositivo físico**, troque a URL em `AlunosApiService._baseUrl` pelo IP da
máquina onde o backend está rodando (ex: `http://192.168.0.10:3000`).

## Endpoints usados

- `GET /aulas/ppdm2/aula00/alunos` — lista os alunos
- `POST /aulas/ppdm2/aula00/alunos` — cadastra um aluno (`{ nome, idade, curso }`)
- `DELETE /aulas/ppdm2/aula00/alunos/:id` — remove um aluno

## Funcionalidades

- Campos: Nome, Idade, Curso
- Botão Cadastrar (com validação dos campos e feedback de erro do backend)
- Lista dos alunos cadastrados, com opção de remover cada um e botão de atualizar (refresh)
