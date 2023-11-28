import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _TelaPrincipalState extends State<TelaPrincipal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _indiceSelecionado = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      initialIndex: _indiceSelecionado,
      vsync: this,
    );

    // Adicione este ouvinte para sincronizar o TabController com a BottomNavigationBar
    _tabController.addListener(() {
      setState(() {
        _indiceSelecionado = _tabController.index;
      });
    });
  }

  void _aoClicarNaAba(int indice) {
    setState(() {
      _indiceSelecionado = indice;
      _tabController.animateTo(
          indice); // Adicione esta linha para sincronizar o TabController
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HELPMe - IC"),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TelaRepositorio(),
          TelaAgenda(),
          TelaEventosAcademicos(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceSelecionado,
        onTap: _aoClicarNaAba,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Repositório',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Eventos',
          ),
        ],
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
  final _controllerPesquisa = TextEditingController();

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
              recurso.descricao
                  .toLowerCase()
                  .contains(termoBusca.toLowerCase()) ||
              recurso.disciplina
                  .toLowerCase()
                  .contains(termoBusca.toLowerCase()))
          .toList();
    });
  }

  void _limparPesquisa() {
    setState(() {
      _controllerPesquisa.clear();
      _recursosFiltrados = _recursos;
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
              controller: _controllerPesquisa,
              onChanged: (termoBusca) {
                _filtrarRecursos(termoBusca);
              },
              decoration: InputDecoration(
                labelText: "Pesquisar por disciplina ou assunto",
                labelStyle: const TextStyle(color: Colors.blue),
                suffixIcon: IconButton(
                  onPressed: _limparPesquisa,
                  icon: const Icon(Icons.clear),
                  color: Colors.grey,
                ),
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
                    // add código para abrir o recurso selecionado.
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _exibirDialogoSelecionarCurso(context);
        },
        backgroundColor: Colors.blue,
        splashColor: Colors.lightBlueAccent,
        child: const Icon(Icons.table_rows_outlined),
      ),
    );
  }
}

void _exibirDialogoSelecionarCurso(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Selecione um Curso"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaGradeCurricular(curso: "BCC")),
                );
              },
              child: const Text("BCC"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaGradeCurricular(curso: "LC")),
                );
              },
              child: const Text("LC"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaGradeCurricular(curso: "BSI")),
                );
              },
              child: const Text("BSI"),
            ),
          ],
        ),
      );
    },
  );
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
  State<TelaAgenda> createState() => _TelaAgendaState();
}

