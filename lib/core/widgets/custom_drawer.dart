import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Column(children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [AppColors.blueDark, AppColors.blueLight]),
          ),
          child: const Row(children: [
            Icon(Icons.account_balance, color: Colors.white),
            SizedBox(width: 12),
            Text('المحاسب برو', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ]),
        ),
        Expanded(child: ListView(children: const [
          _DrawerTile(Icons.save_alt, 'حفظ نسخة'),
          _DrawerTile(Icons.restore, 'إسترجاع قاعدة'),
          _DrawerTile(Icons.add_to_drive, 'جوجل درايف'),
          _DrawerTile(Icons.account_balance_wallet_outlined, 'دليل الحسابات'),
          _DrawerTile(Icons.settings_suggest_outlined, 'إعدادات'),
          _DrawerTile(Icons.phone, 'للتواصل والدعم'),
          _DrawerTile(Icons.info_outline, 'حول البرنامج'),
          _DrawerTile(Icons.exit_to_app, 'خروج'),
        ])),
      ]),
    ),
  );
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  const _DrawerTile(this.icon, this.title);

  @override
  Widget build(BuildContext context) => ListTile(
    trailing: Icon(icon, color: AppColors.blue),
    title: Text(title, textAlign: TextAlign.right,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    onTap: () => Navigator.pop(context),
  );
}
