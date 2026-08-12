import 'dart:convert';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Alunos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CadastroAlunosPage(),
    );
  }
}

class Aluno {
  final int id;
  final String nome;
  final int idade;
  final String curso;

  Aluno({
    required this.id,
    required this.nome,
    required this.idade,
    required this.curso,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'] as int,
      nome: json['nome'] as String,
      idade: json['idade'] as int,
      curso: json['curso'] as String,
    );
  }
}

class AlunosApiService {
  static String get _baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static Uri get _alunosUri => Uri.parse('$_baseUrl/aulas/ppdm2/aula00/alunos');
  static Uri _alunoUri(int id) =>
      Uri.parse('$_baseUrl/aulas/ppdm2/aula00/alunos/$id');

  Future<List<Aluno>> listar() async {
    final response = await http.get(_alunosUri);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = (body['data'] as List).cast<Map<String, dynamic>>();
    return data.map(Aluno.fromJson).toList();
  }
  Future<String?> cadastrar({
    required String nome,
    required int idade,
    required String curso,
  }) async {
    final response = await http.post(
      _alunosUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'idade': idade, 'curso': curso}),
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final executed = body['executed'] as bool;
    return executed ? null : body['messages'] as String;
  }

  Future<void> remover(int id) async {
    await http.delete(_alunoUri(id));
  }
}

class CadastroAlunosPage extends StatefulWidget {
  const CadastroAlunosPage({super.key});

  @override
  State<CadastroAlunosPage> createState() => _CadastroAlunosPageState();
}

class _CadastroAlunosPageState extends State<CadastroAlunosPage> {
  final _formKey = GlobalKey<FormState>();
  final _api = AlunosApiService();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  final TextEditingController _cursoController = TextEditingController();

  List<Aluno> _alunos = [];
  bool _carregando = true;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    super.dispose();
  }

  Future<void> _carregarAlunos() async {
    setState(() => _carregando = true);
    try {
      final alunos = await _api.listar();
      setState(() => _alunos = alunos);
    } catch (_) {
      _mostrarErro('Não foi possível conectar ao servidor.');
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _cadastrarAluno() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _enviando = true);
    try {
      final erro = await _api.cadastrar(
        nome: _nomeController.text.trim(),
        idade: int.parse(_idadeController.text.trim()),
        curso: _cursoController.text.trim(),
      );

      if (erro != null) {
        _mostrarErro(erro);
        return;
      }

      _nomeController.clear();
      _idadeController.clear();
      _cursoController.clear();
      FocusScope.of(context).unfocus();
      await _carregarAlunos();
    } catch (_) {
      _mostrarErro('Não foi possível conectar ao servidor.');
    } finally {
      setState(() => _enviando = false);
    }
  }

  Future<void> _removerAluno(Aluno aluno) async {
    try {
      await _api.remover(aluno.id);
      await _carregarAlunos();
    } catch (_) {
      _mostrarErro('Não foi possível remover o aluno.');
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _carregando ? null : _carregarAlunos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _idadeController,
                    decoration: const InputDecoration(
                      labelText: 'Idade',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe a idade';
                      }
                      if (int.tryParse(value.trim()) == null) {
                        return 'Idade inválida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cursoController,
                    decoration: const InputDecoration(
                      labelText: 'Curso',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o curso';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _enviando ? null : _cadastrarAluno,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: _enviando
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Cadastrar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Alunos cadastrados',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : _alunos.isEmpty
                      ? const Center(
                          child: Text(
                            'Nenhum aluno cadastrado ainda.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _alunos.length,
                          itemBuilder: (context, index) {
                            final aluno = _alunos[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              child: ListTile(
                                title: Text(aluno.nome),
                                subtitle: Text(
                                    'Idade: ${aluno.idade} | Curso: ${aluno.curso}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _removerAluno(aluno),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
