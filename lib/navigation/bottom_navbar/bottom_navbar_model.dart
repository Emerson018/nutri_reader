class BottomNavBarModel {
  // Índice da aba selecionada
  int selectedIndex = 0;

  // Ícones das abas
  final List<Map<String, dynamic>> items = [
    {"icon": "home", "label": "Home"},
    {"icon": "bar_chart", "label": "Estatísticas"},
    {"icon": "camera_alt", "label": "Foto"}, // botão central
    {"icon": "history", "label": "Histórico"},
    {"icon": "person", "label": "Perfil"},
  ];
}
