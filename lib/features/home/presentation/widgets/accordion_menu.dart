import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AccordionMenu extends StatefulWidget {
  const AccordionMenu({super.key});

  @override
  State<AccordionMenu> createState() => _AccordionMenuState();
}

class _AccordionMenuState extends State<AccordionMenu> {
  int expandedIndex = -1;

  static const menuData = [
    ('عمليات مخزنية', ['صرف مخزني','توريد مخزني','تحويل مخزني','تسوية مخزنية','إضافة مخزن','جرد مخزني']),
    ('قيود وحسابات', ['قيد يومي','قيد إفتتاحي','إضافة حساب','حركة الصندوق','دليل الحسابات','إقفال سنوي']),
    ('أصناف', ['الأصناف','أسعار البيع','وحدات الصنف','فاتورة عرض سعر','طلب شراء']),
    ('العملات', ['إضافة عملة','سعر العملات','سقف الحساب']),
    ('التقارير', ['حركة الأصناف','ميزان المراجعة','قائمة الدخل','المركز المالي','تقارير أخرى']),
  ];

  @override
  Widget build(BuildContext context) => Column(
    children: List.generate(menuData.length, (index) {
      final expanded = expandedIndex == index;
      final section = menuData[index];
      return Column(children: [
        InkWell(
          onTap: () => setState(() => expandedIndex = expanded ? -1 : index),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: AppColors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white),
                Text(section.$1, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        if (expanded) Container(
          color: AppColors.background,
          child: Column(
            children: section.$2.map((title) => ListTile(
              dense: true,
              title: Text(title, textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w600)),
              onTap: () {},
            )).toList(),
          ),
        ),
      ]);
    }),
  );
}
