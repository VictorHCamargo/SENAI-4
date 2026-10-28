import 'package:flutter/material.dart';

import '../models/local.dart';

class LocalForm extends StatefulWidget {
  const LocalForm({this.local, super.key});

  final Local? local;

  @override
  State<LocalForm> createState() => _LocalFormState();
}

class _LocalFormState extends State<LocalForm> {
  static const _categorias = [
    'Academia',
    'Restaurante',
    'Hospital',
    'Cafeteria',
    'Mercado',
    'Lazer',
    'Outro',
  ];
  static const _cidades = ['São Paulo', 'Campinas', 'Jundiaí'];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _horarioController;
  late final TextEditingController _avaliacaoController;
  late final TextEditingController _distanciaController;
  late final TextEditingController _descricaoController;
  late String _categoria;
  late String _cidade;

  @override
  void initState() {
    super.initState();
    final local = widget.local;
    _nomeController = TextEditingController(text: local?.nome ?? '');
    _horarioController = TextEditingController(text: local?.horario ?? '');
    _avaliacaoController = TextEditingController(
      text: local?.avaliacao.toStringAsFixed(1) ?? '',
    );
    _distanciaController = TextEditingController(
      text: local?.distancia.toStringAsFixed(1) ?? '',
    );
    _descricaoController = TextEditingController(text: local?.descricao ?? '');
    _categoria = _categorias.contains(local?.categoria)
        ? local!.categoria
        : _categorias.first;
    _cidade = _cidades.contains(local?.cidade) ? local!.cidade : _cidades.first;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _horarioController.dispose();
    _avaliacaoController.dispose();
    _distanciaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  double? _numero(String valor) {
    return double.tryParse(valor.trim().replaceAll(',', '.'));
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final atual = widget.local;
    Navigator.of(context).pop(
      Local(
        id: atual?.id ?? '',
        nome: _nomeController.text.trim(),
        categoria: _categoria,
        cidade: _cidade,
        avaliacao: _numero(_avaliacaoController.text)!,
        distancia: _numero(_distanciaController.text)!,
        horario: _horarioController.text.trim(),
        descricao: _descricaoController.text.trim(),
        favorito: atual?.favorito ?? false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editando = widget.local != null;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  editando ? 'Editar local' : 'Cadastrar local',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.storefront_outlined),
                  ),
                  validator: (valor) => valor == null || valor.trim().length < 3
                      ? 'Informe um nome com ao menos 3 caracteres.'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _categoria,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
                        items: _categorias
                            .map(
                              (categoria) => DropdownMenuItem(
                                value: categoria,
                                child: Text(categoria),
                              ),
                            )
                            .toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() => _categoria = valor);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _cidade,
                        decoration: const InputDecoration(labelText: 'Cidade'),
                        items: _cidades
                            .map(
                              (cidade) => DropdownMenuItem(
                                value: cidade,
                                child: Text(cidade),
                              ),
                            )
                            .toList(),
                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() => _cidade = valor);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _horarioController,
                  decoration: const InputDecoration(
                    labelText: 'Horário',
                    hintText: '08:00 - 18:00',
                    prefixIcon: Icon(Icons.schedule_outlined),
                  ),
                  validator: (valor) => valor == null || valor.trim().isEmpty
                      ? 'Informe o horario.'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _avaliacaoController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Avaliação',
                          hintText: '0 a 5',
                        ),
                        validator: (valor) {
                          final numero = _numero(valor ?? '');
                          return numero == null || numero < 0 || numero > 5
                              ? 'Use um valor de 0 a 5.'
                              : null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _distanciaController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Distancia (km)',
                        ),
                        validator: (valor) {
                          final numero = _numero(valor ?? '');
                          return numero == null || numero < 0
                              ? 'Informe uma distancia valida.'
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    alignLabelWithHint: true,
                  ),
                  validator: (valor) =>
                      valor == null || valor.trim().length < 10
                      ? 'Descreva o local com ao menos 10 caracteres.'
                      : null,
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: _salvar,
                  icon: const Icon(Icons.save_outlined),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(editando ? 'Salvar alteracoes' : 'Cadastrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
