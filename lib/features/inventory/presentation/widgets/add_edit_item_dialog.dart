import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_model.dart';
import '../../logic/inventory_provider.dart';

class AddEditItemDialog extends StatefulWidget {
  final ItemModel? item;
  const AddEditItemDialog({super.key, this.item});
  @override State<AddEditItemDialog> createState() => _AddEditItemDialogState();
}

class _AddEditItemDialogState extends State<AddEditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name, _category, _qty, _cost, _barcode, _notes;
  String? _expiry;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final x = widget.item;
    _name = TextEditingController(text: x?.name ?? '');
    _category = TextEditingController(text: x?.category ?? '');
    _qty = TextEditingController(text: x == null ? '0' : x.quantity.toString());
    _cost = TextEditingController(text: x == null ? '0' : x.costPrice.toString());
    _barcode = TextEditingController(text: x?.barcode ?? '');
    _notes = TextEditingController(text: x?.notes ?? '');
    _expiry = x?.expiryDate;
  }

  @override
  void dispose() {
    for (final c in [_name, _category, _qty, _cost, _barcode, _notes]) c.dispose();
    super.dispose();
  }

  Future<void> _pickExpiry() async {
    final picked = await showDatePicker(context: context, initialDate: DateTime.tryParse(_expiry ?? '') ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) {
      setState(() => _expiry = picked.year.toString().padLeft(4, '0') + '-' + picked.month.toString().padLeft(2, '0') + '-' + picked.day.toString().padLeft(2, '0'));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final quantity = int.tryParse(_qty.text) ?? 0;
    final cost = double.tryParse(_cost.text) ?? 0;
    if (quantity < 0 || cost < 0) return;
    setState(() => _saving = true);
    final item = ItemModel(
      id: widget.item?.id,
      name: _name.text.trim(),
      category: _category.text.trim().isEmpty ? 'عام' : _category.text.trim(),
      barcode: _barcode.text.trim().isEmpty ? null : _barcode.text.trim(),
      sellPrice: widget.item?.sellPrice ?? cost,
      costPrice: cost,
      quantity: quantity,
      expiryDate: _expiry,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    final ok = await context.read<InventoryProvider>().saveItem(item);
    if (!mounted) return;
    if (ok) Navigator.pop(context); else setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(controller: _name, textAlign: TextAlign.right, decoration: const InputDecoration(hintText: 'إسم الصنف', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12)), validator: (v) => v == null || v.trim().isEmpty ? 'أدخل اسم الصنف' : null),
                const SizedBox(height: 10),
                Row(children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10), decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)), child: Text(_formatDate(widget.item))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: _category, textAlign: TextAlign.right, decoration: const InputDecoration(hintText: 'مجموعة الصنف', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12)))),
                ]),
                const SizedBox(height: 10),
                TextField(controller: _barcode, textAlign: TextAlign.left, decoration: const InputDecoration(hintText: 'الباركود', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12), prefixIcon: Icon(Icons.qr_code_scanner))),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: TextFormField(controller: _qty, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(hintText: 'الكمية الإفتتاحية', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)), validator: (v) => int.tryParse(v ?? '') == null ? 'غير صحيحة' : null)),
                  const SizedBox(width: 8),
                  Expanded(child: TextFormField(controller: _cost, keyboardType: const TextInputType.numberWithOptions(decimal: true), textAlign: TextAlign.center, decoration: const InputDecoration(hintText: 'تكلفة الوحدة', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)), validator: (v) => double.tryParse(v ?? '') == null ? 'غير صحيحة' : null)),
                ]),
                const SizedBox(height: 10),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  GestureDetector(onTap: () {}, child: Container(width: 60, height: 60, decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)), child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, color: Colors.black54), Icon(Icons.image, size: 16, color: Colors.black38)]))),
                  const SizedBox(width: 8),
                  Expanded(child: Column(children: [
                    TextField(controller: _notes, maxLines: 2, textAlign: TextAlign.right, decoration: const InputDecoration(hintText: 'ملاحظات', border: OutlineInputBorder(), contentPadding: EdgeInsets.all(8))),
                    const SizedBox(height: 6),
                    InkWell(onTap: _saving ? null : _pickExpiry, child: Row(children: [const Icon(Icons.calendar_today, size: 20, color: Colors.black54), const SizedBox(width: 6), Text(_expiry ?? 'تاريخ الإنتهاء', style: const TextStyle(fontSize: 13, color: Colors.black54))])),
                  ])),
                ]),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black, elevation: 0), onPressed: _saving ? null : _save, child: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : Text(isEdit ? 'حفظ' : 'موافق')),
                  const SizedBox(width: 12),
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black, elevation: 0), onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('إلغاء')),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(ItemModel? item) {
    if (item?.id != null) return 'الصنف';
    final now = DateTime.now();
    return now.year.toString() + '-' + now.month.toString().padLeft(2, '0') + '-' + now.day.toString().padLeft(2, '0');
  }
}
