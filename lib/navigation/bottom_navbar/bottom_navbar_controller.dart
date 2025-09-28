import 'bottom_navbar_model.dart';
import 'package:flutter/material.dart';

class BottomNavBarController extends ChangeNotifier {
  final BottomNavBarModel _model = BottomNavBarModel();

  int get selectedIndex => _model.selectedIndex;
  List<Map<String, dynamic>> get items => _model.items;

  void setIndex(int index) {
    _model.selectedIndex = index;
    notifyListeners();
  }

  void onCentralButtonPressed() {
    // Aqui você pode abrir a câmera ou qualquer ação principal
    debugPrint("Botão central pressionado!");
  }
}
