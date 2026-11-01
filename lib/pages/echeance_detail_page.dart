
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

  @override
  Widget build(BuildContext context) {
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
                      estTerminee ? 'Terminée' : 'À faire',
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
      String valeur,
      ) {
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
