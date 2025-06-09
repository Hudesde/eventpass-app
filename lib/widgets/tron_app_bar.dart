import 'package:flutter/material.dart';

class TronAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  const TronAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF0A192F),
      elevation: 10,
      shadowColor: Colors.cyanAccent.withOpacity(0.5),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Color(0xFF00FFF7),
          letterSpacing: 2,
          fontFamily: 'monospace',
          shadows: [
            Shadow(
              blurRadius: 12,
              color: Color(0xFF00FFF7),
              offset: Offset(0, 0),
            ),
          ],
        ),
      ),
      actions: actions,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        side: BorderSide(color: Color(0xFF00FFF7), width: 3),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? 70 : 110);
}
