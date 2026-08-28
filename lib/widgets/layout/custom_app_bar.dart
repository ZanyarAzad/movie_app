import 'package:flutter/material.dart';
import '../dialogs/theme_selection_dialog.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showThemeToggle;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showThemeToggle = true,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      leading: leading,
      actions: [
        if (actions != null) ...actions!,
        if (showThemeToggle)
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Change Theme',
            onPressed: () => ThemeSelectionDialog.show(context),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
