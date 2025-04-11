import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; // navigation

// controllers
import 'package:notion_app/controllers/cart_controller.dart';
import 'package:notion_app/controllers/menu_controller.dart';

// screens
import 'package:notion_app/views/screens/cart_screen.dart';
import 'package:notion_app/views/screens/item_detail_screen.dart';
import 'package:notion_app/views/screens/menu_screen.dart';
import 'package:notion_app/views/screens/splash_screen.dart';

void main() {
  
  Get.put(FoodMenuController()); 
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Food App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF06292)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/', page: () => MenuScreen()),
        GetPage(name: '/item-detail', page: () => ItemDetailScreen()),
        GetPage(name: '/cart', page: () => CartScreen()),
      ],
    );
  }
}

