import 'package:get/get.dart';
import '../models/menu_item.dart';
import '../services/api_service.dart';

class FoodMenuController extends GetxController {
  var menuItems = <MenuItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchMenuItems();
    super.onInit();
  }

  Future<void> fetchMenuItems() async {
    try {
      isLoading(true);
      final items = await ApiService().fetchMenuItems();
      menuItems.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}