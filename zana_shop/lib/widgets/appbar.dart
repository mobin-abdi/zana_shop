import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zana_shop/theme/light_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? action;

  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMain),
      ),
      centerTitle: true,
      leading: leading,
      actions: action != null ? [action!] : [],
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}