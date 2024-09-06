import 'package:evodie/Constants/colors.dart';
import 'package:evodie/screens/commande.dart';
import 'package:evodie/screens/dashboard.dart';
import 'package:evodie/screens/profile.dart';
import 'package:evodie/screens/vente.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const Center(child: DashBoardPage()),
    const Vente(),
    const Commande()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Hauteur personnalisée
        child: Padding(
          padding: const EdgeInsets.all(8), // Padding horizontal
          child: AppBar(
            elevation: 0,
            leading: const CircleAvatar(
              backgroundColor: ColorsConstant.green,
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jeanine Namwana",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Propriétaire",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: [
              GestureDetector.new(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Profile(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 2, color: ColorsConstant.black)),
                  child: const Icon(
                    Icons.settings_outlined, // l'icône que vous voulez afficher
                    size: 35,
                    color: Colors.black, // couleur de l'icône
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded), label: 'Vente'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_rounded), label: 'Commande'),
        ],
        selectedItemColor: Color.fromARGB(255, 137, 255, 204),
        unselectedItemColor: ColorsConstant.white,
        backgroundColor: ColorsConstant.green,
        type: BottomNavigationBarType.fixed,
        elevation: 3,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        selectedFontSize: 15,
        unselectedFontSize: 15,
        selectedIconTheme: const IconThemeData(size: 20),
        unselectedIconTheme: const IconThemeData(size: 20),
      ),
    );
  }
}

class VentePage {
  const VentePage();
}
