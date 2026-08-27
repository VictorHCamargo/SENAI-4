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

class _EditarAlunoDialog extends StatefulWidget {
  const _EditarAlunoDialog({
    required this.aluno,
    required this.onSalvar,
  });

  final Aluno aluno;
  final Future<String?> Function(String nome, int idade, String curso, String email)
      onSalvar;

  @override
  State<_EditarAlunoDialog> createState() => _EditarAlunoDialogState();
}

class _EditarAlunoDialogState extends State<_EditarAlunoDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _idadeController;
  late final TextEditingController _cursoController;
  late final TextEditingController _emailController;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.aluno.nome);
    _idadeController = TextEditingController(text: '${widget.aluno.idade}');
    _cursoController = TextEditingController(text: widget.aluno.curso);
    _emailController = TextEditingController(text: widget.aluno.email);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);
    try {
      final erro = await widget.onSalvar(
        _nomeController.text.trim(),
        int.parse(_idadeController.text.trim()),
        _cursoController.text.trim(),
        _emailController.text.trim(),
      );

      if (!mounted) return;
      if (erro != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erro)),
        );
        return;
      }

      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar o aluno.')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  String? _validarTexto(String? value, String mensagem) {
    if (value == null || value.trim().isEmpty) return mensagem;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar aluno'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => _validarTexto(value, 'Informe o nome'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _idadeController,
                decoration: const InputDecoration(
                  labelText: 'Idade',
                  prefixIcon: Icon(Icons.cake_outlined),
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
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (value) => _validarTexto(value, 'Informe o curso'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o e-mail';
                  }
                  final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                  if (!regex.hasMatch(value.trim())) return 'E-mail inválido';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _salvando ? null : () => Navigator.of(context).pop(),
          child: const Text('CANCELAR'),
        ),
        FilledButton.icon(
          onPressed: _salvando ? null : _salvar,
          icon: _salvando
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_salvando ? 'Salvando...' : 'SALVAR'),
        ),
      ],
    );
  }
}

class Aluno {
  final int id;
  final String nome;
  final int idade;
  final String curso;
  final String email;

  Aluno({
    required this.id,
    required this.nome,
    required this.idade,
    required this.curso,
    required this.email,
  });

  factory Aluno.fromJson(Map<String, dynamic> json) {
    return Aluno(
      id: json['id'] as int,
      nome: json['nome'] as String,
      idade: json['idade'] as int,
      curso: json['curso'] as String,
      email: json['email'] as String? ?? '',
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
    required String email,
  }) async {
    final response = await http.post(
      _alunosUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'idade': idade,
        'curso': curso,
        'email': email,
      }),
    );
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final executed = body['executed'] as bool;
    return executed ? null : body['messages'] as String;
  }

  Future<String?> atualizar({
    required int id,
    required String nome,
    required int idade,
    required String curso,
    required String email,
  }) async {
    final response = await http.put(
      _alunoUri(id),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'idade': idade,
        'curso': curso,
        'email': email,
      }),
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pesquisaController = TextEditingController();

  List<Aluno> _alunos = [];
  String _pesquisa = '';
  bool _carregando = true;
  bool _enviando = false;

  List<Aluno> get _alunosFiltrados {
    if (_pesquisa.trim().isEmpty) {
      return _alunos;
    }
    final termo = _pesquisa.trim().toLowerCase();
    return _alunos
        .where((aluno) => aluno.nome.toLowerCase().contains(termo))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _carregarAlunos();
    _pesquisaController.addListener(() {
      setState(() => _pesquisa = _pesquisaController.text);
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _idadeController.dispose();
    _cursoController.dispose();
    _emailController.dispose();
    _pesquisaController.dispose();
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
        email: _emailController.text.trim(),
      );

      if (erro != null) {
        _mostrarErro(erro);
        return;
      }

      _nomeController.clear();
      _idadeController.clear();
      _cursoController.clear();
      _emailController.clear();
      FocusScope.of(context).unfocus();
      await _carregarAlunos();
    } catch (_) {
      _mostrarErro('Não foi possível conectar ao servidor.');
    } finally {
      setState(() => _enviando = false);
    }
  }

  Future<void> _confirmarExclusao(Aluno aluno) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text('Deseja realmente excluir ${aluno.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('EXCLUIR'),
            ),
          ],
        );
      },
    );

    if (confirmou == true) {
      await _removerAluno(aluno);
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

  Future<void> _editarAluno(Aluno aluno) async {
    final salvou = await showDialog<bool>(
      context: context,
      builder: (context) => _EditarAlunoDialog(
        aluno: aluno,
        onSalvar: (nome, idade, curso, email) => _api.atualizar(
          id: aluno.id,
          nome: nome,
          idade: idade,
          curso: curso,
          email: email,
        ),
      ),
    );

    if (salvou == true) {
      await _carregarAlunos();
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  InputDecoration _decoracaoCampo(String label, IconData icone) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icone),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alunosFiltrados = _alunosFiltrados;

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
                    decoration: _decoracaoCampo('Nome', Icons.person_outline),
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
                    decoration: _decoracaoCampo('Idade', Icons.cake_outlined),
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
                    decoration: _decoracaoCampo('Curso', Icons.school_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o curso';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emailController,
                    decoration: _decoracaoCampo('E-mail', Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o e-mail';
                      }
                      final regex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                      if (!regex.hasMatch(value.trim())) {
                        return 'E-mail inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _enviando ? null : _cadastrarAluno,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _enviando
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.add),
                      label: Text(_enviando ? 'Cadastrando...' : 'Cadastrar Aluno'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _pesquisaController,
              decoration: _decoracaoCampo('Pesquisar aluno', Icons.search),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Alunos cadastrados',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total de alunos: ${_alunos.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : alunosFiltrados.isEmpty
                      ? Center(
                          child: Text(
                            _alunos.isEmpty
                                ? 'Nenhum aluno cadastrado ainda.'
                                : 'Nenhum aluno encontrado.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: alunosFiltrados.length,
                          itemBuilder: (context, index) {
                            final aluno = alunosFiltrados[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(aluno.nome),
                                subtitle: Text(
                                    'Idade: ${aluno.idade} | Curso: ${aluno.curso}\nE-mail: ${aluno.email}'),
                                isThreeLine: true,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _editarAluno(aluno),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _confirmarExclusao(aluno),
                                    ),
                                  ],
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
