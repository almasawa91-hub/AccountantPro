import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_drawer.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/accordion_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const CustomAppBar(),
    drawer: const CustomAppDrawer(),
    body: Column(children: [
      Expanded(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: const Column(children: [
            SizedBox(height: 12),
            QuickActionsGrid(),
            SizedBox(height: 20),
            AccordionMenu(),
            SizedBox(height: 16),
          ]),
        ),
      ),
      const _BottomBar(),
    ]),
  );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) => Container(
    height: 52,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: const BoxDecoration(
      gradient: LinearGradient(colors: [Color(0xFF005391), Color(0xFF006EA8)]),
    ),
    child: const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.sync, color: Colors.white, size: 20),
        Text('المخزن الرئيسي',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text('YouTube',
          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
