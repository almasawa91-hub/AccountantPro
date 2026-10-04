import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.blueDark, AppColors.blueLight]),
      ),
    ),
    title: const Text('المحاسب برو',
      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
    actions: [
      IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
      IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
    ],
  );
}
