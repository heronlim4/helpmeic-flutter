import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HELPMe - IC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue, // Cor primária
        hintColor: Colors.lightBlue, // Cor de destaque
      ),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indiceSelecionado = 0;

  final List<Widget> _telas = [
    const TelaRepositorio(),
    const TelaAgenda(),
    const TelaEventosAcademicos(),
  ];

  void _aoClicarNoBotao(int indice) {
    setState(() {
      _indiceSelecionado = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELPMe - IC"),
      ),
      body: _telas[_indiceSelecionado],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                _aoClicarNoBotao(0);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor, // Cor do texto do botão
              ),
              child: const Text('Repositório'),
            ),
            ElevatedButton(
              onPressed: () {
                _aoClicarNoBotao(1);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor, // Cor do texto do botão
              ),
              child: const Text('Agenda'),
            ),
            ElevatedButton(
              onPressed: () {
                _aoClicarNoBotao(2);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor, // Cor do texto do botão
              ),
              child: const Text('Eventos'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaRepositorio extends StatefulWidget {
  const TelaRepositorio({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaRepositorioState createState() => _TelaRepositorioState();
}

class _TelaRepositorioState extends State<TelaRepositorio> {
  final List<Recurso> _recursos = [
    Recurso(
      titulo: "Introdução à Programação em Python",
      descricao: "Apostila de Introdução à Programação em Python",
      disciplina: "Programação",
    ),
    Recurso(
      titulo: "Algoritmos Avançados",
      descricao: "Vídeo sobre Algoritmos Avançados em C++",
      disciplina: "Algoritmos",
    ),
  ];

  List<Recurso> _recursosFiltrados = [];

  @override
  void initState() {
    _recursosFiltrados = _recursos;
    super.initState();
  }

  void _filtrarRecursos(String termoBusca) {
    setState(() {
      _recursosFiltrados = _recursos
          .where((recurso) =>
              recurso.titulo.toLowerCase().contains(termoBusca.toLowerCase()) ||
              recurso.disciplina.toLowerCase().contains(termoBusca.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Repositório"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (termoBusca) {
                _filtrarRecursos(termoBusca);
              },
              decoration: const InputDecoration(
                labelText: "Pesquisar por disciplina ou assunto",
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _recursosFiltrados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_recursosFiltrados[index].titulo),
                  subtitle: Text(_recursosFiltrados[index].descricao),
                  onTap: () {
                    // Adicione aqui o código para abrir o recurso selecionado.
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Recurso {
  final String titulo;
  final String descricao;
  final String disciplina;

  Recurso({
    required this.titulo,
    required this.descricao,
    required this.disciplina,
  });
}

class TelaAgenda extends StatefulWidget {
  const TelaAgenda({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TelaAgendaState createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda> {
  final List<ItemAgenda> _itensAgenda = [];

  @override
  Widget build(BuildContext context) {
    _itensAgenda.sort((a, b) => a.data.compareTo(b.data)); // Ordenar por data

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
      ),
      body: ListView.builder(
        itemCount: _itensAgenda.length,
        itemBuilder: (context, index) {
          final item = _itensAgenda[index];
          return ListTile(
            title: Text(item.titulo),
            subtitle: Text(item.descricao),
            trailing: Text(item.data), // Mostrar a data
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirDialogoAdicionarItemAgenda(context);
        },
        backgroundColor: Colors.blue, // Cor do botão de adicionar
        splashColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _exibirDialogoAdicionarItemAgenda(BuildContext context) {
    final controladorTitulo = TextEditingController();
    final controladorDescricao = TextEditingController();
    final controladorData = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar Atividade"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controladorTitulo,
                decoration: const InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: controladorDescricao,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              TextField(
                controller: controladorData,
                decoration: const InputDecoration(labelText: "Data (Formato: dd/mm/yyyy)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                final data = controladorData.text;
                final dataParts = data.split('/'); // Dividir a data em dia, mês e ano
                if (dataParts.length == 3) {
                  final dia = int.tryParse(dataParts[0]);
                  final mes = int.tryParse(dataParts[1]);
                  final ano = int.tryParse(dataParts[2]);
                  if (dia != null && mes != null && ano != null) {
                    if (dia >= 1 && dia <= 31 && mes >= 1 && mes <= 12 && ano >= 1900) {
                      final dataFormatada = '$dia/$mes/$ano';
                      setState(() {
                        _itensAgenda.add(ItemAgenda(
                          titulo: controladorTitulo.text,
                          descricao: controladorDescricao.text,
                          data: dataFormatada,
                        ));
                        _itensAgenda.sort((a, b) => a.data.compareTo(b.data)); // Ordenar por data
                        controladorTitulo.clear();
                        controladorDescricao.clear();
                        controladorData.clear();
                        Navigator.pop(context);
                      });
                    } else {
                      // Tratar erro de data fora do intervalo
                    }
                  } else {
                    // Tratar erro de formato de data inválida
                  }
                } else {
                  // Tratar erro de formato de data inválida
                }
              },
              child: const Text(
                "Salvar",
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ItemAgenda {
  final String titulo;
  final String descricao;
  final String data;

  ItemAgenda({
    required this.titulo,
    required this.descricao,
    required this.data,
  });
}

class TelaEventosAcademicos extends StatelessWidget {
  const TelaEventosAcademicos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eventos Acadêmicos"),
      ),
      body: const Center(
        child: Text("Esta é a tela de Eventos Acadêmicos."),
      ),
    );
  }
}
