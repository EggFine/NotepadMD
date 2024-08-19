import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotepadMD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const TextEditorHome(title: "NotepadMD"),
    );
  }
}

class TextEditorHome extends StatefulWidget {
  const TextEditorHome({super.key, required this.title});

  final String title;

  @override
  State<TextEditorHome> createState() => _TextEditorHomeState();
}

class _TextEditorHomeState extends State<TextEditorHome> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: () {},
          ),
        ],
      ),
      body: TextField(
        controller: _textController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Hello NotepadMD...',
        ),
      ),
    );
  }
}
