
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/tache.dart';
import '../providers/tache_provider.dart';
import 'echeance_form_page.dart';

class EcheancesPage extends ConsumerStatefulWidget {
  const EcheancesPage({super.key});

  @override
  ConsumerState<EcheancesPage> createState() =>
      _EcheancesPageState();
}

class _EcheancesPageState extends ConsumerState<EcheancesPage> {
  final TextEditingController _rechercheController =
  TextEditingController();

  String filtreActuel = 'Toutes';

  final Color couleurPrincipale = const Color(0xFF173B70);
  final Color couleurFond = const Color(0xFFF4F6FA);

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  // =====================================================
  // GESTION DES ICÔNES
  // =====================================================

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

  // =====================================================
  // GESTION DES DATES
  // =====================================================

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

      if (jour != null &&
          numeroMois != null &&
          annee != null) {
        return DateTime(annee, numeroMois, jour);
      }
    }

    return DateTime.tryParse(texte);
  }

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

  // =====================================================
  // RECHERCHE ET FILTRAGE
  // =====================================================



  // =====================================================
  // AJOUT D'UNE TÂCHE
  // =====================================================

  Future<void> _ajouterTache() async {
    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EcheanceFormPage(),
      ),
    );

    if (!mounted || resultat == null) return;

    try {
      final donnees = Map<String, dynamic>.from(resultat);

      final nouvelleTache = Tache(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titre: donnees['titre']?.toString() ?? '',
        date: donnees['date']?.toString() ?? '',
        terminee: donnees['terminee'] == true,
        icone: donnees['icone']?.toString() ?? 'event_note',
      );

      await ref.read(tachesProvider.notifier).ajouter(
        nouvelleTache,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nouvelle tâche ajoutée et sauvegardée !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (erreur) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l’ajout : $erreur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // MODIFICATION D'UNE TÂCHE
  // =====================================================

  Future<void> _modifierTache(Tache tache) async {
    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EcheanceFormPage(
          echeance: tache.toMap(),
        ),
      ),
    );

    if (!mounted || resultat == null) return;

    try {
      final donnees = Map<String, dynamic>.from(resultat);

      final tacheModifiee = Tache(
        id: tache.id,
        titre: donnees['titre']?.toString() ?? tache.titre,
        date: donnees['date']?.toString() ?? tache.date,
        terminee: donnees['terminee'] == true,
        icone: donnees['icone']?.toString() ?? tache.icone,
      );

      await ref.read(tachesProvider.notifier).modifier(
        tacheModifiee,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tâche modifiée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (erreur) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la modification : $erreur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // SUPPRESSION D'UNE TÂCHE
  // =====================================================

  Future<void> _supprimerTache(Tache tache) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer cette tâche ?'),
          content: Text(
            'Voulez-vous vraiment supprimer "${tache.titre}" ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmation != true) return;

    try {
      await ref.read(tachesProvider.notifier).supprimer(tache.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tâche supprimée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (erreur) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la suppression : $erreur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // CONSULTATION DES DÉTAILS
  // =====================================================

  Future<void> _ouvrirDetails(Tache tache) async {
    final resultat = await context.push<bool>(
      '/echeances/${tache.id}',
    );

    if (!mounted) return;

    if (resultat == true) {
      await ref.read(tachesProvider.notifier)
          .marquerCommeTerminee(tache.id, true);
    }
  }

  // =====================================================
  // INTERFACE PRINCIPALE
  // =====================================================

  @override
  Widget build(BuildContext context) {
    final tachesAsync = switch (filtreActuel) {
      'À faire' => ref.watch(tachesAFaireProvider),
      'Faites' => ref.watch(tachesFaitesProvider),
      'En retard' => ref.watch(tachesEnRetardProvider),
      _ => ref.watch(tachesProvider),
    };

    return Scaffold(
      backgroundColor: couleurFond,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: couleurPrincipale,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: const Text(
          'Mes échéances',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: const Color(0xFFEAF0FA),
              child: Icon(
                Icons.person,
                color: couleurPrincipale,
              ),
            ),
          ),
        ],
      ),

      body: tachesAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: couleurPrincipale,
          ),
        ),

        error: (erreur, trace) => Center(
          child: Text('Erreur de chargement : $erreur'),
        ),

        data: (taches) {
          final recherche = _rechercheController.text.toLowerCase().trim();

          final tachesAffichees = taches.where((tache) {
            return tache.titre.toLowerCase().contains(recherche);
          }).toList();

          return LayoutBuilder(
            builder: (context, contraintes) {
              final estTablette = contraintes.maxWidth >= 840;

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: estTablette ? 900 : double.infinity,
                  ),
                  child: _contenuPrincipal(
                    tachesAffichees,
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: tachesAsync.isLoading ? null : _ajouterTache,
        backgroundColor: couleurPrincipale,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter une échéance'),
      ),
    );
  }

  // =====================================================
  // CONTENU DE LA PAGE
  // =====================================================

  Widget _contenuPrincipal(List<Tache> tachesFiltrees) {
    return ListView(
      padding: const EdgeInsets.all(20),

      children: [
        const Text(
          'Mes activités universitaires',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173B70),
          ),
        ),

        const SizedBox(height: 7),

        const Text(
          'Consultez, recherchez et gérez toutes vos échéances.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF777777),
          ),
        ),

        const SizedBox(height: 25),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Liste des échéances',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173B70),
              ),
            ),

            Text(
              '${tachesFiltrees.length} résultat(s)',
              style: const TextStyle(
                color: Color(0xFF777777),
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // RECHERCHE
        TextField(
          controller: _rechercheController,
          onChanged: (value) => setState(() {}),

          decoration: InputDecoration(
            hintText: 'Rechercher une échéance...',
            prefixIcon: const Icon(Icons.search),

            suffixIcon: _rechercheController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _rechercheController.clear();
                setState(() {});
              },
            )
                : null,

            filled: true,
            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 15),

        // FILTRES
        Wrap(
          spacing: 8,
          runSpacing: 8,

          children: [
            'Toutes',
            'À faire',
            'Faites',
            'En retard',
          ].map((filtre) {
            final selectionne = filtreActuel == filtre;

            return ChoiceChip(
              label: Text(filtre),
              selected: selectionne,
              selectedColor: const Color(0xFFDCE7F7),

              labelStyle: TextStyle(
                color: selectionne
                    ? couleurPrincipale
                    : Colors.black87,
                fontWeight: selectionne
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),

              onSelected: (selected) {
                setState(() {
                  filtreActuel = filtre;
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 18),

        // LISTE DES TÂCHES
        if (tachesFiltrees.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 45,
                  color: Colors.grey,
                ),

                SizedBox(height: 12),

                Text(
                  'Aucune échéance trouvée.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          ...tachesFiltrees.map(
                (tache) => _tacheCard(tache),
          ),

        const SizedBox(height: 80),
      ],
    );
  }

  // =====================================================
  // CARTE D'UNE TÂCHE
  // =====================================================

  Widget _tacheCard(Tache tache) {
    final bool terminee = tache.terminee;
    final bool retard = _estEnRetard(tache);

    final Color couleurStatut = terminee
        ? Colors.green
        : retard
        ? Colors.red
        : Colors.orange;

    final String texteStatut = terminee
        ? 'Faite'
        : retard
        ? 'En retard'
        : 'À faire';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE9EDF3),
        ),
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.all(14),

        leading: Container(
          width: 48,
          height: 48,

          decoration: BoxDecoration(
            color: const Color(0xFFEAF0FA),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Icon(
            _iconeDepuisNom(tache.icone),
            color: couleurPrincipale,
          ),
        ),

        title: Text(
          tache.titre,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF263238),
          ),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 13,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      tache.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),

                decoration: BoxDecoration(
                  color: couleurStatut.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Text(
                  texteStatut,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: couleurStatut,
                  ),
                ),
              ),
            ],
          ),
        ),

        // MENU DES ACTIONS
        trailing: PopupMenuButton<String>(
          tooltip: 'Actions',

          onSelected: (action) {
            if (action == 'modifier') {
              _modifierTache(tache);
            } else if (action == 'supprimer') {
              _supprimerTache(tache);
            }
          },

          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'modifier',
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Color(0xFF173B70),
                  ),
                  SizedBox(width: 10),
                  Text('Modifier'),
                ],
              ),
            ),

            PopupMenuItem(
              value: 'supprimer',
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  SizedBox(width: 10),
                  Text('Supprimer'),
                ],
              ),
            ),
          ],
        ),

        onTap: () => _ouvrirDetails(tache),
      ),
    );
  }
}
