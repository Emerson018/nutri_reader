import 'package:flutter/material.dart';

class HomeModel {
  final List<Widget> pages = const [
    Center(child: Text("🏠 Página Inicial")),
    Center(child: Text("📊 Estatísticas")),
    Center(child: Text("📸 Tirar Foto")),
    Center(child: Text("📜 Histórico")),
    Center(child: Text("👤 Perfil")),
  ];
}
