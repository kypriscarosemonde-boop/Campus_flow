
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'echeance_detail_page.dart';
import 'echeance_form_page.dart';

class EcheancesPage extends StatefulWidget {
  const EcheancesPage({super.key});

  @override
  State<EcheancesPage> createState() => _EcheancesPageState();
}

class _EcheancesPageState extends State<EcheancesPage> {
  List<Map<String, dynamic>> echeances = [
    {
      'titre': 'Consulter emploi du temps',
      'date': '01 novembre 2026',
      'terminee': true,
      'icone': 'calendar_month',
    },
    {
      'titre': 'Soumission des devoirs',
      'date': '20 novembre 2026',
      'terminee': false,
      'icone': 'assignment',
    },
    {
      'titre': 'Récupération des supports de cours',
      'date': '25 octobre 2026',
      'terminee': true,
      'icone': 'menu_book',
    },
    {
      'titre': 'Suivi des présences',
      'date': '01 octobre 2026',
      'terminee': false,
      'icone': 'people_alt',
    },
    {
      'titre': 'Projet Flutter',
      'date': '15 novembre 2026',
      'terminee': false,
      'icone': 'code',
    },
  ];

  bool chargementTermine = false;

  final TextEditingController _rechercheController =
  TextEditingController();

  String filtreActuel = 'Toutes';

  final Color couleurPrincipale = const Color(0xFF173B70);
  final Color couleurFond = const Color(0xFFF4F6FA);

  @override
  void initState() {
    super.initState();
    _chargerEcheances();
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  // =====================================================
  // GESTION DES ICÔNES
  // =====================================================

  IconData _iconeDepuisNom(dynamic nom) {
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
      case 'event_note':
      default:
        return Icons.event_note;
    }
  }

  // =====================================================
  // GESTION DES DATES
  // =====================================================

