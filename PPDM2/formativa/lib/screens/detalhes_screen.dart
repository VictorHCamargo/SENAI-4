import 'package:flutter/material.dart';

import '../models/local.dart';
import '../services/local_repository.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen({
    required this.repository,
    required this.local,
    super.key,
  });

  final LocalRepository repository;
  final Local local;

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  late Local _local;
  bool _salvandoFavorito = false;

  @override
  void initState() {
    super.initState();
    _local = widget.local;
  }

  Future<void> _alternarFavorito() async {
    if (_salvandoFavorito) {
      return;
    }

    final novoValor = !_local.favorito;
    setState(() {
      _salvandoFavorito = true;
      _local = _local.copyWith(favorito: novoValor);
    });

    try {
      await widget.repository.alterarFavorito(_local.id, novoValor);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              novoValor
                  ? 'Local adicionado aos favoritos.'
                  : 'Local removido dos favoritos.',
            ),
          ),
        );
      }
    } on Object catch (_) {
      if (mounted) {
        setState(() => _local = _local.copyWith(favorito: !novoValor));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Não foi possível alterar o favorito.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _salvandoFavorito = false);
      }
    }
  }

  void _verNoMapa() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do local'),
        actions: [
          IconButton(
            key: const Key('botao-favorito'),
            onPressed: _salvandoFavorito ? null : _alternarFavorito,
            icon: Icon(
              _local.favorito
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _local.favorito ? const Color(0xFFE11D48) : null,
            ),
            tooltip: 'Favoritar',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDBEAFE), Color(0xFFEDE9FE)],
              ),
            ),
            child: const Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.location_city_rounded,
                    size: 86,
                    color: Color(0xFF64748B),
                  ),
                ),
                Positioned(
                  right: 14,
                  bottom: 14,
                  child: Chip(label: Text('1/1')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _local.nome,
            style: Theme.of(context).textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            _local.categoria,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFF59E0B),
                size: 22,
              ),
              const SizedBox(width: 4),
              Text(
                _local.avaliacao.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 4),
              Text('${_local.distancia.toStringAsFixed(1)} km'),
            ],
          ),
          const SizedBox(height: 18),
          _Informacao(
            icon: Icons.location_city_outlined,
            titulo: 'Cidade',
            valor: _local.cidade,
          ),
          _Informacao(
            icon: Icons.schedule_outlined,
            titulo: 'Horário',
            valor: _local.horario,
          ),
          const Divider(height: 32),
          Text(
            'Sobre',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            _local.descricao,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            key: const Key('botao-ver-no-mapa'),
            onPressed: _verNoMapa,
            icon: const Icon(Icons.location_on_rounded),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text('Ver no mapa'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Informacao extends StatelessWidget {
  const _Informacao({
    required this.icon,
    required this.titulo,
    required this.valor,
  });

  final IconData icon;
  final String titulo;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  valor,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
