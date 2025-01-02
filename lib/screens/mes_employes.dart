import 'package:evodie/utils/my_materials.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class EmployePage extends StatefulWidget {
  const EmployePage({super.key});

  @override
  State<EmployePage> createState() => _EmployePageState();
}

class _EmployePageState extends State<EmployePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> employees = [];
  late String userId;
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
      await _fetchEmployees();
    } else {
      // Redirection si l'utilisateur n'est pas connecté
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from('employe')
          .select()
          .eq('utilisateur_id', userId)
          .order('date_creation', ascending: false);
      setState(() {
        employees = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des employés: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addEmployee() async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController salaryController = TextEditingController();

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
              const AutoSizeText(
                'Ajouter un employé',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: salaryController,
                decoration: const InputDecoration(labelText: 'Salaire'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      emailController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      salaryController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Tous les champs sont requis.")),
                    );
                    return;
                  }

                  try {
                    await supabase.from('employe').insert({
                      'nom_employe': nameController.text,
                      'email': emailController.text,
                      'password':
                          passwordController.text, // À hasher dans un vrai cas
                      'telephone': phoneController.text,
                      'salaire': double.parse(salaryController.text),
                      'utilisateur_id': userId,
                    });
                    await _fetchEmployees();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Erreur lors de l'ajout: $e")),
                    );
                  }
                },
                child: const AutoSizeText('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteEmployee(int employeeId) async {
    try {
      await supabase.from('employe').delete().eq('id', employeeId);
      await _fetchEmployees();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employé supprimé avec succès')),
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
        title: const AutoSizeText('Gestion des Employés'),
        backgroundColor: ColorsConstant.green,
        foregroundColor: ColorsConstant.white,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: ColorsConstant.green,
            ))
          : ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return Dismissible(
                  key: ValueKey(employee['id']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Confirmation'),
                              content: const Text(
                                  'Voulez-vous vraiment supprimer cet employé ?'),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: ColorsConstant.green),
                                  child: const Text('Annuler'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: ColorsConstant.red),
                                  child: const Text('Supprimer'),
                                  onPressed: () {
                                    _deleteEmployee(employee['id']);
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ));
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: AutoSizeText(
                        employee['nom_employe'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: AutoSizeText(
                          'Email: ${employee['email']} - Salaire: ${employee['salaire']}'),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstant.green,
        foregroundColor: ColorsConstant.white,
        onPressed: _addEmployee,
        child: const Icon(Icons.add),
      ),
    );
  }
}
