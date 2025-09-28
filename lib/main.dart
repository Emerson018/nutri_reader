import 'package:flutter/material.dart';
// Importa os componentes de navegação
import '../../navigation/bottom_navbar/bottom_navbar_view.dart';
import '../../navigation/bottom_navbar/bottom_navbar_controller.dart';
import 'pages/leitor_foto/leitor_foto_view.dart'; 

// --- Placeholder para as outras telas (Estatísticas, Histórico, Perfil) ---
class PlaceholderView extends StatelessWidget {
  final String title;
  const PlaceholderView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title, 
        style: const TextStyle(fontSize: 24, color: Colors.grey),
      )
    );
  }
}
// ----------------------------------------

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodVision AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema principal alterado para verde, que combina com a nutrição
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade700,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainAppShell(), // O HomeView original foi substituído pela MainAppShell
    );
  }
}

// Classe que hospeda o Scaffold principal, o BottomNavBar e o corpo da tela.
class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  final BottomNavBarController _navController = BottomNavBarController();

  // Lista de todas as telas correspondentes aos índices (0, 1, 2, 3, 4)
  final List<Widget> _pages = [
    const LeitorFotoView(), // Index 0
    const PlaceholderView(title: 'Estatísticas'), // Index 1
    const PlaceholderView(title: 'Foto'), // Index 2
    const PlaceholderView(title: 'Histórico'), // Index 3
    const PlaceholderView(title: 'Perfil'), // Index 4
  ];

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder para reagir à mudança de índice do Controller
    return AnimatedBuilder(
      animation: _navController,
      builder: (context, _) {
        return Scaffold(
          // Exibe a página correspondente ao índice atual
          body: _pages[_navController.selectedIndex],
          
          // O FloatingActionButton central para a ação principal (Leitor de Foto)
          floatingActionButton: FloatingActionButton(
            onPressed: () => _navController.onCentralButtonPressed(), // Chama a lógica do Controller
            backgroundColor: Colors.deepOrange, 
            shape: const CircleBorder(),
            child: const Icon(Icons.camera_enhance, color: Colors.white, size: 30),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          
          // A BottomNavBar
          bottomNavigationBar: BottomNavBarView(controller: _navController),
        );
      },
    );
  }
}
