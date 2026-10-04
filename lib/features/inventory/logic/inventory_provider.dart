import 'package:flutter/foundation.dart';
import '../data/database/inventory_db_helper.dart';
import '../data/models/item_model.dart';

class InventoryProvider with ChangeNotifier{
  final _db=InventoryDBHelper.instance; List<ItemModel> _items=[]; List<ItemModel> _filtered=[];
  String _category='الكل',_query=''; bool _loading=false; String? _error;
  List<ItemModel> get items=>List.unmodifiable(_filtered); bool get isLoading=>_loading; String get selectedCategory=>_category; String? get errorMessage=>_error;
  List<String> get availableCategories{final s={'الكل','تلفونات','إكسسوارات','قطع غيار','عام',..._items.map((e)=>e.category)};final r=s.where((e)=>e!='الكل'&&e.isNotEmpty).toList()..sort();r.insert(0,'الكل');return r;}
  Future<void> fetchItems()async{_loading=true;_error=null;notifyListeners();try{_items=await _db.getAllItems();_apply(false);}catch(e){_error='تعذر تحميل الأصناف: '+e.toString();_filtered=[];}finally{_loading=false;notifyListeners();}}
  void setSearchQuery(String q){_query=q.trim().toLowerCase();_apply();}
  void setCategoryFilter(String c){_category=c;_apply();}
  void _apply([bool notify=true]){_filtered=_items.where((x){final a=_category=='الكل'||x.category==_category;final b=_query.isEmpty||x.name.toLowerCase().contains(_query)||(x.barcode?.toLowerCase().contains(_query)??false)||(x.notes?.toLowerCase().contains(_query)??false);return a&&b;}).toList();if(notify)notifyListeners();}
  Future<bool> saveItem(ItemModel x)async{try{if(x.id==null)await _db.insertItem(x);else await _db.updateItem(x);await fetchItems();return true;}catch(e){_error='تعذر حفظ الصنف: '+e.toString();notifyListeners();return false;}}
  Future<bool> deleteItem(int id)async{try{await _db.deleteItem(id);await fetchItems();return true;}catch(e){_error='تعذر حذف الصنف: '+e.toString();notifyListeners();return false;}}
}