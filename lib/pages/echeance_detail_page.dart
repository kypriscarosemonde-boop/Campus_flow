
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/tache.dart';
import '../providers/tache_provider.dart';

class EcheanceDetailPage extends ConsumerWidget {
  final String id;

  const EcheanceDetailPage({
    super.key,
    required this.id,
  });

  final Color couleurPrincipale = const Color(0xFF173B70);

  // Conversion de la date
  DateTime? _convertirDate(String valeur) {
    final texte = valeur.trim();

    final formatNumerique =
    RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');

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
      'fevrier': 2,
      'mars': 3,
      'avril': 4,
      'mai': 5,
      'juin': 6,
      'juillet': 7,
      'août': 8,
      'aout': 8,
      'septembre': 9,
      'octobre': 10,
      'novembre': 11,
      'décembre': 12,
      'decembre': 12,
    };

    final parties = texte.toLowerCase().split(RegExp(r'\s+'));

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

  // Vérifier si la tâche est en retard
  bool _estEnRetard(Tache tache) {
    if (tache.terminee) return false;

    final date = _convertirDate(tache.date);

    if (date == null) return false;

    final maintenant = DateTime.now();

    final aujourdHui = DateTime(
      maintenant.year,
      maintenant.month,
      maintenant.day,
    );

    return date.isBefore(aujourdHui);
  }

  // Récupérer l'icône
  IconData _iconeDepuisNom(String nom) {
    switch (nom) {
      case 'calendar_month':
        return Icons.calendar_month;
      case 'assignment':
        return Icons.assignment;
      case 'menu_book':
        return Icons.menu_book;
      case 'people_alt':
        return Icons.people_alt;
      case 'code':
        return Icons.code;
      default:
        return Icons.event_note;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Récupération des tâches depuis Riverpod
    final tachesAsync = ref.watch(tachesProvider);

    return tachesAsync.when(
      loading: () => _pageChargement(),

      error: (erreur, trace) => _pageErreur(erreur.toString()),

      data: (taches) {
        // Recherche de la tâche grâce à son identifiant
        Tache? tache;

        for (final element in taches) {
          if (element.id == id) {
            tache = element;
            break;
          }
        }

        if (tache == null) {
          return _pageIntrouvable();
        }

        return _pageDetail(context, tache);
      },
    );
  }

  // Page de chargement
  Widget _pageChargement() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: _appBar(),
      body: Center(
        child: CircularProgressIndicator(
          color: couleurPrincipale,
        ),
      ),
    );
  }

  // Page d'erreur
  Widget _pageErreur(String erreur) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: _appBar(),
      body: Center(
        child: Text('Erreur de chargement : $erreur'),
      ),
    );
  }

  // Tâche introuvable
  Widget _pageIntrouvable() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: _appBar(),
      body: const Center(
        child: Text(
          'Cette échéance est introuvable.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  // Barre supérieure
  AppBar _appBar() {
    return AppBar(
      title: const Text('Détail de l’échéance'),
      backgroundColor: Colors.white,
      foregroundColor: couleurPrincipale,
      elevation: 0,
    );
  }

  // Interface principale du détail
  Widget _pageDetail(BuildContext context, Tache tache) {
    final bool estTerminee = tache.terminee;
    final bool retard = _estEnRetard(tache);

    final String statut = estTerminee
        ? 'Terminée'
        : retard
        ? 'En retard'
        : 'À faire';

    final Color couleurStatut = estTerminee
        ? Colors.green
        : retard
        ? Colors.red
        : Colors.orange;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: _appBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 150,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Icône de l'activité
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0FA),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _iconeDepuisNom(tache.icone),
                  color: couleurPrincipale,
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
                tache.titre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF173B70),
                ),
              ),

              const SizedBox(height: 30),

              // Informations de l'échéance
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
                        tache.date,
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

              const SizedBox(height: 40),

              // Bouton pour terminer l'échéance
              SizedBox(
                width: double.infinity,
                height: 52,

                child: FilledButton.icon(
                  onPressed: estTerminee
                      ? null
                      : () {
                    context.pop(true);
                  },

                  icon: const Icon(Icons.check_circle),

                  label: Text(
                    estTerminee
                        ? 'Déjà terminée'
                        : 'Marquer comme fait',
                  ),

                  style: FilledButton.styleFrom(
                    backgroundColor: couleurPrincipale,
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  // Ligne d'information
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
          color: couleurPrincipale,
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
