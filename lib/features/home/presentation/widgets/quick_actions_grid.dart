import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(children: [
      Row(children: [
        Expanded(child: _ActionButton('قبض/\nصرف', Icons.receipt_long, false)),
        const SizedBox(width: 24),
        Expanded(child: _ActionButton('المبيعات', Icons.shopping_basket_outlined, true)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: _ActionButton('الحسابات', Icons.analytics_outlined, false)),
        const SizedBox(width: 24),
        Expanded(child: _ActionButton('المشتريات', Icons.shopping_cart_outlined, true)),
      ]),
    ]),
  );
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool hasPlus;
  const _ActionButton(this.title, this.icon, this.hasPlus);

  @override
  Widget build(BuildContext context) => Column(children: [
    SizedBox(height: 48, child: Center(
      child: Icon(icon, color: AppColors.actionText, size: 38),
    )),
    const SizedBox(height: 4),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF0072BB), Color(0xFF005697)]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2))],
        ),
        child: Text(title, textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.1)),
      ),
      if (hasPlus) ...[
        const SizedBox(width: 6),
        const Icon(Icons.add_circle, color: AppColors.actionText, size: 26),
      ],
    ]),
  ]);
}
