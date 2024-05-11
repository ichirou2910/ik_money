import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Menu {
  final String name;
  final String description;
  final String url;
  final Icon icon;

  const Menu({
    required this.name,
    required this.description,
    required this.url,
    required this.icon,
  });
}

class MainScreen extends StatefulWidget {
  final List<Menu> menus = const [
    Menu(
      name: "Accounting",
      description: "Manage your transactions",
      url: "/accounting",
      icon: Icon(Icons.money),
    ),
    Menu(
      name: "Notes",
      description: "Manage your notes",
      url: "/accounting",
      icon: Icon(Icons.notes),
    ),
  ];

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Text(
                "Welcome, Ichirou.",
                style: TextStyle(fontSize: 30),
              ),
            ),
            ..._buildMenus(widget.menus, context)
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMenus(List<Menu> menus, BuildContext context) {
    return menus
        .map(
          (m) => ListTile(
            onTap: () {
              context.push(m.url);
            },
            title: Text(m.name, style: const TextStyle(fontSize: 18)),
            subtitle: Text(m.description),
            leading: m.icon,
          ),
        )
        .toList();
  }
}
