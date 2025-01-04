import 'package:evodie/utils/my_materials.dart';

class LivraisonPage extends StatefulWidget {
  const LivraisonPage({super.key});

  @override
  State<LivraisonPage> createState() => _LivraisonPageState();
}

class _LivraisonPageState extends State<LivraisonPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _quantiteController = TextEditingController();

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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> insertLivraison() async {
    final String selectedProduit = ProduitsOptions.selectedProduit ?? '';
    final int quantiteLivre = int.tryParse(_quantiteController.text) ?? 0;

    if (selectedProduit.isEmpty || quantiteLivre <= 0) {
      print('Veuillez entrer un produit, une quantité et un prix valides');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Veuillez entrer un produit et une quantité valides."),
      ));
      return;
    }

    final produitId = await getProduitId(selectedProduit, supabase);
    if (produitId == null) {
      print('Produit non trouvé');
      return;
    }

    if (mounted) {
      setState(() {
        isSubmitting = true; // Commence le chargement
      });
    }

    try {
      final response = await supabase.from('livraisons').insert({
        'produit_livre': produitId,
        'quantite_livre': quantiteLivre,
        'utilisateur_id': supabase.auth.currentUser?.id,
      }).select();

      if (response.isEmpty) {
        print('Erreur lors de l\'insertion');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erreur lors de l'insertion de la livraison."),
        ));
      } else {
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Livraison enregistrée avec succès."),
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
      if (mounted) {
        setState(() {
          isSubmitting = false; // Arrête le chargement
        });
      }
    }
  }

  void resetFields() {
    if (mounted) {
      setState(() {
        _quantiteController.clear();

        ProduitsOptions.setSelectedProduit(null);
      });
    }
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
                          // Appel de la fonction de traitement
                          setDialogState(() {
                            isSubmitting = true; // Déclenche le spinner
                          });

                          await insertLivraison(); // Appelle la fonction pour ajouter la commande

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
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
                    items: ProduitsOptions.listeProduits.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: AutoSizeText(
                          value,
                          style: const TextStyle(color: ColorsConstant.black),
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
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                    hint: const AutoSizeText(
                      "produit livré",
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
                      hintText: 'Quantité de paquet livré',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        CustomElevatedButton(
          buttonText: "Enregistrer",
          onPressed: showConfirmationDialog,
        ),
      ],
    );
  }
}
