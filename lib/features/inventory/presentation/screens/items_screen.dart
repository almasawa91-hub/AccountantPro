import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_model.dart';
import '../../logic/inventory_provider.dart';
import '../widgets/add_edit_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});
  @override State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  static const primaryColor = Color(0xFF1E6F9F);
  final _search = TextEditingController();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<InventoryProvider>().fetchItems());
  }

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  void _openEditor([ItemModel? item]) {
    showDialog(context: context, builder: (_) => AddEditItemDialog(item: item));
  }

  Future<void> _delete(ItemModel item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('حذف الصنف'),
          content: Text('هل أنت متأكد من حذف «' + item.name + '»؟'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف')),
          ],
        ),
      ),
    );
    if (ok == true && item.id != null && mounted) {
      await context.read<InventoryProvider>().deleteItem(item.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.maybePop(context)),
          title: const Text('الأصناف', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: Icon(_searching ? Icons.close : Icons.search),
              onPressed: () => setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _search.clear();
                  context.read<InventoryProvider>().setSearchQuery('');
                }
              }),
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تصدير PDF سيُفعّل مع وحدة التقارير'))),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'refresh') context.read<InventoryProvider>().fetchItems();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'refresh', child: Text('تحديث')),
                PopupMenuItem(value: 'export', child: Text('تصدير')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            if (_searching)
              Container(
                color: primaryColor,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: TextField(
                  controller: _search,
                  autofocus: true,
                  onChanged: context.read<InventoryProvider>().setSearchQuery,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن اسم الصنف أو الباركود...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('اسم الصنف', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(flex: 2, child: Text('مجموعة الصنف', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(flex: 2, child: Text('ك الافتتاحية', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(flex: 2, child: Text('تكلفة الوحدة', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ],
              ),
            ),
            Expanded(
              child: Consumer<InventoryProvider>(
                builder: (_, provider, __) {
                  if (provider.isLoading) return const Center(child: CircularProgressIndicator());
                  if (provider.items.isEmpty) {
                    return Center(child: Text(provider.errorMessage ?? 'لا توجد أصناف... اضغط (+) للإضافة', style: const TextStyle(color: Colors.black54, fontSize: 16), textAlign: TextAlign.center));
                  }
                  return RefreshIndicator(
                    onRefresh: provider.fetchItems,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: provider.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.grey),
                      itemBuilder: (_, index) {
                        final item = provider.items[index];
                        return InkWell(
                          onTap: () => _openEditor(item),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(item.name, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                                Expanded(flex: 2, child: Text(item.category, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black87))),
                                Expanded(flex: 2, child: Text(item.quantity.toString(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
                                Expanded(flex: 2, child: Text(item.costPrice.toStringAsFixed(0), textAlign: TextAlign.center, style: const TextStyle(fontSize: 13))),
                                PopupMenuButton<String>(
                                  onSelected: (v) { if (v == 'edit') _openEditor(item); if (v == 'delete') _delete(item); },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(value: 'edit', child: Text('تعديل')),
                                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(heroTag: 'barcode_btn', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ماسح الباركود سيُربط بوحدة الباركود'))), backgroundColor: primaryColor, mini: true, child: const Icon(Icons.qr_code_scanner, color: Colors.white)),
              FloatingActionButton(heroTag: 'add_btn', onPressed: _openEditor, backgroundColor: primaryColor, mini: true, child: const Icon(Icons.add, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
