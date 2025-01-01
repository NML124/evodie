import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Commande extends StatefulWidget {
  const Commande({super.key});

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();

  bool isLoading = true;
  bool isSubmitting = false; // Nouveau booléen pour suivre l'état de soumission

  @override
  void initState() {
    super.initState();
    fetchProduits();
  }

  Future<void> fetchProduits() async {
    try {
      await ProduitsOptions.fetchProduits(supabase);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> insertCommande() async {
    final String selectedProduit = ProduitsOptions.selectedProduit ?? '';
    final int quantiteCommande = int.tryParse(_quantiteController.text) ?? 0;
    final int prixCommande = int.tryParse(_prixController.text) ?? 0;

    if (selectedProduit.isEmpty || quantiteCommande <= 0 || prixCommande <= 0) {
      print('Veuillez entrer un produit, une quantité et un prix valides');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Veuillez entrer un produit, une quantité et un prix valides."),
      ));
      return;
    }

    final produitId = await getProduitId(selectedProduit, supabase);
    if (produitId == null) {
      print('Produit non trouvé');
      return;
    }

    setState(() {
      isSubmitting = true; // Commence le chargement
    });

    try {
      final response = await supabase.from('commandes').insert({
        'produit_id': produitId,
        'quantite_commande': quantiteCommande,
        'prix_commande': prixCommande,
        'utilisateur_id': supabase.auth.currentUser?.id,
      }).select();

      if (response.isEmpty) {
        print('Erreur lors de l\'insertion');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erreur lors de l'insertion de la commande."),
        ));
      } else {
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Commande enregistrée avec succès."),
        ));
        // Réinitialiser les champs après l'enregistrement
        resetFields();
      }
    } catch (e) {
      print('Erreur lors de l\'insertion: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Une erreur est survenue lors de l'insertion."),
      ));
    } finally {
      setState(() {
        isSubmitting = false; // Arrête le chargement
      });
    }
  }

  void resetFields() {
    setState(() {
      _quantiteController.clear();
      _prixController.clear();
      ProduitsOptions.setSelectedProduit(null);
    });
  }

  Future<int?> getProduitId(String nomProduit, SupabaseClient supabase) async {
    final utilisateurId = supabase.auth.currentUser?.id;

    if (utilisateurId == null) {
      print('Utilisateur non connecté');
      return null;
    }

    try {
      final response = await supabase
          .from('produits')
          .select('id')
          .eq('nom_produit', nomProduit)
          .eq('utilisateur_id', utilisateurId)
          .limit(1)
          .single();

      final id = response['id'];
      return id as int?;
    } catch (e) {
      print('Erreur lors de la récupération de l\'ID du produit: $e');
      return null;
    }
  }

  void showConfirmationDialog() {
    // Affichage de la boîte de dialogue
    showDialog(
      context: context,
      barrierDismissible:
          false, // Empêche la fermeture de la boîte de dialogue pendant le processus
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Confirmer l'enregistrement"),
              content: isSubmitting
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: const Center(
                        child:
                            CircularProgressIndicator(), // Affiche un spinner pendant le traitement
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Produit: ${ProduitsOptions.selectedProduit ?? 'N/A'}"),
                        Text("Quantité: ${_quantiteController.text}"),
                        Text("Prix: ${_prixController.text} Francs"),
                      ],
                    ),
              actions: [
                // Bouton Annuler
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          Navigator.of(context)
                              .pop(); // Ferme la boîte de dialogue sans rien faire
                        },
                  child: const Text("Annuler"),
                ),
                // Bouton Confirmer
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setDialogState(() {
                            isSubmitting = true; // Déclenche le spinner
                          });

                          await insertCommande(); // Appelle la fonction pour ajouter la commande

                          setDialogState(() {
                            isSubmitting = false; // Arrête le spinner
                          });

                          Navigator.of(context)
                              .pop(); // Ferme la boîte de dialogue après traitement
                        },
                  child: isSubmitting
                      ? const Text("Traitement en cours...")
                      : const Text("Confirmer"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _quantiteController.dispose();
    _prixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorsConstant.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: AutoSizeText(
                        'COMMANDE',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorsConstant.black,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorsConstant.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    const AutoSizeText(
                      "Produit:",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        items:
                            ProduitsOptions.listeProduits.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: AutoSizeText(
                              value,
                              style:
                                  const TextStyle(color: ColorsConstant.black),
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                        value: ProduitsOptions.selectedProduit,
                        onChanged: (String? newValue) {
                          setState(() {
                            ProduitsOptions.setSelectedProduit(newValue);
                          });
                        },
                        iconSize: 30,
                        style: TextStyle(fontSize: 18),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: Colors.black,
                        ),
                        hint: const AutoSizeText(
                          "produit commandé",
                          style: TextStyle(color: Colors.grey),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    const AutoSizeText(
                      "Prix(franc):",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _prixController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Prix de la commande',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    const AutoSizeText(
                      "Quantité:",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _quantiteController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Quantité de paquet commandé',
                          hintStyle: TextStyle(color: Colors.grey),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomElevatedButton(
              buttonText: "Enregistrer",
              onPressed: showConfirmationDialog,
            )
          ],
        ),
      ),
    );
  }
}
