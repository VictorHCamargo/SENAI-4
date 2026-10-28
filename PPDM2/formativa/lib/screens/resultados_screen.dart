import 'package:flutter/material.dart';

import '../dialogs/confirm_delete.dart';
import '../models/local.dart';
import '../services/local_repository.dart';
import '../utils/local_filters.dart';
import '../widgets/local_card.dart';
import '../widgets/local_form.dart';
import 'detalhes_screen.dart';

class ResultadosScreen extends StatefulWidget {
  const ResultadosScreen({
    required this.repository,
    required this.cidadeInicial,
    required this.pesquisaInicial,
    this.somenteFavoritosInicial = false,
    super.key,
  });

  final LocalRepository repository;
  final String cidadeInicial;
  final String pesquisaInicial;
  final bool somenteFavoritosInicial;

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  static const _cidades = ['Todas', 'São Paulo', 'Campinas', 'Jundiaí'];

  late final TextEditingController _pesquisaController;
  late String _cidade;
  String _categoria = 'Todos';
  late bool _somenteFavoritos;

  @override
  void initState() {
    super.initState();
    _pesquisaController = TextEditingController(text: widget.pesquisaInicial);
    _cidade = _cidades.contains(widget.cidadeInicial)
        ? widget.cidadeInicial
        : 'Todas';
    _somenteFavoritos = widget.somenteFavoritosInicial;
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  Future<Local?> _abrirFormulario([Local? local]) {
    return showModalBottomSheet<Local>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => LocalForm(local: local),
    );
  }

  Future<void> _cadastrar() async {
    final local = await _abrirFormulario();
    if (local == null) {
      return;
    }

    await _executarOperacao(
      operacao: () => widget.repository.adicionar(local),
      sucesso: 'Local cadastrado com sucesso.',
      erro: 'Não foi possível cadastrar o local.',
    );
  }

  Future<void> _editar(Local local) async {
    final editado = await _abrirFormulario(local);
    if (editado == null) {
      return;
    }

    await _executarOperacao(
      operacao: () => widget.repository.atualizar(editado),
      sucesso: 'Local atualizado com sucesso.',
      erro: 'Não foi possível atualizar o local.',
    );
  }

  Future<void> _excluir(Local local) async {
    final confirmou = await confirmarExclusao(context, local.nome);
    if (!confirmou || !mounted) {
      return;
    }

    await _executarOperacao(
      operacao: () => widget.repository.excluir(local.id),
      sucesso: 'Local excluido com sucesso.',
      erro: 'Não foi possível excluir o local.',
    );
  }

  Future<void> _executarOperacao({
    required Future<void> Function() operacao,
    required String sucesso,
    required String erro,
  }) async {
    try {
      await operacao();
      if (mounted) {
        _mostrarMensagem(sucesso);
      }
    } on Object catch (exception) {
      if (mounted) {
        _mostrarMensagem('$erro ${_mensagemErro(exception)}', erro: true);
      }
    }
  }

  String _mensagemErro(Object erro) {
    final texto = erro.toString();
    return texto.length > 100 ? '' : texto;
  }

  void _mostrarMensagem(String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: erro ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }

  void _abrirDetalhes(Local local) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            DetalhesScreen(repository: widget.repository, local: local),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resultados',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _somenteFavoritos = !_somenteFavoritos);
            },
            icon: Icon(
              _somenteFavoritos
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _somenteFavoritos ? const Color(0xFFE11D48) : null,
            ),
            tooltip: 'Filtrar favoritos',
          ),
        ],
      ),
      body: StreamBuilder<List<Local>>(
        stream: widget.repository.watchLocais(),
        builder: (context, snapshot) {
          return Column(
            children: [
              _Filtros(
                pesquisaController: _pesquisaController,
                cidade: _cidade,
                categoria: _categoria,
                cidades: _cidades,
                categorias: _categorias(snapshot.data ?? const []),
                onPesquisa: (_) => setState(() {}),
                onCidade: (cidade) => setState(() => _cidade = cidade),
                onCategoria: (categoria) =>
                    setState(() => _categoria = categoria),
              ),
              Expanded(child: _conteudo(snapshot)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('botao-cadastrar-local'),
        onPressed: _cadastrar,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Cadastrar'),
      ),
    );
  }

  List<String> _categorias(List<Local> locais) {
    final categorias = locais.map((local) => local.categoria).toSet().toList()
      ..sort();
    return ['Todos', ...categorias];
  }

  Widget _conteudo(AsyncSnapshot<List<Local>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting &&
        !snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return _EstadoVazio(
        icon: Icons.cloud_off_outlined,
        titulo: 'Erro ao carregar os locais',
        descricao:
            'Verifique a conexao com o Firebase e tente novamente. ${_mensagemErro(snapshot.error!)}',
      );
    }

    final locais = LocalFilters.apply(
      snapshot.data ?? const [],
      texto: _pesquisaController.text,
      cidade: _cidade,
      categoria: _categoria,
      somenteFavoritos: _somenteFavoritos,
    );

    if (locais.isEmpty) {
      return _EstadoVazio(
        icon: _somenteFavoritos
            ? Icons.favorite_border_rounded
            : Icons.search_off_rounded,
        titulo: _somenteFavoritos
            ? 'Nenhum favorito encontrado'
            : 'Nenhum local encontrado',
        descricao: 'Altere os filtros ou cadastre um novo local.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      itemCount: locais.length,
      itemBuilder: (context, indice) {
        final local = locais[indice];
        return LocalCard(
          key: ValueKey(local.id),
          local: local,
          onTap: () => _abrirDetalhes(local),
          onAcao: (acao) {
            switch (acao) {
              case AcaoLocal.editar:
                _editar(local);
              case AcaoLocal.excluir:
                _excluir(local);
            }
          },
        );
      },
    );
  }
}

class _Filtros extends StatelessWidget {
  const _Filtros({
    required this.pesquisaController,
    required this.cidade,
    required this.categoria,
    required this.cidades,
    required this.categorias,
    required this.onPesquisa,
    required this.onCidade,
    required this.onCategoria,
  });

  final TextEditingController pesquisaController;
  final String cidade;
  final String categoria;
  final List<String> cidades;
  final List<String> categorias;
  final ValueChanged<String> onPesquisa;
  final ValueChanged<String> onCidade;
  final ValueChanged<String> onCategoria;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          TextField(
            key: const Key('campo-pesquisa-resultados'),
            controller: pesquisaController,
            onChanged: onPesquisa,
            decoration: const InputDecoration(
              hintText: 'Pesquisar por nome ou categoria',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: cidade,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Cidade',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
            items: cidades
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (valor) {
              if (valor != null) {
                onCidade(valor);
              }
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, indice) {
                final item = categorias[indice];
                return FilterChip(
                  label: Text(item),
                  selected: categoria == item,
                  onSelected: (_) => onCategoria(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio({
    required this.icon,
    required this.titulo,
    required this.descricao,
  });

  final IconData icon;
  final String titulo;
  final String descricao;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54, color: Colors.black38),
            const SizedBox(height: 14),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
