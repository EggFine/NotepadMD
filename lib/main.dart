import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotepadMD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
  final ScrollController _scrollController = ScrollController();
  int _lineCount = 1;
  int _currentLine = 1;
  int _currentColumn = 1;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateLineAndColumnCount);
  }

  void _updateLineAndColumnCount() {
    setState(() {
      _lineCount = '\n'.allMatches(_textController.text).length + 1;
      _currentLine = '\n'.allMatches(_textController.text.substring(0, _textController.selection.baseOffset)).length + 1;
      _currentColumn = _textController.selection.baseOffset - _textController.text.lastIndexOf('\n', _textController.selection.baseOffset - 1);
    });
  }

  @override
  void dispose() {
    _textController.removeListener(_updateLineAndColumnCount);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildMenuBar(),
          _buildToolbar(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LineNumbers(
                  lineCount: _lineCount,
                  scrollController: _scrollController,
                  textStyle: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    scrollController: _scrollController,
                    maxLines: null,
                    expands: true,
                    style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildStatusBar(),
        ],
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          _buildMenuButton('文件'),
          _buildMenuButton('编辑'),
          _buildMenuButton('搜索'),
          _buildMenuButton('视图'),
          _buildMenuButton('编码'),
          _buildMenuButton('语言'),
          _buildMenuButton('设置'),
          _buildMenuButton('工具'),
          _buildMenuButton('宏'),
          _buildMenuButton('运行'),
          _buildMenuButton('插件'),
          _buildMenuButton('窗口'),
          _buildMenuButton('?'),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String label) {
    return PopupMenuButton<String>(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(label, style: TextStyle(color: Colors.black)),
      ),
      itemBuilder: (BuildContext context) {
        switch (label) {
          case '文件':
            return [
              PopupMenuItem<String>(child: Text('新建'), value: 'new'),
              PopupMenuItem<String>(child: Text('打开'), value: 'open'),
              PopupMenuItem<String>(child: Text('保存'), value: 'save'),
              PopupMenuItem<String>(child: Text('另存为'), value: 'saveAs'),
              PopupMenuItem<String>(child: Text('退出'), value: 'exit'),
            ];
          case '编辑':
            return [
              PopupMenuItem<String>(child: Text('撤销'), value: 'undo'),
              PopupMenuItem<String>(child: Text('重做'), value: 'redo'),
              PopupMenuItem<String>(child: Text('剪切'), value: 'cut'),
              PopupMenuItem<String>(child: Text('复制'), value: 'copy'),
              PopupMenuItem<String>(child: Text('粘贴'), value: 'paste'),
            ];
        // 为其他菜单项添加类似的子菜单
          default:
            return [PopupMenuItem<String>(child: Text('功能待实现'), value: 'todo')];
        }
      },
      onSelected: (String value) {
        // 处理菜单项选择
        print('选择了: $value');
      },
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.save), onPressed: () {}),
          IconButton(icon: const Icon(Icons.folder_open), onPressed: () {}),
          IconButton(icon: const Icon(Icons.content_cut), onPressed: () {}),
          IconButton(icon: const Icon(Icons.content_copy), onPressed: () {}),
          IconButton(icon: const Icon(Icons.content_paste), onPressed: () {}),
          IconButton(icon: const Icon(Icons.undo), onPressed: () {}),
          IconButton(icon: const Icon(Icons.redo), onPressed: () {}),
          IconButton(icon: const Icon(Icons.zoom_in), onPressed: () {}),
          IconButton(icon: const Icon(Icons.zoom_out), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Text('行 $_currentLine, 列 $_currentColumn'),
          const Spacer(),
          Text('UTF-8'),
          const SizedBox(width: 10),
          Text('Windows (CRLF)'),
        ],
      ),
    );
  }
}

class LineNumbers extends StatelessWidget {
  final int lineCount;
  final ScrollController scrollController;
  final TextStyle textStyle;

  const LineNumbers({
    Key? key,
    required this.lineCount,
    required this.scrollController,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: ListView.builder(
        controller: scrollController,
        itemCount: math.max(lineCount, 1),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Text(
              '${index + 1}',
              style: textStyle,
              textAlign: TextAlign.right,
            ),
          );
        },
      ),
    );
  }
}