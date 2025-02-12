import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String id;
  final String userId;
  String? itemName;
  String? description;
  String? sellerId;
  double? price;
  String? unit;
  String? imgUrl;
  bool isAvailable;
  double? weight;
  String? location;
  String? age;

  ItemModel({
    required this.id,
    required this.userId,
    this.itemName,
    this.description,
    this.sellerId,
    this.price,
    this.unit,
    this.imgUrl,
    this.isAvailable = true,
    this.weight,
    this.location,
    this.age,
  });

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItemModel(
      id: doc.id,
      userId: data['userUid'] as String? ?? '',
      itemName: data['itemName'] as String? ?? 'Sem Nome',
      description: data['description'] as String? ?? '',
      sellerId: data['sellerId'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      unit: data['unit'] as String? ?? '',
      imgUrl: data['imageUrl'] as String? ?? '',
      isAvailable: data['isAvailable'] ?? true,
      weight: (data['weight'] as num?)?.toDouble(),
      location: data['location'] as String?,
      age: data['age'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userUid': userId,
      'itemName': itemName,
      'description': description,
      'sellerId': sellerId,
      'price': price,
      'unit': unit,
      'imageUrl': imgUrl,
      'isAvailable': isAvailable,
      'weight': weight,
      'location': location,
      'age': age,
    };
  }
}
