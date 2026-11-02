
import 'package:flutter/material.dart';

class EcheanceDetailPage extends StatefulWidget {
  final String titre;
  final String date;
  final bool terminee;

  const EcheanceDetailPage({
    super.key,
    required this.titre,
    required this.date,
    required this.terminee,
  });

  @override
  State<EcheanceDetailPage> createState() =>
      _EcheanceDetailPageState();
}

class _EcheanceDetailPageState
    extends State<EcheanceDetailPage> {
  late bool estTerminee;

  @override
  void initState() {
    super.initState();
    estTerminee = widget.terminee;
  }

  // Convertir la date en DateTime.
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

    return null;
  }

  // Vérifier si l'échéance est en retard.
  bool get estEnRetard {
    if (estTerminee) return false;

    final date = _convertirDate(widget.date);

    if (date == null) return false;

    final maintenant = DateTime.now();

    final aujourdHui = DateTime(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );

    return date.isBefore(aujourdHui);
  }

  @override
  Widget build(BuildContext context) {
    final String statut = estTerminee
        ? 'Terminée'
        : estEnRetard
        ? 'En retard'
        : 'À faire';

    final Color couleurStatut = estTerminee
        ? Colors.green
        : estEnRetard
        ? Colors.red
        : Colors.orange;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text('Détail de l’échéance'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF173B70),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.event_note,
                color: Color(0xFF173B70),
                size: 32,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'INTITULÉ DE L’ACTIVITÉ',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              widget.titre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173B70),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              color: Colors.white,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(18),

                child: Column(
                  children: [
                    _infoRow(
                      Icons.calendar_month,
                      'Date limite',
                      widget.date,
                    ),

                    const Divider(height: 30),

                    _infoRow(
                      Icons.info_outline,
                      'Statut',
                      statut,
                      couleur: couleurStatut,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: estTerminee
                    ? null
                    : () {
                  Navigator.pop(context, true);
                },

                icon: const Icon(Icons.check_circle),

                label: Text(
                  estTerminee
                      ? 'Déjà terminée'
                      : 'Marquer comme fait',
                ),

                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF173B70),
                ),
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(
      IconData icone,
      String titre,
      String valeur, {
        Color couleur = Colors.black87,
      }) {
    return Row(
      children: [
        Icon(
          icone,
          color: const Color(0xFF173B70),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            titre,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ),

        Flexible(
          child: Text(
            valeur,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: couleur,
            ),
          ),
        ),
      ],
    );
  }
}