  DateTime? _convertirDate(dynamic valeur) {
    if (valeur == null) return null;

    final texte = valeur.toString().trim();

    // Format : 01/11/2026
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

    // Format : 01 novembre 2026
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

  // Vérifier si une échéance est en retard.
  bool _estEnRetard(Map<String, dynamic> echeance) {
    if (echeance['terminee'] == true) return false;

    final date = _convertirDate(echeance['date']);

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
  // SAUVEGARDE ET CHARGEMENT
  // =====================================================

  Future<void> _sauvegarderEcheances() async {
    final preferences = await SharedPreferences.getInstance();

    final donnees = jsonEncode(echeances);

    await preferences.setString('mes_echeances', donnees);
  }

  Future<void> _chargerEcheances() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final donnees = preferences.getString('mes_echeances');

      if (donnees != null) {
        final List<dynamic> liste = jsonDecode(donnees);

        final listeChargee = liste.map((element) {
          final nouvelle = Map<String, dynamic>.from(element);

          nouvelle['terminee'] = nouvelle['terminee'] == true;

          return nouvelle;
        }).toList();

        if (!mounted) return;

        setState(() {
          echeances = listeChargee;
          chargementTermine = true;
        });
      } else {
        await _sauvegarderEcheances();

        if (!mounted) return;

        setState(() {
          chargementTermine = true;
        });
      }
    } catch (erreur) {
      if (!mounted) return;

      setState(() {
        chargementTermine = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement : $erreur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // AJOUT D'UNE ÉCHÉANCE
  // =====================================================

  Future<void> _ajouterEcheance() async {
    final nouvelleEcheance = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EcheanceFormPage(),
      ),
    );

    if (!mounted || nouvelleEcheance == null) return;

    try {
      final Map<String, dynamic> nouvelle =
      Map<String, dynamic>.from(nouvelleEcheance);

      nouvelle['terminee'] = nouvelle['terminee'] == true;

      setState(() {
        echeances.add(nouvelle);
      });

      await _sauvegarderEcheances();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nouvelle échéance ajoutée et sauvegardée !'),
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
  // MODIFICATION D'UNE ÉCHÉANCE
  // =====================================================

  Future<void> _modifierEcheance(
      Map<String, dynamic> echeance,
      ) async {
    final index = echeances.indexOf(echeance);

    if (index == -1) return;

    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EcheanceFormPage(
          echeance: Map<String, dynamic>.from(echeance),
        ),
      ),
    );

    if (!mounted || resultat == null) return;

    try {
      final Map<String, dynamic> modifiee =
      Map<String, dynamic>.from(resultat);

      setState(() {
        echeances[index] = modifiee;
      });

      await _sauvegarderEcheances();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échéance modifiée avec succès !'),
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
  // SUPPRESSION D'UNE ÉCHÉANCE
  // =====================================================

  Future<void> _supprimerEcheance(
      Map<String, dynamic> echeance,
      ) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer cette échéance ?'),
          content: Text(
            'Voulez-vous vraiment supprimer "${echeance['titre']}" ?',
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

    final index = echeances.indexOf(echeance);

    if (index == -1) return;

    final echeanceSupprimee = echeances[index];

    setState(() {
      echeances.removeAt(index);
    });

    try {
      await _sauvegarderEcheances();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échéance supprimée avec succès !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (erreur) {
      if (!mounted) return;

      setState(() {
        echeances.insert(index, echeanceSupprimee);
      });

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

  Future<void> _ouvrirDetails(
      Map<String, dynamic> echeance,
      ) async {
    final resultat = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EcheanceDetailPage(
          titre: echeance['titre'].toString(),
          date: echeance['date'].toString(),
          terminee: echeance['terminee'] == true,
        ),
      ),
    );

    if (!mounted) return;

    if (resultat == true) {
      await _marquerCommeTerminee(echeance);
    }
  }

  // =====================================================
  // MARQUER UNE ÉCHÉANCE COMME TERMINÉE
  // =====================================================

  Future<void> _marquerCommeTerminee(
      Map<String, dynamic> echeance,
      ) async {
    if (echeance['terminee'] == true) return;

    setState(() {
      echeance['terminee'] = true;
    });

    try {
      await _sauvegarderEcheances();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Échéance marquée comme terminée !'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (erreur) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sauvegarde : $erreur'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================
  // RECHERCHE ET FILTRAGE
  // =====================================================

  List<Map<String, dynamic>> get echeancesFiltrees {
    final recherche = _rechercheController.text.toLowerCase().trim();

    return echeances.where((echeance) {
      final titre = echeance['titre'].toString().toLowerCase();

      final correspondRecherche = titre.contains(recherche);

      bool correspondFiltre = true;

      switch (filtreActuel) {
        case 'À faire':
          correspondFiltre = echeance['terminee'] != true;
          break;

        case 'Terminées':
          correspondFiltre = echeance['terminee'] == true;
          break;

        case 'En retard':
          correspondFiltre = _estEnRetard(echeance);
          break;

        case 'Toutes':
        default:
          correspondFiltre = true;
      }

      return correspondRecherche && correspondFiltre;
    }).toList();
  }

  // =====================================================
  // INTERFACE PRINCIPALE
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: couleurFond,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: couleurPrincipale,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Retour à la vue d'ensemble",
          onPressed: () {
            Navigator.pop(context);
          },
        ),

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

      body: !chargementTermine
          ? Center(
        child: CircularProgressIndicator(
          color: couleurPrincipale,
        ),
      )
          : LayoutBuilder(
        builder: (context, contraintes) {
          final bool estTablette =
              contraintes.maxWidth >= 840;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: estTablette ? 900 : double.infinity,
              ),
              child: _contenuPrincipal(),
            ),
          );
        },
      ),

      // Bouton d'ajout en bas de page
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xFFE9EDF3),
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: chargementTermine
                  ? _ajouterEcheance
                  : null,
              icon: const Icon(Icons.add, size: 24),
              label: const Text(
                'Ajouter une échéance',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: couleurPrincipale,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================
  // CONTENU DE LA PAGE MES ÉCHÉANCES
  // =====================================================

  Widget _contenuPrincipal() {
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

        // Nombre de résultats
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
              '${echeancesFiltrees.length} résultat(s)',
              style: const TextStyle(
                color: Color(0xFF777777),
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // Barre de recherche
        TextField(
          controller: _rechercheController,
          onChanged: (value) {
            setState(() {});
          },
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

        // Filtres
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Toutes',
            'À faire',
            'Terminées',
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

        // Liste des échéances
        if (echeancesFiltrees.isEmpty)
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
          ...echeancesFiltrees.map(
                (echeance) => _echeanceCard(echeance),
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  // =====================================================
  // CARTE D'UNE ÉCHÉANCE
  // =====================================================

  Widget _echeanceCard(Map<String, dynamic> echeance) {
    final bool terminee = echeance['terminee'] == true;
    final bool retard = _estEnRetard(echeance);

    final Color couleurStatut = terminee
        ? Colors.green
        : retard
        ? Colors.red
        : Colors.orange;

    final String texteStatut = terminee
        ? 'Terminée'
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
            _iconeDepuisNom(echeance['icone']),
            color: couleurPrincipale,
          ),
        ),

        title: Text(
          echeance['titre'].toString(),
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
                      echeance['date'].toString(),
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
                  color: couleurStatut.withOpacity(0.12),
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

        // Menu de modification et de suppression
        trailing: PopupMenuButton<String>(
          tooltip: 'Actions',
          onSelected: (action) {
            if (action == 'modifier') {
              _modifierEcheance(echeance);
            } else if (action == 'supprimer') {
              _supprimerEcheance(echeance);
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

        onTap: () => _ouvrirDetails(echeance),
      ),
    );
  }
}
