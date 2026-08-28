import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../utilities/themes/app_colors.dart';
import '../../utilities/themes/app_radii.dart';

class ThemeSelectionDialog extends StatelessWidget {
  const ThemeSelectionDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const ThemeSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final currentMode = themeProvider.themeMode;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusLg),
      title: const Row(
        children: [
          Icon(Icons.palette_outlined, color: AppColors.primary),
          SizedBox(width: 10),
          Text(
            'Appearance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _themeOptionTile(
            context: context,
            title: 'System Default',
            icon: Icons.brightness_auto_rounded,
            value: ThemeMode.system,
            isSelected: currentMode == ThemeMode.system,
            onTap: () => _updateMode(context, ThemeMode.system),
          ),
          _themeOptionTile(
            context: context,
            title: 'Light Theme',
            icon: Icons.light_mode_rounded,
            value: ThemeMode.light,
            isSelected: currentMode == ThemeMode.light,
            onTap: () => _updateMode(context, ThemeMode.light),
          ),
          _themeOptionTile(
            context: context,
            title: 'Dark Theme',
            icon: Icons.dark_mode_rounded,
            value: ThemeMode.dark,
            isSelected: currentMode == ThemeMode.dark,
            onTap: () => _updateMode(context, ThemeMode.dark),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _themeOptionTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required ThemeMode value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: AppRadii.radiusMd),
      leading: Icon(
        icon,
        size: 22,
        color: isSelected
            ? AppColors.primary
            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
          color: isSelected ? AppColors.primary : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 20,
            )
          : const Icon(Icons.circle_outlined, color: Colors.grey, size: 20),
    );
  }

  void _updateMode(BuildContext context, ThemeMode mode) {
    context.read<ThemeProvider>().setThemeMode(mode);
    Navigator.of(context).pop();
  }
}
