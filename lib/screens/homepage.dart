import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/screens/commande.dart';
import 'package:evodie/screens/dashboard.dart';
import 'package:evodie/screens/historique.dart';
import 'package:evodie/screens/mon_entreprise.dart';
import 'package:evodie/screens/profile.dart';
import 'package:evodie/screens/vente.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // information de l'utilisateur
  String userName = "Jeanine Namwana";
  String userRole = "Propriétaire";

  // changement de page
  int _currentIndex = 0; // Index de l'écran actuel

  final List<Widget> _screens = [
    const Center(child: DashBoardPage()),
    const Vente(),
    const Commande(),
    const MonEntreprise(),
  ];

  void _onItemTapped(int index) {
    // Pour les autres pages, mettre à jour l'index courant
    setState(() {
      _currentIndex = index;
    });
  }

  // navigator vers la page de l'historique
  void _onHistoriqueTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoriquePage()),
    );
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                AutoSizeText(
                  userRole,
                  style: const TextStyle(fontSize: 15),
                  maxLines: 1,
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: _onHistoriqueTapped,
                icon: const Icon(
                  Icons.history,
                  color: ColorsConstant.black,
                  size: 30,
                ),
              ),
              // profil de l'utilisateur
              GestureDetector(
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
                    Icons.settings_outlined, // L'icône que vous voulez afficher
                    size: 20,
                    color: Colors.black, // Couleur de l'icône
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
// Affichage de l'écran actuel
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_rounded), label: 'Vente'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_rounded), label: 'Commande'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Mon Entreprise'),
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
