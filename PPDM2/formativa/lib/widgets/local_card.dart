import 'package:flutter/material.dart';

import '../models/local.dart';

enum AcaoLocal { editar, excluir }

class LocalCard extends StatelessWidget {
  const LocalCard({
    required this.local,
    required this.onTap,
    required this.onAcao,
    super.key,
  });

  final Local local;
  final VoidCallback onTap;
  final ValueChanged<AcaoLocal> onAcao;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _iconeCategoria(local.categoria),
                  color: colorScheme.primary,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            local.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (local.favorito)
                          const Icon(
                            Icons.favorite_rounded,
                            size: 18,
                            color: Color(0xFFE11D48),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${local.categoria} • ${local.cidade}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 17),
                        Text(' ${local.distancia.toStringAsFixed(1)} km'),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: Color(0xFFF59E0B),
                        ),
                        Text(' ${local.avaliacao.toStringAsFixed(1)}'),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<AcaoLocal>(
                onSelected: onAcao,
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: AcaoLocal.editar,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Editar'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: AcaoLocal.excluir,
                    child: ListTile(
                      leading: Icon(Icons.delete_outline_rounded),
                      title: Text('Excluir'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconeCategoria(String categoria) {
    return switch (categoria) {
      'Academia' => Icons.fitness_center_rounded,
      'Restaurante' => Icons.restaurant_rounded,
      'Hospital' => Icons.local_hospital_rounded,
      'Cafeteria' => Icons.local_cafe_rounded,
      'Mercado' => Icons.shopping_basket_rounded,
      'Lazer' => Icons.park_rounded,
      _ => Icons.place_rounded,
    };
  }
}
