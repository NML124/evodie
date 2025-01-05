import 'package:evodie/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MesProduits extends StatefulWidget {
  const MesProduits({super.key});

  @override
  State<MesProduits> createState() => _MesProduitsState();
}

class _MesProduitsState extends State<MesProduits> {
  final SupabaseClient supabase = Supabase.instance.client;
  late String userId;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      userId = session.user.id;
      await _fetchProducts();
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from('produits')
          .select()
          .eq('utilisateur_id', userId)
          .order('date_ajout', ascending: false);

      setState(() {
        products = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des produits: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showProductForm({Map<String, dynamic>? product}) async {
    final TextEditingController nameController =
        TextEditingController(text: product?['nom_produit'] ?? '');
    final TextEditingController priceController = TextEditingController(
        text: product?['prix_unitaire']?.toString() ?? '');
    final TextEditingController stockController =
        TextEditingController(text: product?['stock']?.toString() ?? '');
    final TextEditingController beneficeController = TextEditingController(
        text: product?['pourcentage_benefice']?.toString() ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AutoSizeText(
                product == null ? 'Ajouter un produit' : 'Modifier le produit',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom du produit'),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Prix unitaire'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: beneficeController,
                decoration:
                    const InputDecoration(labelText: 'Pourcentage de bénéfice'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsConstant.green,
                ),
                onPressed: () async {
                  final String name = nameController.text;
                  final String price = priceController.text;
                  final String stock = stockController.text;
                  final String benefice = beneficeController.text;

                  if (name.isEmpty ||
                      price.isEmpty ||
                      stock.isEmpty ||
                      benefice.isEmpty ||
                      double.tryParse(price) == null ||
                      int.tryParse(stock) == null ||
                      int.tryParse(benefice) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text("Veuillez entrer des valeurs valides.")),
                    );
                    return;
                  }

                  try {
                    if (product == null) {
                      await supabase.from('produits').insert({
                        'nom_produit': name,
                        'prix_unitaire': double.parse(price),
                        'stock': int.parse(stock),
                        'type_vente': 'Paquet(s)',
                        'pourcentage_benefice': int.parse(benefice),
                        'utilisateur_id': userId,
                        'date_ajout': DateTime.now().toIso8601String(),
                      });
                    } else {
                      await supabase.from('produits').update({
                        'nom_produit': name,
                        'prix_unitaire': double.parse(price),
                        'stock': int.parse(stock),
                      }).eq('id', product['id']);
                    }
                    await _fetchProducts();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur: $e")),
                    );
                  }
                },
                child: AutoSizeText(
                  product == null ? 'Ajouter' : 'Modifier',
                  style: TextStyle(color: ColorsConstant.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await supabase.from('produits').delete().eq('id', productId);
      await _fetchProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit supprimé avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText('Mes Produits'),
        backgroundColor: ColorsConstant.green,
        foregroundColor: ColorsConstant.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: ColorsConstant.green,
            ))
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                      title: AutoSizeText(
                        product['nom_produit'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: AutoSizeText(
                          'Prix: ${product['prix_unitaire']} - Stock: ${product['stock']}'),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.edit, color: ColorsConstant.green),
                        onPressed: () => _showProductForm(product: product),
                      ),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: Text('Supprimer le produit ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await _deleteProduct(product['id']);
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                            backgroundColor:
                                                ColorsConstant.green),
                                        child: const Text(
                                          'Oui',
                                          style: TextStyle(
                                            color: ColorsConstant.white,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  ColorsConstant.red),
                                          child: const Text(
                                            'Non',
                                            style: TextStyle(
                                              color: ColorsConstant.white,
                                            ),
                                          ))
                                    ]));
                      }),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.green,
        foregroundColor: ColorsConstant.white,
        onPressed: () => _showProductForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
