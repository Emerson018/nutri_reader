import 'package:flutter/material.dart';
import '../../navigation/bottom_navbar/bottom_navbar_view.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController _controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.navController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_controller.currentTitle),
            centerTitle: true,
          ),
          body: _controller.currentPage,
          bottomNavigationBar:
              BottomNavBarView(controller: _controller.navController),
          floatingActionButton: FloatingActionButton(
            onPressed: _controller.onCentralButtonPressed,
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