class _TelaAgendaState extends State<TelaAgenda>
    with AutomaticKeepAliveClientMixin {
  final List<ItemAgenda> _itensAgenda = [];

  @override
  void initState() {
    super.initState();
    // Carregar itens da agenda de um arquivo ou banco de dados
  }

  @override
  Widget build(BuildContext context) {
    _itensAgenda.sort((a, b) => a.data.compareTo(b.data)); // Ordenar por data

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda"),
      ),
      body: ListView.separated(
        itemCount: _itensAgenda.length,
        itemBuilder: (context, index) {
          final item = _itensAgenda[index];
          return ListTile(
            onTap: () {
              _exibirDialogoVisualizarItemAgenda(context, item);
            },
            title: Text(item.titulo),
            subtitle: Column(
              children: [
                Text(item.descricao),
                Text(item.data),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _exibirDialogoEditarItemAgenda(context, item, index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _excluirItemAgenda(index);
                  },
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            color: Colors.black, // Mostrar a data
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

  @override
  bool get wantKeepAlive => true;

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
                decoration: const InputDecoration(
                    labelText: "Data (Formato: dd/mm/yyyy)"),
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
                final dataParts =
                    data.split('/'); // Dividir a data em dia, mês e ano
                if (dataParts.length == 3) {
                  final dia = int.tryParse(dataParts[0]);
                  final mes = int.tryParse(dataParts[1]);
                  final ano = int.tryParse(dataParts[2]);
                  if (dia != null && mes != null && ano != null) {
                    if (dia >= 1 &&
                        dia <= 31 &&
                        mes >= 1 &&
                        mes <= 12 &&
                        ano >= 1900) {
                      final dataFormatada = '$dia/$mes/$ano';
                      setState(() {
                        _itensAgenda.add(ItemAgenda(
                          titulo: controladorTitulo.text,
                          descricao: controladorDescricao.text,
                          data: dataFormatada,
                        ));
                        _itensAgenda.sort((a, b) =>
                            a.data.compareTo(b.data)); // Ordenar por data
                        controladorTitulo.clear();
                        controladorDescricao.clear();
                        controladorData.clear();
                        Navigator.pop(context);
                      });
                    } else {
                      _exibirMensagemErro(context, "Data Inválida");
                    }
                  } else {
                    _exibirMensagemErro(context, "Data Inválida");
                  }
                } else {
                  _exibirMensagemErro(context, "Data Inválida");
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

  void _exibirDialogoVisualizarItemAgenda(
      BuildContext context, ItemAgenda item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.titulo),
          content: Text(item.descricao),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  void _exibirDialogoEditarItemAgenda(
      BuildContext context, ItemAgenda item, int index) {
    final controladorTitulo = TextEditingController(text: item.titulo);
    final controladorDescricao = TextEditingController(text: item.descricao);
    final controladorData = TextEditingController(text: item.data);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Atividade"),
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
                decoration: const InputDecoration(
                    labelText: "Data (Formato: dd/mm/yyyy)"),
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
                final dataParts =
                    data.split('/'); // Dividir a data em dia, mês e ano
                if (dataParts.length == 3) {
                  final dia = int.tryParse(dataParts[0]);
                  final mes = int.tryParse(dataParts[1]);
                  final ano = int.tryParse(dataParts[2]);
                  if (dia != null && mes != null && ano != null) {
                    if (dia >= 1 &&
                        dia <= 31 &&
                        mes >= 1 &&
                        mes <= 12 &&
                        ano >= 1900) {
                      final dataFormatada = '$dia/$mes/$ano';
                      setState(() {
                        _itensAgenda[index] = ItemAgenda(
                          titulo: controladorTitulo.text,
                          descricao: controladorDescricao.text,
                          data: dataFormatada,
                        );
                        controladorTitulo.clear();
                        controladorDescricao.clear();
                        controladorData.clear();
                        Navigator.pop(context);
                      });
                    } else {
                      _exibirMensagemErro(context, "Data Inválida");
                    }
                  } else {
                    _exibirMensagemErro(context, "Data Inválida");
                  }
                } else {
                  _exibirMensagemErro(context, "Data Inválida");
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

  void _exibirMensagemErro(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Erro"),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _excluirItemAgenda(int index) {
    setState(() {
      _itensAgenda.removeAt(index);
    });
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
  const TelaEventosAcademicos({super.key});

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

class TelaGradeCurricular extends StatelessWidget {
  final String curso;

  TelaGradeCurricular({required this.curso});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grade Curricular - $curso"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (curso == 'BSI') TabelaGradeCurricularBSI(),
            if (curso == 'BCC') TabelaGradeCurricularBCC(),
            if (curso == 'LC') TabelaGradeCurricularLC(),
          ],
        ),
      ),
    );
  }
}

class TabelaGradeCurricularBSI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 15.0,
        columns: [
          DataColumn(
            label: Text(
              'Semestre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Código',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Disciplina',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: [
          _buildRow('1° Semestre', 'MATA02', 'CÁLCULO A',
              'https://drive.google.com/drive/folders/1wtZU9kLYrHhm1cP-S9lut_wZHAILW8fL'),
          _buildRow(
              '1° Semestre',
              'MATA37',
              'INTRODUÇÃO À LÓGICA DE PROGRAMAÇÃO',
              'https://drive.google.com/drive/folders/10bMbnjWbsfNVxonl-IKUG4tcBpTaxlf4'),
          _buildRow(
              '1° Semestre',
              'MATA39',
              'SEMINÁRIOS DE INTRODUÇÃO AO CURSO',
              'https://drive.google.com/drive/folders/10eYXZzNIF5iiTJpbsg6hS-s03wD34jGH'),
          _buildRow('1° Semestre', 'MATA42', 'MATEMÁTICA DISCRETA I',
              'https://drive.google.com/drive/folders/10wQKkBNXNyDra4fKvjNLdocd5NavbOch'),
          _buildRow('1° Semestre', 'MATA68', 'COMPUTADOR, ÉTICA E SOCIEDADE',
              'https://drive.google.com/drive/folders/10u0LDb0x5ifuXkZUzJ_0qDc5H4fcqXHv'),
          _buildRow('2° Semestre', 'ADME99', 'ECONOMIA DA INOVAÇÃO', ''),
          _buildRow(
              '2° Semestre', 'MATC73', 'INTRODUÇÃO À LÓGICA MATEMÁTICA', ''),
          _buildRow('2° Semestre', 'MATC90',
              'CIRCUITOS DIGITAIS E ARQUITETURA DE COMPUTADORES', ''),
          _buildRow('2° Semestre', 'MATC92',
              'FUNDAMENTOS DE SISTEMAS DE INFORMAÇÃO', ''),
          _buildRow('2° Semestre', 'MATD04', 'ESTRUTURAS DE DADOS', ''),
          _buildRow('3° Semestre', 'ADM001', 'INTRODUCAO À ADMINISTRACAO', ''),
          _buildRow('3° Semestre', 'MATA07', 'ÁLGEBRA LINEAR A', ''),
          _buildRow(
              '3° Semestre', 'MATA55', 'PROGRAMAÇÃO ORIENTADA A OBJETOS', ''),
          _buildRow('3° Semestre', 'MATA58', 'SISTEMAS OPERACIONAIS', ''),
          _buildRow('3° Semestre', 'MATC94',
              'INTRODUÇÃO AS LINGUAGENS FORMAIS E TEORIA DA COMPUTAÇÃO', ''),
          _buildRow('4° Semestre', 'LETA09',
              'OFICINA DE LEITURA E PRODUÇÃO DE TEXTOS', ''),
          _buildRow('4° Semestre', 'MAT236', 'MÉTODOS ESTATÍSTICOS', ''),
          _buildRow('4° Semestre', 'MATA59', 'REDES DE COMPUTADORES I', ''),
          _buildRow('4° Semestre', 'MATA62', 'ENGENHARIA DE SOFTWARE I', ''),
          _buildRow('4° Semestre', 'MATC82', 'SISTEMAS WEB', ''),
          _buildRow('5° Semestre', 'ADM211',
              'MÉTODOS QUANTITATIVOS APLICADOS À ADMINISTRAÇÃO', ''),
          _buildRow('5° Semestre', 'MATA56',
              'PARADIGMAS DE LINGUAGENS DE PROGRAMAÇÃO', ''),
          _buildRow('5° Semestre', 'MATA60', 'BANCO DE DADOS', ''),
          _buildRow('5° Semestre', 'MATA63', 'ENGENHARIA DE SOFTWARE II', ''),
          _buildRow(
              '5° Semestre', 'MATC84', 'LABORATÓRIO DE PROGRAMAÇÃO WEB', ''),
          _buildRow('6° Semestre', 'ADMF01', 'SISTEMAS DE APOIO À DECISÃO', ''),
          _buildRow(
              '6° Semestre', 'MAT220', 'EMPREENDEDORES EM INFORMATICA', ''),
          _buildRow('6° Semestre', 'MATA76',
              'LINGUAGENS PARA APLICAÇÃO COMERCIAL', ''),
          _buildRow(
              '6° Semestre', 'MATB09', 'LABORATÓRIO DE BANCO DE DADOS', ''),
          _buildRow('6° Semestre', 'MATC89',
              'APLICAÇÕES PARA DISPOSITIVOS MÓVEIS', ''),
          _buildRow('7° Semestre', 'MATA64', 'INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('7° Semestre', 'MATB02', 'QUALIDADE DE SOFTWARE', ''),
          _buildRow('7° Semestre', 'MATB19', 'SISTEMAS MULTIMÍDIA', ''),
          _buildRow('7° Semestre', 'MATC72', 'INTERAÇÃO HUMANO-COMPUTADOR', ''),
          _buildRow('7° Semestre', 'MATC99',
              'SEGURANÇA E AUDITORIA DE SISTEMAS DE INFORMAÇÃO', ''),
          _buildRow(
              'TCC', 'MATC97', 'TCC BACHARELADO SISTEMAS DE INFORMAÇÃO I', ''),
          _buildRow(
              'TCC', 'MATC98', 'TCC BACHARELADO SISTEMAS DE INFORMAÇÃO II', ''),
          _buildRow('Optativas', 'MATC88',
              'ADMINISTRAÇÃO DE REDES DE COMPUTADORES', ''),
          _buildRow(
              'Optativas', 'MATC91', 'COMUNIDADES E AMBIENTES VIRTUAIS', ''),
          _buildRow('Optativas', 'FCC024', 'CONTABILIDADE DE CUSTOS', ''),
          _buildRow('Optativas', 'ECO001', 'FUNDAMENTOS DE ECONOMIA', ''),
          _buildRow('Optativas', 'MATA88',
              'FUNDAMENTOS DE SISTEMAS DISTRIBUÍDOS', ''),
          _buildRow('Optativas', 'MATD55',
              'INFORMÁTICA EM SAÚDE PARA SISTEMAS DE INFORMAÇÃO', ''),
          _buildRow('Optativas', 'MATC93', 'INTRODUÇÃO A WEB SEMÂNTICA', ''),
          _buildRow('Optativas', 'ADM241', 'INTRODUCAO AO MARKETING', ''),
          _buildRow(
              'Optativas', 'MATC95', 'LABORATÓRIO DE INFORMÁTICA MÉDICA', ''),
          _buildRow('Optativas', 'MATB16',
              'LABORATÓRIO DE INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATA57', 'LABORATÓRIO DE PROGRAMAÇÃO I', ''),
          _buildRow('Optativas', 'LETC84',
              'LEITURA DE TEXTOS ACADÊMICOS EM LINGUA INGLESA', ''),
          _buildRow(
              'Optativas', 'LETA15', 'LEITURA DE TEXTOS EM LINGUA INGLESA', ''),
          _buildRow(
              'Optativas', 'LETE46', 'Libras-Língua Brasileira de Sinais', ''),
          _buildRow('Optativas', 'MATC96',
              'ORGANIZAÇÃO, GERENCIAMENTO E RECUPERAÇÃO DA INFORMAÇÃO', ''),
          _buildRow(
              'Optativas', 'MATA49', 'PROGRAMAÇÃO DE SOFTWARE BÁSICO', ''),
          _buildRow(
              'Optativas', 'MATD01', 'TELEMEDICINA E IMAGENS MÉDICAS', ''),
          _buildRow(
              'Optativas', 'MATD02', 'TÓPICOS EM SISTEMAS DE INFORMAÇÃO', ''),
        ],
      ),
    );
  }

  DataRow _buildRow(
      String semestre, String codigo, String disciplina, String link) {
    return DataRow(cells: [
      DataCell(Text(semestre)),
      DataCell(Text(codigo)),
      DataCell(InkWell(
        onTap: () {
          // Adicione a lógica para abrir o link
          _abrirLink(link);
        },
        child: Text(disciplina, style: TextStyle(color: Colors.blue)),
      )),
      DataCell(Text('')), // Espaço para adição do link
    ]);
  }

  void _abrirLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}

class TabelaGradeCurricularBCC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 15.0,
        columns: [
          DataColumn(
            label: Text(
              'Semestre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Código',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Disciplina',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: [
          _buildRow('1° Semestre', 'MATA01', 'GEOMETRIA ANALÍTICA', ''),
          _buildRow('1° Semestre', 'MATA02', 'CÁLCULO A',
              'https://drive.google.com/drive/folders/1wtZU9kLYrHhm1cP-S9lut_wZHAILW8fL'),
          _buildRow(
              '1° Semestre',
              'MATA37',
              'INTRODUÇÃO À LÓGICA DE PROGRAMAÇÃO',
              'https://drive.google.com/drive/folders/10bMbnjWbsfNVxonl-IKUG4tcBpTaxlf4'),
          _buildRow(
              '1° Semestre', 'MATA38', 'PROJETO DE CIRCUITOS LÓGICOS', ''),
          _buildRow(
              '1° Semestre',
              'MATA39',
              'SEMINÁRIOS DE INTRODUÇÃO AO CURSO',
              'https://drive.google.com/drive/folders/10eYXZzNIF5iiTJpbsg6hS-s03wD34jGH'),
          _buildRow('1° Semestre', 'MATA42', 'MATEMÁTICA DISCRETA I',
              'https://drive.google.com/drive/folders/10wQKkBNXNyDra4fKvjNLdocd5NavbOch'),
          _buildRow('2° Semestre', 'MATA07', '	ÁLGEBRA LINEAR A', ''),
          _buildRow('2° Semestre', 'MATA40',
              'ESTRUTURAS DE DADOS E ALGORITMOS I', ''),
          _buildRow('2° Semestre', 'MATA48', 'ARQUITETURA DE COMPUTADORES', ''),
          _buildRow(
              '2° Semestre', 'MATA57', 'LABORATÓRIO DE PROGRAMAÇÃO I', ''),
          _buildRow('2° Semestre', 'MATA95', 'COMPLEMENTOS DE CÁLCULO', ''),
          _buildRow('2° Semestre', 'MATA97', 'MATEMÁTICA DISCRETA II', ''),
          _buildRow('3° Semestre', 'FISA75',
              'ELEMENTOS DO ELETROMAGNETISMO E DE CIRCUITOS ELÉTRICOS', ''),
          _buildRow('3° Semestre', 'MAT236', 'MÉTODOS ESTATÍSTICOS', ''),
          _buildRow('3° Semestre', 'MATA47', 'LÓGICA PARA COMPUTAÇÃO', ''),
          _buildRow(
              '3° Semestre', 'MATA49', 'PROGRAMAÇÃO DE SOFTWARE BÁSICO', ''),
          _buildRow(
              '3° Semestre', 'MATA50', 'LINGUAGENS FORMAIS E AUTÔMATOS', ''),
          _buildRow(
              '3° Semestre', 'MATA55', 'PROGRAMAÇÃO ORIENTADA A OBJETOS', ''),
          _buildRow('4° Semestre', 'FCHC45',
              'METODOLOGIA E EXPRESSÃO TÉCNICO-CIENTÍFICA', ''),
          _buildRow('4° Semestre', 'MATA51', 'TEORIA DA COMPUTAÇÃO', ''),
          _buildRow(
              '4° Semestre', 'MATA52', 'ANÁLISE E PROJETO DE ALGORITMOS', ''),
          _buildRow('4° Semestre', 'MATA58', 'SISTEMAS OPERACIONAIS', ''),
          _buildRow('4° Semestre', 'MATA61', 'COMPILADORES', ''),
          _buildRow('4° Semestre', 'MATA68', 'COMPUTADOR, ÉTICA E SOCIEDADE',
              'https://drive.google.com/drive/folders/10u0LDb0x5ifuXkZUzJ_0qDc5H4fcqXHv'),
          _buildRow('5° Semestre', 'MATA53', 'TEORIA DOS GRAFOS', ''),
          _buildRow('5° Semestre', 'MATA54',
              '	ESTRUTURAS DE DADOS E ALGORITMOS II', ''),
          _buildRow('5° Semestre', 'MATA59', 'REDES DE COMPUTADORES I', ''),
          _buildRow('5° Semestre', 'MATA62', 'ENGENHARIA DE SOFTWARE I', ''),
          _buildRow('5° Semestre', 'MATE12',
              'PARADIGMAS DE LINGUAGENS DE PROGRAMAÇÃO A', ''),
          _buildRow('6° Semestre', 'MATA60', 'BANCO DE DADOS', ''),
          _buildRow('6° Semestre', 'MATA64', 'INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('6° Semestre', 'MATA65', 'COMPUTAÇÃO GRÁFICA', ''),
          _buildRow('6° Semestre', 'MATA88',
              'FUNDAMENTOS DE SISTEMAS DISTRIBUÍDOS', ''),
          _buildRow('6° Semestre', 'MATE11', 'ENGENHARIA DE SOFTWARE II-A', ''),
          _buildRow('7° Semestre', 'MATA66', 'PROJETO FINAL DE CURSO I', ''),
          _buildRow('8° Semestre', 'MATA67', 'PROJETO FINAL DE CURSO II', ''),
          _buildRow('Optativas', 'ADM170', 'ADMINISTRACAO CONTABIL I', ''),
          _buildRow('Optativas', 'MATC88',
              'ADMINISTRAÇÃO DE REDES DE COMPUTADORES', ''),
          _buildRow('Optativas', 'MATA90', 'ALGORITMOS DISTRIBUIDOS', ''),
          _buildRow('Optativas', 'MATD74', '	ALGORITMOS E GRAFOS', ''),
          _buildRow('Optativas', 'MATB21',
              '	AMBIENTES INTERATIVOS DE APRENDIZAGEM', ''),
          _buildRow(
              'Optativas', 'ENG637', 'ANALISE DINAMICA DE ESTRUTURAS', ''),
          _buildRow('Optativas', 'ENG229',
              '	APLICAÇÕES INDUSTRIAIS DA COMPUTAÇÃO', ''),
          _buildRow(
              'Optativas', 'MATC89', 'APLICAÇÕES PARA DISPOSITIVOS MÓVEIS', ''),
          _buildRow(
              'Optativas', 'ENG653', 'AQUISICAO DE DADOS EM TEMPO REAL', ''),
          _buildRow('Optativas', 'MATA15', 'ARQUITETURA DE COMPUTADORES', ''),
          _buildRow('Optativas', 'MATE67', 'ARQUITETURA DE SOFTWARE', ''),
          _buildRow('Optativas', 'MATA89',
              'ARQUITETURAS DE SISTEMAS DISTRIBUÍDOS', ''),
          _buildRow('Optativas', 'ENG646', 'AUTOMACAO DE SISTEMAS', ''),
          _buildRow('Optativas', 'MATE68', 'BANCO DE DADOS', ''),
          _buildRow('Optativas', 'MATA04', 'CÁLCULO C', ''),
          _buildRow('Optativas', 'MATA05', 'CÁLCULO D', ''),
          _buildRow('Optativas', 'MAT174', 'CÁLCULO NUMÉRICO I', ''),
          _buildRow('Optativas', 'MATE69', 'COMPUTAÇÃO DISTRIBUÍDA', ''),
          _buildRow('Optativas', 'MATE70',
              'COMPUTAÇÃO UBÍQUA E SENSÍVEL AO CONTEXTO', ''),
          _buildRow('Optativas', 'MATE71', 'COMPUTAÇÃO VISUAL', ''),
          _buildRow('Optativas', 'FCC001', 'CONTABILIDADE GERAL I', ''),
          _buildRow(
              'Optativas', 'ENG648', 'CONTROLE E AUTOMACAO DE PROCESSOS', ''),
          _buildRow('Optativas', 'ENG649',
              'CONTROLE ENERGETICO DE SISTEMAS MECATRONICOS', ''),
          _buildRow('Optativas', 'EDC001',
              'EDUCAÇÃO ABERTA, CONTINUADA E A DISTÂNCIA', ''),
          _buildRow(
              'Optativas', 'ADM171', 'ELEMENTOS E ANALISES DE CUSTOS', ''),
          _buildRow('Optativas', 'ENGC40', 'ELETRÔNICA DIGITAL', ''),
          _buildRow('Optativas', 'MAT220', 'EMPREENDEDORES EM INFORMATICA', ''),
          _buildRow('Optativas', 'MATB65', 'EMPREENDIMENTOS E INFORMÁTICA', ''),
          _buildRow('Optativas', 'ENG639',
              'ENGENHARIA CONCORRENTE E PROTOTIPAGEM RAPIDA', ''),
          _buildRow('Optativas', 'MATB03', 'EVOLUÇÃO DE SOFTWARE', ''),
          _buildRow('Optativas', 'ECO001', 'FUNDAMENTOS DE ECONOMIA', ''),
          _buildRow('Optativas', 'ENGL26',
              'FUNDAMENTOS DE PROCESSAMENTOS DIGITAL DE SINAIS', ''),
          _buildRow('Optativas', 'MAT570',
              'FUNDAMENTOS DE SISTEMAS DISTRIBUÍDOS', ''),
          _buildRow(
              'Optativas', 'MAT569', 'FUNDAMENTOS DE TOLERANCIA A FALHAS', ''),
          _buildRow(
              'Optativas', 'ENG640', 'GESTAO E CONTROLE DA QUALIDADE', ''),
          _buildRow('Optativas', 'MATA41', 'INFORMÁTICA NA EDUCAÇÃO', ''),
          _buildRow('Optativas', 'LET358', 'INGLES INSTRUMENTAL III N-100', ''),
          _buildRow('Optativas', 'LET359', 'INGLES INSTRUMENTAL IV N-100', ''),
          _buildRow('Optativas', 'MATE73', 'INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow(
              'Optativas', 'MATB20', 'INTELIGÊNCIA ARTIFICIAL EM EDUCAÇÃO', ''),
          _buildRow('Optativas', 'MATC72', 'INTERAÇÃO HUMANO-COMPUTADOR', ''),
          _buildRow('Optativas', 'ADM001', 'INTRODUCÃO À ADMINISTRACAO', ''),
          _buildRow('Optativas', 'ENG650',
              'INTRODUCAO A INTELIGENCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MAT572',
              'INTRODUCAO A INTELIGENCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATC93', 'INTRODUÇÃO A WEB SEMÂNTICA', ''),
          _buildRow(
              'Optativas', 'MAT567', 'INTRODUCAO AOS METODOS FORMAIS', ''),
          _buildRow('Optativas', 'MATB17',
              'LAB. DE COMPUTAÇÃO GRÁFICA E PROCESSAMENTO DE IMAGENS', ''),
          _buildRow('Optativas', 'MATB09', 'LABORATÓRIO DE BANCO DE DADOS', ''),
          _buildRow(
              'Optativas', 'MATA73', 'LABORATÓRIO DE CIRCUITOS DIGITAIS', ''),
          _buildRow('Optativas', 'MATB11', 'LABORATÓRIO DE COMPILADORES', ''),
          _buildRow('Optativas', 'MATB14',
              'LABORATÓRIO DE ENGENHARIA DE SOFTWARE', ''),
          _buildRow('Optativas', 'MATB22',
              'LABORATÓRIO DE INFORMÁTICA NA EDUCAÇÃO', ''),
          _buildRow('Optativas', 'MATB16',
              'LABORATÓRIO DE INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATA80', 'LABORATÓRIO DE PROGRAMAÇÃO II', ''),
          _buildRow(
              'Optativas', 'MATC84', 'LABORATÓRIO DE PROGRAMAÇÃO WEB', ''),
          _buildRow('Optativas', 'MATB01',
              'LABORATÓRIO DE REDES DE COMPUTADORES', ''),
          _buildRow('Optativas', 'MATA81',
              'LABORATÓRIO DE SISTEMAS OPERACIONAIS', ''),
          _buildRow('Optativas', 'ENGG52', 'LABORATÓRIO INTEGRADO I-A', ''),
          _buildRow('Optativas', 'ENGG53', 'LABORATÓRIO INTEGRADO II-A', ''),
          _buildRow(
              'Optativas', 'LETE46', 'LIBRAS-LÍNGUA BRASILEIRA DE SINAIS', ''),
          _buildRow(
              'Optativas', 'MATA76', 'LINGUAGENS PARA APLICAÇÃO COMERCIAL', ''),
          _buildRow('Optativas', 'MATA16', 'LOGICA E METODOS FORMAIS', ''),
          _buildRow(
              'Optativas', 'ENG641', 'MATERIAIS EM SISTEMAS MECATRONICOS', ''),
          _buildRow('Optativas', 'MATB13', 'MÉTODOS FORMAIS', ''),
          _buildRow(
              'Optativas', 'ENG644', 'MODELAGEM E SIMULACAO DE PROCESSOS', ''),
          _buildRow(
              'Optativas', 'MATA69', 'MODELAGEM E SIMULAÇÃO DE SISTEMAS', ''),
          _buildRow('Optativas', 'MATC96',
              'ORGANIZAÇÃO, GERENCIAMENTO E RECUPERAÇÃO DA INFORMAÇÃO', ''),
          _buildRow('Optativas', 'ENG654', 'OTIMIZACAO DE PROCESSOS', ''),
          _buildRow(
              'Optativas', 'ENG795', 'PARTICIPACAO EM PROJETO DE PESQUISA', ''),
          _buildRow('Optativas', 'ENG652', 'PESQUISA OPERACIONAL', ''),
          _buildRow(
              'Optativas', 'ENG643', 'PLANEJAMENTO E CONTROLE DA PRODUCAO', ''),
          _buildRow('Optativas', 'MATE13',
              'PROGRAMAÇÃO CONCORRENTE, DISTRIBUÍDA E PARALELA', ''),
          _buildRow('Optativas', 'MATA77', 'PROGRAMAÇÃO FUNCIONAL', ''),
          _buildRow(
              'Optativas', 'ENG638', 'PROJETO MECATRONICO DE MAQUINAS', ''),
          _buildRow('Optativas', 'ENGL25',
              'PROJETOS DE SISTEMAS TÉCNICOS DE PRECISÃO', ''),
          _buildRow(
              'Optativas', 'IPSA39', 'PSICOLOGIA DAS RELACOES HUMANAS', ''),
          _buildRow('Optativas', 'MATB02', 'QUALIDADE DE SOFTWARE', ''),
          _buildRow('Optativas', 'MAT568', 'REDES DE COMPUTADORES', ''),
          _buildRow('Optativas', 'MATA85', 'REDES DE COMPUTADORES II', ''),
          _buildRow(
              'Optativas', 'ENG651', 'REDES NEURAIS E SISTEMAS NEBULOSOS', ''),
          _buildRow('Optativas', 'MATE74', 'REUSO DE SOFTWARE', ''),
          _buildRow('Optativas', 'MATB24', 'ROBÓTICA INTELIGENTE', ''),
          _buildRow('Optativas', 'MATA87', 'SEGURANÇA DA INFORMAÇÃO', ''),
          _buildRow('Optativas', 'MATC99',
              'SEGURANÇA E AUDITORIA DE SISTEMAS DE INFORMAÇÃO', ''),
          _buildRow('Optativas', 'MATA75',
              'SEMÂNTICA DE LINGUAGEM DE PROGRAMAÇÃO', ''),
          _buildRow(
              'Optativas', 'MATB23', 'SEMINÁRIOS EM EMPREENDEDORISMO', ''),
          _buildRow('Optativas', 'ENG647', 'SENSORES E INSTRUMENTACAO', ''),
          _buildRow('Optativas', 'ENG635', 'SISTEMAS CAD/CAM', ''),
          _buildRow('Optativas', 'ENG636',
              'SISTEMAS CAE E METODOS DE ELEMENTOS FINITOS', ''),
          _buildRow('Optativas', 'MAT571', 'SISTEMAS DE TEMPO REAL', ''),
          _buildRow('Optativas', 'MATA82', 'SISTEMAS DE TEMPO REAL', ''),
          _buildRow(
              'Optativas', 'ENG642', 'SISTEMAS INTEGRADOS DE MANUFATURA', ''),
          _buildRow('Optativas', 'MATB19', 'SISTEMAS MULTIMÍDIA', ''),
          _buildRow('Optativas', 'ENG655', 'SISTEMAS NAO-LINEARES', ''),
          _buildRow('Optativas', 'MAT566', 'SISTEMAS OPERACIONAIS', ''),
          _buildRow('Optativas', 'ENG645', 'SISTEMAS ROBOTICOS', ''),
          _buildRow('Optativas', 'MATE75', 'SISTEMAS WEB', ''),
          _buildRow('Optativas', 'MATC82', 'SISTEMAS WEB', ''),
          _buildRow('Optativas', 'MATE76', 'TEORIA DA COMPUTAÇÃO', ''),
          _buildRow('Optativas', 'ENG791', 'TIROCINIO DOCENTE ORIENTADO', ''),
          _buildRow('Optativas', 'MATD77', 'TOLERÂNCIA A FALHAS', ''),
          _buildRow('Optativas', 'MATA72',
              'TÓPICOS EM ARQUITETURA DE COMPUTADORES', ''),
          _buildRow('Optativas', 'MATE77',
              'TÓPICOS EM ARQUITETURA DE COMPUTADORES I', ''),
          _buildRow('Optativas', 'MATE78',
              'TÓPICOS EM ARQUITETURA DE COMPUTADORES II', ''),
          _buildRow('Optativas', 'MATE79',
              'TÓPICOS EM ARQUITETURA DE COMPUTADORES III', ''),
          _buildRow('Optativas', 'MATE80',
              'TÓPICOS EM ARQUITETURA DE COMPUTADORES IV', ''),
          _buildRow('Optativas', 'MATB10', 'TÓPICOS EM BANCO DE DADOS', ''),
          _buildRow('Optativas', 'MATE04', 'TÓPICOS EM BANCO DE DADOS I', ''),
          _buildRow('Optativas', 'MATE14', 'TÓPICOS EM BANCO DE DADOS II', ''),
          _buildRow('Optativas', 'MATE15', 'Tópicos em Banco de Dados III', ''),
          _buildRow('Optativas', 'MATE16', 'Tópicos em Banco de Dados IV', ''),
          _buildRow('Optativas', 'MATB12', 'TÓPICOS EM COMPILADORES', ''),
          _buildRow(
              'Optativas', 'MATA74', 'TÓPICOS EM COMPUTAÇÃO E ALGORITMOS', ''),
          _buildRow('Optativas', 'MATB04',
              'TÓPICOS EM COMPUTAÇÃO GRÁFICA E PROCESSAMENTO DE IMAGENS', ''),
          _buildRow(
              'Optativas', 'MATE06', 'TÓPICOS EM COMPUTAÇÃO VISUAL I', ''),
          _buildRow(
              'Optativas', 'MATE20', 'Tópicos em Computação Visual II', ''),
          _buildRow(
              'Optativas', 'MATE21', 'Tópicos em Computação Visual III', ''),
          _buildRow(
              'Optativas', 'MATE22', 'Tópicos em Computação Visual IV', ''),
          _buildRow(
              'Optativas', 'MATB25', 'TÓPICOS EM ENGENHARIA DE SOFTWARE', ''),
          _buildRow(
              'Optativas', 'MATE08', 'TÓPICOS EM ENGENHARIA DE SOFTWARE I', ''),
          _buildRow('Optativas', 'MATE26',
              'Tópicos em Engenharia de Software II', ''),
          _buildRow('Optativas', 'MATE27',
              'Tópicos em Engenharia de Software III', ''),
          _buildRow('Optativas', 'MATE28',
              'Tópicos em Engenharia de Software IV', ''),
          _buildRow('Optativas', 'MATE81',
              'TÓPICOS EM FUNDAMENTOS DA COMPUTAÇÃO I', ''),
          _buildRow('Optativas', 'MATE82',
              'TÓPICOS EM FUNDAMENTOS DA COMPUTAÇÃO II', ''),
          _buildRow('Optativas', 'MATE83',
              'TÓPICOS EM FUNDAMENTOS DA COMPUTAÇÃO III', ''),
          _buildRow('Optativas', 'MATE84',
              'TÓPICOS EM FUNDAMENTOS DA COMPUTAÇÃO IV', ''),
          _buildRow(
              'Optativas', 'MATB05', 'TÓPICOS EM INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATE10',
              'TÓPICOS EM INTELIGÊNCIA COMPUTACIONAL I', ''),
          _buildRow('Optativas', 'MATE32',
              'Tópicos em Inteligência Computacional II', ''),
          _buildRow('Optativas', 'MATE33',
              'Tópicos em Inteligência Computacional III', ''),
          _buildRow('Optativas', 'MATE34',
              'Tópicos em Inteligência Computacional IV', ''),
          _buildRow('Optativas', 'MATA79', 'TÓPICOS EM PROGRAMAÇÃO', ''),
          _buildRow(
              'Optativas', 'MATA86', 'TÓPICOS EM REDES DE COMPUTADORES', ''),
          _buildRow(
              'Optativas', 'MATE05', 'TÓPICOS EM REDES DE COMPUTADORES I', ''),
          _buildRow(
              'Optativas', 'MATE17', 'Tópicos em Redes de Computadores II', ''),
          _buildRow('Optativas', 'MATE18',
              'Tópicos em Redes de Computadores III', ''),
          _buildRow(
              'Optativas', 'MATE19', 'Tópicos em Redes de Computadores IV', ''),
          _buildRow('Optativas', 'MATE85',
              'TÓPICOS EM SISTEMAS DE INFORMAÇÃO E WEB I', ''),
          _buildRow('Optativas', 'MATE86',
              'TÓPICOS EM SISTEMAS DE INFORMAÇÃO E WEB II', ''),
          _buildRow('Optativas', 'MATE87',
              'TÓPICOS EM SISTEMAS DE INFORMAÇÃO E WEB III', ''),
          _buildRow('Optativas', 'MATE88',
              'TÓPICOS EM SISTEMAS DE INFORMAÇÃO E WEB IV', ''),
          _buildRow(
              'Optativas', 'MATE89', 'TÓPICOS EM SISTEMAS DE TEMPO REAL I', ''),
          _buildRow('Optativas', 'MATE90',
              'TÓPICOS EM SISTEMAS DE TEMPO REAL II', ''),
          _buildRow('Optativas', 'MATE91',
              'TÓPICOS EM SISTEMAS DE TEMPO REAL III', ''),
          _buildRow('Optativas', 'MATE92',
              'TÓPICOS EM SISTEMAS DE TEMPO REAL IV', ''),
          _buildRow(
              'Optativas', 'MATB06', 'TÓPICOS EM SISTEMAS DISTRIBUIDOS', ''),
          _buildRow(
              'Optativas', 'MATE35', 'Tópicos em Sistemas Distribuidos I', ''),
          _buildRow(
              'Optativas', 'MATE36', 'Tópicos em Sistemas Distribuidos II', ''),
          _buildRow('Optativas', 'MATE37',
              'Tópicos em Sistemas Distribuidos III', ''),
          _buildRow(
              'Optativas', 'MATE38', 'Tópicos em Sistemas Distribuidos IV', ''),
          _buildRow(
              'Optativas', 'MATB26', 'TÓPICOS EM SISTEMAS MULTIMÍDIA', ''),
          _buildRow(
              'Optativas', 'MATA83', 'TÓPICOS EM SISTEMAS OPERACIONAIS', ''),
          _buildRow(
              'Optativas', 'ENG764', 'TOPICOS ESPECIAIS EM MECATRONICA I', ''),
          _buildRow(
              'Optativas', 'MAT700', 'TOPICOS ESPECIAIS EM MECATRONICA II', ''),
          _buildRow('Optativas', 'ENG765',
              'TOPICOS ESPECIAIS EM MECATRONICA III', ''),
          _buildRow(
              'Optativas', 'MAT701', 'TOPICOS ESPECIAIS EM MECATRONICA IV', ''),
          _buildRow('Optativas', 'MATB15', 'VALIDAÇÃO DE SOFTWARE', ''),
          _buildRow('Optativas', 'ENGL24',
              'VISÃO COMPUTACIONAL E RECONHECIMENTO DE PADRÕES', ''),
        ],
      ),
    );
  }

  DataRow _buildRow(
      String semestre, String codigo, String disciplina, String link) {
    return DataRow(cells: [
      DataCell(Text(semestre)),
      DataCell(Text(codigo)),
      DataCell(InkWell(
        onTap: () {
          // Adicione a lógica para abrir o link
          _abrirLink(link);
        },
        child: Text(disciplina, style: TextStyle(color: Colors.blue)),
      )),
      DataCell(Text('')), // Espaço para adição do link
    ]);
  }

  void _abrirLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}

class TabelaGradeCurricularLC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 15.0,
        columns: [
          DataColumn(
            label: Text(
              'Semestre',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Código',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Disciplina',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Link',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: [
          _buildRow('1° Semestre', 'EDCB80', 'FILOSOFIA DA EDUCAÇÃO', ''),
          _buildRow('1° Semestre', 'MATA01', 'GEOMETRIA ANALÍTICA', ''),
          _buildRow(
                    '1° Semestre',
                    'MATA37',
                    'INTRODUÇÃO À LÓGICA DE PROGRAMAÇÃO',
                    'https://drive.google.com/drive/folders/10bMbnjWbsfNVxonl-IKUG4tcBpTaxlf4'),
          _buildRow(
                    '1° Semestre',
                    'MATA39',
                    'SEMINÁRIOS DE INTRODUÇÃO AO CURSO',
                    'https://drive.google.com/drive/folders/10eYXZzNIF5iiTJpbsg6hS-s03wD34jGH'),
          _buildRow('1° Semestre', 'MATA42', 'MATEMÁTICA DISCRETA I',
                    'https://drive.google.com/drive/folders/10wQKkBNXNyDra4fKvjNLdocd5NavbOch'),
          _buildRow('2° Semestre', 'EDC287', 'EDUCAÇÃO E TECNOLOGIAS CONTEMPORÂNEAS', ''),
          _buildRow('2° Semestre', 'MATA68', 'COMPUTADOR, ÉTICA E SOCIEDADE',
                        'https://drive.google.com/drive/folders/10u0LDb0x5ifuXkZUzJ_0qDc5H4fcqXHv'),
          _buildRow('2° Semestre', 'MATC73', 'INTRODUÇÃO À LÓGICA MATEMÁTICA', ''),
          _buildRow('2° Semestre', 'MATC81', 'SISTEMAS BÁSICOS DE COMPUTAÇÃO: ARQUITETURA E SOFTWARE', ''),
          _buildRow('2° Semestre', 'MATD04', 'ESTRUTURAS DE DADOS', ''),
          _buildRow('3° Semestre', 'EDCA01', 'FUNDAMENTOS PSICOLÓGICOS DA EDUCAÇÃO', ''),
          _buildRow('3° Semestre', 'MAT236', 'MÉTODOS ESTATÍSTICOS', ''),
          _buildRow('3° Semestre', 'MATA55', 'PROGRAMAÇÃO ORIENTADA A OBJETOS', ''),
          _buildRow('3° Semestre', 'MATC94', 'INTRODUÇÃO AS LINGUAGENS FORMAIS E TEORIA DA COMPUTAÇÃO', ''),
          _buildRow('4° Semestre', 'EDCA11', 'DIDÁTICA E PRAXIS PEDAGÓGICA I', ''),
          _buildRow('4° Semestre', 'LETE46', 'LIBRAS-LÍNGUA BRASILEIRA DE SINAIS', ''),
          _buildRow('4° Semestre', 'MATA41', 'INFORMÁTICA NA EDUCAÇÃO', ''),
          _buildRow('4° Semestre', 'MATA59', 'REDES DE COMPUTADORES I', ''),
          _buildRow('4° Semestre', 'MATA62', 'ENGENHARIA DE SOFTWARE I', ''),
          _buildRow('4° Semestre', 'MATC82', 'SISTEMAS WEB', ''),
          _buildRow('5° Semestre', 'EDC286', 'AVALIAÇÃO DA APRENDIZAGEM', ''),
          _buildRow('5° Semestre', 'EDCA12', 'DIDÁTICA E PRAXIS PEDAGÓGICA II', ''),
          _buildRow('5° Semestre', 'MATB19', 'SISTEMAS MULTIMÍDIA', ''),
          _buildRow('5° Semestre', 'MATB21', 'AMBIENTES INTERATIVOS DE APRENDIZAGEM', ''),
          _buildRow('5° Semestre', 'MATD05', 'BANCO DE DADOS E APLICAÇÕES', ''),
          _buildRow('6° Semestre', 'MATB22', 'LABORATÓRIO DE INFORMÁTICA NA EDUCAÇÃO', ''),
          _buildRow('6° Semestre', 'MATC68', 'ESTÁGIO SUPERVISIONADO I', ''),
          _buildRow('6° Semestre', 'MATC72', 'INTERAÇÃO HUMANO-COMPUTADOR', ''),
          _buildRow('6° Semestre', 'MATC76', 'PRÁTICA DE ENSINO DE COMPUTAÇÃO I', ''),
          _buildRow('6° Semestre', 'MATC78', 'PROJETO DE SOFTWARE EDUCATIVO', ''),
          _buildRow('7° Semestre', 'MATB20', 'INTELIGÊNCIA ARTIFICIAL EM EDUCAÇÃO', ''),
          _buildRow('7° Semestre', 'MATC69', 'ESTÁGIO SUPERVISIONADO II', ''),
          _buildRow('7° Semestre', 'MATC77', 'PRÁTICA DE ENSINO DE COMPUTAÇÃO II', ''),
          _buildRow('7° Semestre', 'MATC79', 'PROJETOS INTERDISCIPLINARES: CONCEPÇÃO E PRÁTICA', ''),
          _buildRow('8° Semestre', 'MATC70', 'ESTÁGIO SUPERVISIONADO III', ''),
          _buildRow('89° Semestre', 'MATC71', 'ESTÁGIO SUPERVISIONADO IV', ''),
          _buildRow('Optativas', 'EDC273', 'ANTROPOLOGIA DA EDUCAÇÃO', ''),
          _buildRow('Optativas', 'MATA02', 'CÁLCULO A', 'https://drive.google.com/drive/folders/1wtZU9kLYrHhm1cP-S9lut_wZHAILW8fL'),
          _buildRow('Optativas', 'MATC83', 'DESENVOLVIMENTO DE OBJETOS DE APRENDIZAGEM', ''),
          _buildRow('Optativas', 'EDC251', 'DIMENSAO ESTETICA DA EDUCACAO', ''),
          _buildRow('Optativas', 'EDC001', 'EDUCAÇÃO ABERTA, CONTINUADA E A DISTÂNCIA', ''),
          _buildRow('Optativas', 'EDC267', 'EDUCACAO AMBIENTAL', ''),
          _buildRow('Optativas', 'EDC248', 'EDUCACAO E IDENTIDADE CULTURAL', ''),
          _buildRow('Optativas', 'MAT220', 'EMPREENDEDORES EM INFORMATICA', ''),
          _buildRow('Optativas', 'MATA63', 'ENGENHARIA DE SOFTWARE II', ''),
          _buildRow('Optativas', 'MAT198', 'FUNDAMENTOS DE MATEMATICA ELEMENTAR I-A', ''),
          _buildRow('Optativas', 'EDC274', 'HISTORIA DA EDUCACAO 1', ''),
          _buildRow('Optativas', 'EDCA05', 'HISTÓRIA DA EDUCAÇÃO BRASILEIRA', ''),
          _buildRow('Optativas', 'LET358', 'INGLES INSTRUMENTAL III N-100', ''),
          _buildRow('Optativas', 'LET359', 'INGLES INSTRUMENTAL IV N-100', ''),
          _buildRow('Optativas', 'MATA64', 'INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATB09', 'LABORATÓRIO DE BANCO DE DADOS', ''),
          _buildRow('Optativas', 'MATB16', 'LABORATÓRIO DE INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATA57', 'LABORATÓRIO DE PROGRAMAÇÃO I', ''),
          _buildRow('Optativas', 'MATC75', 'LABORATÓRIO DE PROGRAMAÇÃO VISUAL', ''),
          _buildRow('Optativas', 'MATC84', 'LABORATÓRIO DE PROGRAMAÇÃO WEB', ''),
          _buildRow('Optativas', 'EDC303', 'METODOLOGIA DO ENSINO DA MATEMÁTICA', ''),
          _buildRow('Optativas', 'EDC314', 'METODOLOGIA DO ENSINO DE CIÊNCIAS NATURAIS', ''),
          _buildRow('Optativas', 'MATG09', 'OBSERVAÇÃO E REGÊNCIA DE SALA DE AULA', ''),
          _buildRow('Optativas', 'EDC272', 'ORGANIZAÇÃO DA EDUCACAO BRASILEIRA 1', ''),
          _buildRow('Optativas', 'EDC289', 'PESQUISA EM EDUCACAO', ''),
          _buildRow('Optativas', 'MATC85', 'PRODUÇÃO DE MATERIAL EDUCATIVO DIGITAL', ''),
          _buildRow('Optativas', 'MATB24', 'ROBÓTICA INTELIGENTE', ''),
          _buildRow('Optativas', 'EDCB81', 'SOCIOLOGIA DA EDUCAÇÃO', ''),
          _buildRow('Optativas', 'MATC86', 'TECNOLOGIAS DIGITAIS COMO ESTRATÉGIAS DE APRENDIZAGEM', ''),
          _buildRow('Optativas', 'EDC321', 'TEE - POLÊMICAS CONTEMPORÂNEAS', ''),
          _buildRow('Optativas', 'MATB05', 'TÓPICOS EM INTELIGÊNCIA ARTIFICIAL', ''),
          _buildRow('Optativas', 'MATC87', 'TÓPICOS EM PROGRAMAÇÃO PARA EDUCAÇÃO', ''),
          _buildRow('Optativas', 'MATB26', 'TÓPICOS EM SISTEMAS MULTIMÍDIA', ''),
        ],
      ),
    );
  }

  DataRow _buildRow(
      String semestre, String codigo, String disciplina, String link) {
    return DataRow(cells: [
      DataCell(Text(semestre)),
      DataCell(Text(codigo)),
      DataCell(InkWell(
        onTap: () {
          // Adicione a lógica para abrir o link
          _abrirLink(link);
        },
        child: Text(disciplina, style: TextStyle(color: Colors.blue)),
      )),
      DataCell(Text('')), // Espaço para adição do link
    ]);
  }

  void _abrirLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}

