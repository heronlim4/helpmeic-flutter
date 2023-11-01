import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HELPMe - IC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RepositoryScreen(),
    AgendaScreen(),
    AcademicEventsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HELPMe - IC"),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Repositório',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.calendar),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos Acadêmicos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RepositoryScreen extends StatefulWidget {
  @override
  _RepositoryScreenState createState() => _RepositoryScreenState();
}

class _RepositoryScreenState extends State<RepositoryScreen> {
  final List<Recurso> _recursos = [
    Recurso(
      title: "Introdução à Programação",
      description: "Apostila de Introdução à Programação em Python",
      subject: "Programação",
    ),
    Recurso(
      title: "Algoritmos Avançados",
      description: "Vídeo sobre Algoritmos Avançados em C++",
      subject: "Algoritmos",
    ),
    // Adicione mais recursos com diferentes disciplinas e assuntos aqui
  ];

  List<Recurso> _filteredRecursos = [];

  @override
  void initState() {
    _filteredRecursos = _recursos; // Inicialmente, a lista filtrada é igual à lista completa
    super.initState();
  }

  void _filterRecursos(String searchTerm) {
    setState(() {
      _filteredRecursos = _recursos
          .where((recurso) =>
              recurso.title.toLowerCase().contains(searchTerm.toLowerCase()) ||
              recurso.subject.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repositório"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (searchTerm) {
                _filterRecursos(searchTerm);
              },
              decoration: InputDecoration(labelText: "Pesquisar por disciplina ou assunto"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredRecursos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredRecursos[index].title),
                  subtitle: Text(_filteredRecursos[index].description),
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
  final String title;
  final String description;
  final String subject;

  Recurso({required this.title, required this.description, required this.subject});
}


class AgendaScreen extends StatefulWidget {
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final List<AgendaItem> _agendaItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
      ),
      body: ListView.builder(
        itemCount: _agendaItems.length,
        itemBuilder: (context, index) {
          final item = _agendaItems[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAgendaItemDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAgendaItemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Atividade"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Título"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Descrição"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _agendaItems.add(AgendaItem(
                    title: titleController.text,
                    description: descriptionController.text,
                  ));
                  titleController.clear();
                  descriptionController.clear();
                  Navigator.pop(context);
                });
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}

class AcademicEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eventos Acadêmicos"),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Evento #$index"),
            subtitle: Text("Descrição do evento #$index"),
          );
        },
      ),
    );
  }
}

class AgendaItem {
  final String title;
  final String description;

  AgendaItem({required this.title, required this.description});
}
