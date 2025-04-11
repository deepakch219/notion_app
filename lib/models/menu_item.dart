import '../config/app_config.dart';

class MenuItem {
  final int id;
  final String name;
  final String description;
  final double originalPrice;
  final String image;
  final int partnerId;
  final String foodType;
  final double rating;  
  final String hotelName;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.image,
    required this.partnerId,
    required this.foodType,
    required this.rating,  
    required this.hotelName,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    String imagePath = json['image'] ?? '';
    String fullImageUrl = imagePath.startsWith('/public/storage')
        ? "${AppConfig.baseUrl}${imagePath.substring(1)}"
        : "${AppConfig.imageBaseUrl}$imagePath";

    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      originalPrice: json['original_price'].toDouble(),
      image: fullImageUrl,
      partnerId: json['partner_id'],
      foodType: json['food_type'],
      rating: (json['rating'] ?? 0).toDouble(),  
      hotelName: json['hotel_name'],
    );
  }
}