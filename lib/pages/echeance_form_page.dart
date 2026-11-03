
import 'package:flutter/material.dart';

import '../models/tache.dart';

class EcheanceFormPage extends StatefulWidget {
  final Map<String, dynamic>? echeance;

  const EcheanceFormPage({
    super.key,
    this.echeance,
  });

  @override
  State<EcheanceFormPage> createState() => _EcheanceFormPageState();
}

class _EcheanceFormPageState extends State<EcheanceFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titreController =
  TextEditingController();

  final TextEditingController _dateController =
  TextEditingController();

  bool get estModification => widget.echeance != null;

  @override
  void initState() {
    super.initState();

    if (estModification) {
      _titreController.text =
          widget.echeance!['titre']?.toString() ?? '';

      _dateController.text =
          widget.echeance!['date']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _titreController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Convertir une date enregistrée en DateTime.
  DateTime? _convertirDate(String valeur) {
    final texte = valeur.trim();

    final formatNumerique = RegExp(
      r'^(\d{1,2})/(\d{1,2})/(\d{4})$',
    );

    final correspondance = formatNumerique.firstMatch(texte);

    if (correspondance != null) {
      return DateTime(
        int.parse(correspondance.group(3)!),
        int.parse(correspondance.group(2)!),
        int.parse(correspondance.group(1)!),
      );
    }

    const mois = {
      'janvier': 1,
      'février': 2,
      'mars': 3,
      'avril': 4,
      'mai': 5,
      'juin': 6,
      'juillet': 7,
      'août': 8,
      'septembre': 9,
      'octobre': 10,
      'novembre': 11,
      'décembre': 12,
    };

    final parties = texte.toLowerCase().split(' ');

    if (parties.length == 3) {
      final jour = int.tryParse(parties[0]);
      final numeroMois = mois[parties[1]];
      final annee = int.tryParse(parties[2]);

      if (jour != null && numeroMois != null && annee != null) {
        return DateTime(annee, numeroMois, jour);
      }
    }

    return DateTime.tryParse(texte);
  }

  // Enregistrer ou modifier une tâche.
  void _enregistrer() {
    if (!_formKey.currentState!.validate()) return;

    final Tache tache = Tache(
      id: estModification
          ? widget.echeance!['id']?.toString() ?? ''
          : '',
      titre: _titreController.text.trim(),
      date: _dateController.text,
      terminee: estModification
          ? widget.echeance!['terminee'] == true
          : false,
      icone: estModification
          ? widget.echeance!['icone']?.toString() ?? 'event_note'
          : 'event_note',
    );

    Navigator.pop(context, tache.toMap());
  }

  // Choisir une date.
  Future<void> _choisirDate() async {
    final DateTime? dateExistante =
    _convertirDate(_dateController.text);

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: dateExistante ?? DateTime.now(),
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
        title: Text(
          estModification
              ? 'Modifier une échéance'
              : 'Ajouter une échéance',
        ),
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
              Text(
                estModification
                    ? 'Modifier l’activité'
                    : 'Nouvelle activité',
                style: const TextStyle(
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
                style: TextStyle(fontWeight: FontWeight.bold),
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
                style: TextStyle(fontWeight: FontWeight.bold),
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
                  label: Text(
                    estModification
                        ? 'Enregistrer les modifications'
                        : 'Enregistrer',
                  ),
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
