import 'package:flutter/material.dart';

class TronTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Tab> tabs;
  const TronTabBar({Key? key, required this.tabs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFF00FFF7), width: 5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.4),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      labelColor: const Color(0xFF00FFF7),
      unselectedLabelColor: Colors.white70,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
        fontSize: 16,
        letterSpacing: 1.5,
      ),
      tabs: tabs,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
