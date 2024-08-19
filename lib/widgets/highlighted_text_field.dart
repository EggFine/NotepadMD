import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class HighlightedTextField extends StatefulWidget {
  final TextEditingController controller;
  final ScrollController scrollController;
  final String language;

  const HighlightedTextField({
    Key? key,
    required this.controller,
    required this.scrollController,
    required this.language,
  }) : super(key: key);

  @override
  _HighlightedTextFieldState createState() => _HighlightedTextFieldState();
}

class _HighlightedTextFieldState extends State<HighlightedTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HighlightView(
          widget.controller.text,
          language: widget.language,
          theme: githubTheme,
          padding: const EdgeInsets.all(12),
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 14,
          ),
        ),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          scrollController: widget.scrollController,
          maxLines: null,
          expands: true,
          style: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 14,
            color: Colors.transparent,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.transparent,
            filled: true,
          ),
          cursorColor: Colors.black,
        ),
      ],
    );
  }
}