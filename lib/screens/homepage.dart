import 'package:evodie/utils/my_materials.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables de l'utilisateur
  String userName = "";
  String userRole = "Propriétaire";
  final supabase = Supabase.instance.client;
  String? userId;

  // Index de l'écran actuel
  int _currentIndex = 0;

  // Écrans de l'application
  final List<Widget> _screens = [
    const Center(child: DashBoardPage()),
    const Vente(),
    const Commande(),
    const MonEntreprise(),
  ];

  @override
  void initState() {
    super.initState();
    // Appel à la récupération des données utilisateur
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      userId = session.user.id;
      await _fetchUserData();
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  // Fonction pour récupérer les données utilisateur depuis Supabase
  Future<void> _fetchUserData() async {
    try {
      final response = await supabase
          .from('utilisateurs') // Table utilisateur
          .select('nom_utilisateur')
          .eq('id', userId!) // Filtre par user_id
          .single(); // Récupérer une seule ligne

      if (response != null) {
        setState(() {
          userName =
              response['nom_utilisateur']; // Assignez le nom d'utilisateur
        });
      }
    } catch (error) {
      print("Erreur lors de la récupération des données utilisateur : $error");
    }
  }

  // Changement de page
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Navigation vers la page de l'historique
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
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AppBar(
            elevation: 0,
            leading: const CircleAvatar(
              backgroundColor: ColorsConstant.green,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  userName.isNotEmpty ? userName : "Chargement...",
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
                    Icons.settings_outlined,
                    size: 20,
                    color: Colors.black,
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
        selectedItemColor: const Color.fromARGB(255, 137, 255, 204),
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
