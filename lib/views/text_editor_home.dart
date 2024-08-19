import 'package:flutter/material.dart';
import '../widgets/editor_tab.dart';
import '../utils/file_operations.dart';
import '../utils/menu_items.dart';

class TextEditorHome extends StatefulWidget {
  const TextEditorHome({super.key, required this.title});
  final String title;

  @override
  State<TextEditorHome> createState() => _TextEditorHomeState();
}

class _TextEditorHomeState extends State<TextEditorHome> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<EditorTab> _tabs = [];

  @override
  void initState() {
    super.initState();
    _addNewTab();
  }

  void _addNewTab({String? content, String? filePath}) {
    setState(() {
      _tabs.add(EditorTab(
        key: GlobalKey<EditorTabState>(),
        initialContent: content ?? '',
        filePath: filePath,
        onClose: () => _closeTab(_tabs.length - 1),
      ));
      _tabController = TabController(length: _tabs.length, vsync: this);
      _tabController.index = _tabs.length - 1;
    });
  }

  void _closeTab(int index) {
    setState(() {
      _tabs.removeAt(index);
      _tabController = TabController(length: _tabs.length, vsync: this);
      if (index > 0) {
        _tabController.index = index - 1;
      }
    });
    if (_tabs.isEmpty) {
      _addNewTab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((tab) => Tab(
            child: Row(
              children: [
                Text(tab.filePath ?? 'Untitled'),
                const SizedBox(width: 5),
                InkWell(
                  child: const Icon(Icons.close, size: 16),
                  onTap: () => _closeTab(_tabs.indexOf(tab)),
                ),
              ],
            ),
          )).toList(),
        ),
      ),
      body: Column(
        children: [
          _buildMenuBar(),
          _buildToolbar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuBar() {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: MenuItems.mainMenuItems.map((item) => _buildAnimatedMenuButton(item.label, item.subItems)).toList(),
      ),
    );
  }

  Widget _buildAnimatedMenuButton(String label, List<String> items) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(label, style: const TextStyle(color: Colors.black)),
      ),
      itemBuilder: (BuildContext context) {
        return items.map((String item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      onSelected: (String value) async {
        switch (value) {
          case '新建':
            _addNewTab();
            break;
          case '打开':
            final result = await FileOperations.openFile();
            if (result != null) {
              _addNewTab(content: result.content, filePath: result.filePath);
            }
            break;
          case '保存':
            if (_tabs.isNotEmpty) {
              final currentTab = _tabs[_tabController.index];
              await FileOperations.saveFile(currentTab.getCurrentContent(), currentTab.filePath);
              setState(() {
                _tabs[_tabController.index] = currentTab.copyWith(
                  filePath: currentTab.filePath ?? 'Untitled',
                );
              });
            }
            break;
        }
      },
    );
  }

  Widget _buildToolbar() {
    return Container(
      color: Colors.grey[300],
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.save), onPressed: () async {
            if (_tabs.isNotEmpty) {
              final currentTab = _tabs[_tabController.index];
              await FileOperations.saveFile(currentTab.getCurrentContent(), currentTab.filePath);
              setState(() {
                _tabs[_tabController.index] = currentTab.copyWith(
                  filePath: currentTab.filePath ?? 'Untitled',
                );
              });
            }
          }),
          IconButton(icon: const Icon(Icons.folder_open), onPressed: () async {
            final result = await FileOperations.openFile();
            if (result != null) {
              _addNewTab(content: result.content, filePath: result.filePath);
            }
          }),
          IconButton(icon: const Icon(Icons.add), onPressed: () => _addNewTab()),
        ],
      ),
    );
  }
}