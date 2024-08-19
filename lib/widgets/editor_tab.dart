import 'package:flutter/material.dart';
import 'line_numbers.dart';
import 'highlighted_text_field.dart';

class EditorTab extends StatefulWidget {
  final String initialContent;
  final String? filePath;
  final VoidCallback onClose;

  const EditorTab({
    Key? key,
    required this.initialContent,
    this.filePath,
    required this.onClose,
  }) : super(key: key);

  @override
  State<EditorTab> createState() => EditorTabState();

  EditorTab copyWith({String? filePath}) {
    return EditorTab(
      key: key,
      initialContent: initialContent,
      filePath: filePath ?? this.filePath,
      onClose: onClose,
    );
  }

  String getCurrentContent() {
    return (key as GlobalKey<EditorTabState>).currentState?.getCurrentContent() ?? '';
  }
}

class EditorTabState extends State<EditorTab> {
  late TextEditingController _textController;
  late ScrollController _scrollController;
  int _lineCount = 1;
  int _currentLine = 1;
  int _currentColumn = 1;
  String _language = 'markdown';

  String getCurrentContent() => _textController.text;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialContent);
    _scrollController = ScrollController();
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
    return Column(
      children: [
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
                child: HighlightedTextField(
                  controller: _textController,
                  scrollController: _scrollController,
                  language: _language,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBar(),
      ],
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
          Text('语言: $_language'),
          const SizedBox(width: 10),
          const Text('UTF-8'),
          const SizedBox(width: 10),
          const Text('Windows (CRLF)'),
        ],
      ),
    );
  }
}