
import 'package:flutter/material.dart';

class EcheanceFormPage extends StatefulWidget {
  const EcheanceFormPage({super.key});

  @override
  State<EcheanceFormPage> createState() =>
      _EcheanceFormPageState();
}

class _EcheanceFormPageState extends State<EcheanceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titreController =
  TextEditingController();

  final TextEditingController _dateController =
  TextEditingController();

  @override
  void dispose() {
    _titreController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Enregistrer une nouvelle échéance
  void _enregistrer() {
    if (_formKey.currentState!.validate()) {
      final nouvelleEcheance = {
        'titre': _titreController.text.trim(),
        'date': _dateController.text,
        'terminee': false,
        // L'icône est enregistrée sous forme de texte
        'icone': 'event_note',
      };

      Navigator.pop(context, nouvelleEcheance);
    }
  }

  // Choisir une date
  Future<void> _choisirDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      helpText: 'Sélectionner une date limite',
      cancelText: 'Annuler',
      confirmText: 'Valider',
    );

    if (!mounted || date == null) return;

    setState(() {
      _dateController.text =
      '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text('Ajouter une échéance'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF173B70),
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nouvelle activité',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF173B70),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Renseignez les informations de votre échéance.',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              const Text(
                'Titre de l’activité',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _titreController,
                textCapitalization: TextCapitalization.sentences,

                decoration: InputDecoration(
                  hintText: 'Exemple : Projet Flutter',
                  prefixIcon: const Icon(Icons.edit),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir un titre';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 25),

              const Text(
                'Date limite',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: _dateController,
                readOnly: true,

                decoration: InputDecoration(
                  hintText: 'Choisir une date',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                onTap: _choisirDate,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez choisir une date';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 52,

                child: FilledButton.icon(
                  onPressed: _enregistrer,

                  icon: const Icon(Icons.save),

                  label: const Text('Enregistrer'),

                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF173B70),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
