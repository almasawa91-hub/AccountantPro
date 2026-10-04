import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_model.dart';
import '../../logic/inventory_provider.dart';
import '../widgets/add_edit_item_dialog.dart';

class ItemsScreen extends StatefulWidget{const ItemsScreen({super.key});@override State<ItemsScreen> createState()=>_State();}
class _State extends State<ItemsScreen>{
 final search=TextEditingController();
 @override void initState(){super.initState();Future.microtask(()=>context.read<InventoryProvider>().fetchItems());}
 @override void dispose(){search.dispose();super.dispose();}
 void edit([ItemModel? x])=>showDialog(context:context,builder:(_)=>AddEditItemDialog(item:x));
 Future<void> remove(ItemModel x)async{final ok=await showDialog<bool>(context:context,builder:(_)=>Directionality(textDirection:TextDirection.rtl,child:AlertDialog(title:const Text('تأكيد الحذف'),content:Text('هل أنت متأكد من حذف الصنف: '+x.name+'؟'),actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('إلغاء')),FilledButton(onPressed:()=>Navigator.pop(context,true),child:const Text('حذف'))])));if(ok==true&&x.id!=null)await context.read<InventoryProvider>().deleteItem(x.id!);}
 @override Widget build(BuildContext c)=>Directionality(textDirection:TextDirection.rtl,child:Scaffold(appBar:AppBar(title:const Text('إدارة الأصناف والمخزون',style:TextStyle(fontWeight:FontWeight.bold)),centerTitle:true),body:Column(children:[
 Padding(padding:const EdgeInsets.all(12),child:TextField(controller:search,onChanged:context.read<InventoryProvider>().setSearchQuery,decoration:InputDecoration(hintText:'بحث باسم الصنف، الباركود أو المواصفات...',prefixIcon:const Icon(Icons.search),border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)),filled:true))),
 SizedBox(height:44,child:Consumer<InventoryProvider>(builder:(_,p,__)=>
  ListView.separated(scrollDirection:Axis.horizontal,padding:const EdgeInsets.symmetric(horizontal:12),itemCount:p.availableCategories.length,separatorBuilder:(_,__)=>const SizedBox(width:8),itemBuilder:(_,i){final cat=p.availableCategories[i];return ChoiceChip(label:Text(cat),selected:p.selectedCategory==cat,onSelected:(_)=>p.setCategoryFilter(cat));}))),
 Expanded(child:Consumer<InventoryProvider>(builder:(_,p,__){if(p.isLoading)return const Center(child:CircularProgressIndicator());if(p.items.isEmpty)return Center(child:Text(p.errorMessage??'لا توجد أصناف مسجلة حتى الآن'));return RefreshIndicator(onRefresh:p.fetchItems,child:ListView.builder(padding:const EdgeInsets.fromLTRB(12,8,12,90),itemCount:p.items.length,itemBuilder:(_,i){final x=p.items[i];return Card(margin:const EdgeInsets.only(bottom:10),child:ListTile(leading:const CircleAvatar(child:Icon(Icons.inventory_2_outlined)),title:Text(x.name,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('المجموعة: '+x.category+'  •  الكمية: '+x.quantity.toString()),if(x.barcode?.isNotEmpty??false)Text('الباركود: '+x.barcode!),if(x.notes?.isNotEmpty??false)Text('المواصفات: '+x.notes!,maxLines:1,overflow:TextOverflow.ellipsis),if(x.expiryDate!=null)Text('تاريخ الانتهاء: '+x.expiryDate!,style:const TextStyle(color:Colors.amber))]),trailing:Row(mainAxisSize:MainAxisSize.min,children:[Text(x.sellPrice.toStringAsFixed(2)+' ر.ي',style:const TextStyle(fontWeight:FontWeight.bold,color:Colors.green)),PopupMenuButton<String>(onSelected:(v)=>v=='edit'?edit(x):remove(x),itemBuilder:(_)=>const[PopupMenuItem(value:'edit',child:Text('تعديل')),PopupMenuItem(value:'delete',child:Text('حذف'))])])));}));})),
 ]),floatingActionButton:FloatingActionButton.extended(onPressed:edit,icon:const Icon(Icons.add),label:const Text('إضافة صنف')));}
}