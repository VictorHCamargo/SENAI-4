final LocalService service = LocalService();
StreamBuilder<List<Local>>(
stream: service.listarLocais(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}
if (snapshot.hasError) {
return const Center(
child: Text('Erro ao carregar os locais.'),
);
}
final locais = snapshot.data ?? [];
if (locais.isEmpty) {
return const Center(
child: Text('Nenhum local encontrado.'),
);
}
return ListView.builder(
itemCount: locais.length,
itemBuilder: (context, index) {
final local = locais[index];
return ListTile(
title: Text(local.nome),
subtitle: Text(local.categoria),
onTap: () {

// abrir detalhes
},
);
},
);
},
)