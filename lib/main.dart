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
            //if (curso == 'BCC') TabelaGradeCurricularBSI(),
            //if (curso == 'LC') TabelaGradeCurricularBSI(),
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
