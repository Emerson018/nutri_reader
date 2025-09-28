import 'package:flutter/material.dart';
import 'bottom_navbar_controller.dart';

class BottomNavBarView extends StatelessWidget {
  final BottomNavBarController controller;

  const BottomNavBarView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: controller.selectedIndex == 0
                    ? Colors.deepOrange
                    : Colors.grey,
                onPressed: () => controller.setIndex(0),
              ),
              IconButton(
                icon: const Icon(Icons.bar_chart),
                color: controller.selectedIndex == 1
                    ? Colors.deepOrange
                    : Colors.grey,
                onPressed: () => controller.setIndex(1),
              ),
              const SizedBox(width: 40), // espaço para o botão central
              IconButton(
                icon: const Icon(Icons.history),
                color: controller.selectedIndex == 3
                    ? Colors.deepOrange
                    : Colors.grey,
                onPressed: () => controller.setIndex(3),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: controller.selectedIndex == 4
                    ? Colors.deepOrange
                    : Colors.grey,
                onPressed: () => controller.setIndex(4),
              ),
            ],
          ),
        );
      },
    );
  }
}
