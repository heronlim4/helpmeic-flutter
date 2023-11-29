# HELPMe - IC

## Descrição
Este aplicativo foi desenvolvido em Flutter e tem como objetivo auxiliar estudantes do Instituto da Computação no acesso a recursos, agenda acadêmica e informações sobre eventos acadêmicos.

## Funcionalidades

### Tela Principal
- Navegação entre abas: Repositório, Agenda e Eventos Acadêmicos.
- Bottom Navigation Bar para facilitar a troca entre as abas.
- Cada aba é representada por um StatefulWidget correspondente.

### Tela Repositório
- Lista recursos acadêmicos (aulas, vídeos, etc.).
- Filtragem de recursos por título, descrição ou disciplina.
- Adição de recursos por meio de um FloatingActionButton.
- Diálogo para seleção de curso ao adicionar um recurso.
- Links dos recursos podem ser abertos diretamente.

### Tela Agenda
- Listagem de itens da agenda acadêmica ordenados por data.
- Adição, edição e exclusão de itens da agenda.
- Diálogos interativos para realizar as operações acima.

### Tela Eventos Acadêmicos
- Página simples indicando que é a tela de Eventos Acadêmicos.

### Tela Grade Curricular
- Visualização da grade curricular de um curso específico.
- A tabela é construída dinamicamente com base no curso selecionado.

## Como Executar
Certifique-se de ter o Flutter e o Dart instalados em sua máquina. Em seguida, execute os seguintes comandos no terminal:

```bash
flutter pub get
flutter run

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
