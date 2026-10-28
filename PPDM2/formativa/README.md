# Mapa de Locais

Aplicacao mobile desenvolvida em Flutter para pesquisar estabelecimentos por
nome, categoria e cidade. Os dados sao persistidos no Cloud Firestore e podem
ser cadastrados, consultados, editados, excluidos e marcados como favoritos.

## Problematica e objetivo

Uma empresa precisa disponibilizar uma forma simples de localizar servicos e
estabelecimentos em cidades diferentes. O aplicativo permite selecionar São
Paulo, Campinas ou Jundiaí, pesquisar o que se procura, filtrar resultados,
consultar detalhes e manter favoritos.

O objetivo e demonstrar uma aplicacao Flutter completa, organizada em camadas,
com navegacao entre tres telas e operacoes CRUD integradas ao Firebase.

## Funcionalidades

- RF01 - selecionar São Paulo, Campinas ou Jundiaí;
- RF02 - pesquisar por nome ou categoria;
- RF03 - ler resultados em tempo real do Cloud Firestore;
- RF04 - filtrar por cidade, categoria e favoritos;
- RF05 - cadastrar um documento na colecao `locais`;
- RF06 - editar os dados de um local;
- RF07 - excluir apenas depois de uma confirmacao;
- RF08 - exibir todos os detalhes do local;
- RF09 - marcar e desmarcar favoritos no Firestore;
- RF10 - navegar entre mapa, resultados e detalhes.

O app apresenta mensagens de sucesso e erro, estado de carregamento, estado
vazio e uma representacao de mapa com cinco marcadores. Um mapa real e uma
extensao opcional do enunciado.

## Tecnologias

- Flutter e Dart;
- Firebase Core;
- Cloud Firestore;
- Firebase Authentication anonima;
- FlutterFire CLI;
- Material Design 3.

## Requisitos nao funcionais

- interface responsiva para Android;
- codigo separado em models, services, screens, widgets, dialogs e utils;
- confirmacao obrigatoria antes de excluir;
- mensagens de sucesso e erro em todas as operacoes de banco;
- regras de seguranca com autenticacao e validacao de schema;
- modo demonstracao para a interface continuar abrindo sem credenciais.

## Arquitetura

```text
lib/
├── app.dart
├── main.dart
├── firebase_options.dart
├── dialogs/
│   └── confirm_delete.dart
├── models/
│   ├── local.dart
│   └── locais_exemplo.dart
├── screens/
│   ├── mapa_screen.dart
│   ├── resultados_screen.dart
│   └── detalhes_screen.dart
├── services/
│   ├── app_bootstrap.dart
│   ├── firestore_local_repository.dart
│   ├── in_memory_local_repository.dart
│   └── local_repository.dart
├── utils/
│   └── local_filters.dart
└── widgets/
    ├── local_card.dart
    ├── local_form.dart
    └── mapa_ilustrado.dart
```

As telas dependem da interface `LocalRepository`, sem comandos de banco na
interface. `FirestoreLocalRepository` implementa a persistencia real. O
repositorio em memoria permite abrir e testar a interface enquanto o Firebase
ainda nao estiver configurado; nesse caso, a tela principal exibe o selo
`Demo`.

## Modelo da colecao `locais`

| Campo | Tipo | Exemplo |
|---|---|---|
| `nome` | String | `Academia Fitness` |
| `categoria` | String | `Academia` |
| `cidade` | String | `São Paulo` |
| `avaliacao` | Number | `4.8` |
| `distancia` | Number | `1.2` |
| `horario` | String | `06:00 - 22:00` |
| `descricao` | String | `Academia completa...` |
| `favorito` | Boolean | `false` |

Quando a colecao esta vazia, o aplicativo cadastra automaticamente dez locais
de exemplo distribuidos entre as tres cidades.

## Operacoes CRUD

| Operacao | Implementacao |
|---|---|
| Create | `CollectionReference.add()` no cadastro |
| Read | `CollectionReference.snapshots()` em tempo real |
| Update | `DocumentReference.update()` na edicao e no favorito |
| Delete | `DocumentReference.delete()` depois da confirmacao |

## Configuracao do Firebase

O arquivo `firebase_options.dart` atual e apenas um fallback compilavel. No
computador com Flutter instalado, execute na pasta deste projeto:

```bash
flutter pub get
firebase login
dart pub global activate flutterfire_cli
flutterfire configure
```

No Firebase Console:

1. crie ou selecione o projeto;
2. habilite o Cloud Firestore;
3. em Authentication > Sign-in method, habilite `Anonymous`;
4. publique as regras versionadas neste projeto com `firebase deploy --only firestore`;
5. execute `flutter run` em um dispositivo ou emulador Android.

As regras exigem usuario autenticado e validam os campos da colecao. O app
realiza o login anonimo automaticamente, sem adicionar uma quarta tela.

## Testes

Execute:

```bash
flutter analyze
flutter test
```

Ha testes automatizados para o model, filtros combinados e navegacao da tela de
mapa para resultados. A validacao manual deve ser preenchida no dispositivo:

Estado da revisao atual: `dart analyze` sem problemas e `flutter test` com os
cinco testes aprovados.

| ID | Cenario | Resultado esperado | Status |
|---|---|---|---|
| T01 | Abrir o app | Dados do Firestore aparecem | Pendente no dispositivo |
| T02 | Pesquisar `Academia` | Apenas resultados correspondentes | Pendente no dispositivo |
| T03 | Selecionar Campinas | Lista limitada a Campinas | Pendente no dispositivo |
| T04 | Selecionar categoria | Filtro aplicado | Pendente no dispositivo |
| T05 | Cadastrar local | Documento criado no Firestore | Pendente no dispositivo |
| T06 | Reabrir a tela | Registro continua disponivel | Pendente no dispositivo |
| T07 | Editar nome ou horario | Documento atualizado | Pendente no dispositivo |
| T08 | Excluir local | Confirmacao e remocao do documento | Pendente no dispositivo |
| T09 | Alternar favorito | Campo `favorito` atualizado | Pendente no dispositivo |
| T10 | Navegar e voltar | Fluxo funciona sem perder estado | Pendente no dispositivo |
| T11 | Simular erro ou falta de dados | Mensagem adequada aparece | Pendente no dispositivo |

## Evidencias de entrega

Depois da configuracao no computador, devem ser adicionadas capturas reais das
telas de mapa, resultados e detalhes, alem de uma captura do Firestore com os
dez documentos. Essas evidencias nao foram fabricadas sem executar o app e sem
acesso ao projeto Firebase.

## Conclusao

O projeto cobre as tres telas, navegacao, pesquisa, filtros, CRUD, favoritos,
mensagens de operacao, dados iniciais, regras de seguranca e testes de codigo.
Resta apenas conectar as credenciais reais pelo FlutterFire e registrar as
evidencias de execucao no Android.
