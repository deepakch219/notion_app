import 'menu_item.dart';
import '../config/app_config.dart';

class CartItem {
  final int id;
  final int menuId;
  final String menuName;
  final String menuImage;
  final double menuPrice;
  int quantity;
  final String size;
  final String hotelName;

  CartItem({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.menuImage,
    required this.menuPrice,
    required this.quantity,
    required this.size,
    required this.hotelName,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    String imagePath = json['menu_image'] ?? '';
    
    String fullImageUrl = imagePath.startsWith('/public/storage')
        ? "${AppConfig.baseUrl}${imagePath.substring(1)}"
        : "${AppConfig.imageBaseUrl}$imagePath";

    return CartItem(
      id: json['id'],
      menuId: json['menu_id'],
      menuName: json['menu_name'],
      menuImage: fullImageUrl, 
      menuPrice: json['menu_price'].toDouble(),
      quantity: json['quantity'],
      size: json['size'],
      hotelName: json['hotel_name'],
    );
  }

  factory CartItem.fromMenuItem(MenuItem menuItem, {required int id, int quantity = 1, String size = 'Standard'}) {
    return CartItem(
      id: id,
      menuId: menuItem.id,
      menuName: menuItem.name,
      menuImage: menuItem.image, 
      menuPrice: menuItem.originalPrice,
      quantity: quantity,
      size: size,
      hotelName: menuItem.hotelName,
    );
  }
}