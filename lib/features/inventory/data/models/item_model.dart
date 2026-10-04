class ItemModel {
  final int? id; final String name; final String category; final String? barcode;
  final double sellPrice; final double costPrice; final int quantity;
  final String? imagePath; final String? expiryDate; final String? notes;
  const ItemModel({this.id,required this.name,required this.category,this.barcode,required this.sellPrice,this.costPrice=0,this.quantity=0,this.imagePath,this.expiryDate,this.notes});
  Map<String,dynamic> toMap()=>{'id':id,'name':name,'category':category,'barcode':barcode,'sell_price':sellPrice,'cost_price':costPrice,'quantity':quantity,'image_path':imagePath,'expiry_date':expiryDate,'notes':notes};
  factory ItemModel.fromMap(Map<String,dynamic> m)=>ItemModel(id:m['id'] as int?,name:m['name'] as String? ?? '',category:m['category'] as String? ?? 'عام',barcode:m['barcode'] as String?,sellPrice:(m['sell_price'] as num?)?.toDouble() ?? 0,costPrice:(m['cost_price'] as num?)?.toDouble() ?? 0,quantity:(m['quantity'] as num?)?.toInt() ?? 0,imagePath:m['image_path'] as String?,expiryDate:m['expiry_date'] as String?,notes:m['notes'] as String?);
}