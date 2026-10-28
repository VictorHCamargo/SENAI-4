import 'package:flutter/material.dart';

import '../services/local_repository.dart';
import '../widgets/mapa_ilustrado.dart';
import 'resultados_screen.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({
    required this.repository,
    required this.firebaseAtivo,
    super.key,
  });

  final LocalRepository repository;
  final bool firebaseAtivo;

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  static const _cidades = ['São Paulo', 'Campinas', 'Jundiaí'];

  final _pesquisaController = TextEditingController();
  String _cidade = _cidades.first;

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  void _abrirResultados({bool somenteFavoritos = false}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResultadosScreen(
          repository: widget.repository,
          cidadeInicial: somenteFavoritos ? 'Todas' : _cidade,
          pesquisaInicial: _pesquisaController.text,
          somenteFavoritosInicial: somenteFavoritos,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _cidade,
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(16),
                            items: _cidades
                                .map(
                                  (cidade) => DropdownMenuItem(
                                    value: cidade,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Cidade selecionada',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          cidade,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (cidade) {
                              if (cidade != null) {
                                setState(() => _cidade = cidade);
                              }
                            },
                          ),
                        ),
                      ),
                      _StatusFirebase(ativo: widget.firebaseAtivo),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const Key('campo-pesquisa-mapa'),
                    controller: _pesquisaController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _abrirResultados(),
                    decoration: InputDecoration(
                      hintText: 'Buscar locais ou categorias...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        onPressed: _abrirResultados,
                        icon: const Icon(Icons.arrow_forward_rounded),
                        tooltip: 'Pesquisar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: MapaIlustrado(cidade: _cidade),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('botao-ver-resultados'),
                  onPressed: _abrirResultados,
                  icon: const Icon(Icons.list_alt_rounded),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    child: Text('Ver resultados'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (indice) {
          if (indice == 1) {
            _abrirResultados(somenteFavoritos: true);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

class _StatusFirebase extends StatelessWidget {
  const _StatusFirebase({required this.ativo});

  final bool ativo;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: ativo
          ? 'Dados sincronizados com o Cloud Firestore'
          : 'Firebase ainda não configurado; usando dados de demonstração',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(
          color: ativo ? const Color(0xFFDCFCE7) : const Color(0xFFFFF7D6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              ativo ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
              size: 16,
              color: ativo ? const Color(0xFF15803D) : const Color(0xFF9A6700),
            ),
            const SizedBox(width: 5),
            Text(
              ativo ? 'Online' : 'Demo',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: ativo
                    ? const Color(0xFF15803D)
                    : const Color(0xFF9A6700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
