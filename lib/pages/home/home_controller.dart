import 'package:flutter/material.dart';
import '../../navigation/bottom_navbar/bottom_navbar_controller.dart';
import 'home_model.dart';

class HomeController extends ChangeNotifier {
  final HomeModel model = HomeModel();
  final BottomNavBarController navController = BottomNavBarController();

  Widget get currentPage => model.pages[navController.selectedIndex];

  String get currentTitle =>
      navController.items[navController.selectedIndex]["label"];

  void onCentralButtonPressed() {
    navController.onCentralButtonPressed();
    notifyListeners();
  }
}
