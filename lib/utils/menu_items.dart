class MenuItem {
  final String label;
  final List<String> subItems;

  MenuItem(this.label, this.subItems);
}

class MenuItems {
  static final List<MenuItem> mainMenuItems = [
    MenuItem('文件', ['新建', '打开', '保存', '另存为', '退出']),
    MenuItem('编辑', ['撤销', '重做', '剪切', '复制', '粘贴']),
    MenuItem('搜索', ['查找', '替换', '转到']),
    MenuItem('视图', ['缩放', '状态栏', '自动换行']),
    MenuItem('语言', ['Markdown', 'Python', 'JavaScript', 'HTML', 'CSS']),
    MenuItem('设置', ['首选项', '快捷键', '插件']),
  ];
}