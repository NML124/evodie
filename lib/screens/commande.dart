import 'package:evodie/utils/my_materials.dart';

class Commande extends StatefulWidget {
  const Commande({super.key});

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoading = true;
  bool isSubmitting = false; // Nouveau booléen pour suivre l'état de soumission

  final List<String> _items = ['COMMANDE', 'LIVRAISON'];
  final List<Widget> _pages = [CommandePage(), LivraisonPage()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                child: Row(
                  children: List.generate(
                    _items.length,
                    (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.09,
                            child: const Divider(
                              thickness: 2,
                              color: ColorsConstant.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AutoSizeText(
                              _items[index],
                              style: TextStyle(
                                fontSize: width * 0.053,
                                fontWeight: _selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedIndex == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Container(
                            width: width * 0.07,
                            child: const Divider(
                              thickness: 2,
                              color: ColorsConstant.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
