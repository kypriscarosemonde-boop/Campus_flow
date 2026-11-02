
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

  // Convertir le nom d'une icône en icône Flutter.
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

  // Convertir une date en DateTime.
  DateTime? _convertirDate(dynamic valeur) {
    if (valeur == null) return null;

    final texte = valeur.toString().trim();

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

  // Sauvegarder les échéances.
  Future<void> _sauvegarderEcheances() async {
    final preferences = await SharedPreferences.getInstance();

    final donnees = jsonEncode(echeances);

    await preferences.setString('mes_echeances', donnees);
  }

  // Charger les échéances sauvegardées.
  Future<void> _chargerEcheances() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final donnees = preferences.getString('mes_echeances');

      if (donnees != null) {
        final List<dynamic> liste = jsonDecode(donnees);

        final listeChargee = liste.map((element) {
          final Map<String, dynamic> nouvelle =
          Map<String, dynamic>.from(element);

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

  // Ajouter une échéance.
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

  // Modifier une échéance.
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

  // Supprimer une échéance après confirmation.
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

  // Ouvrir les détails d'une échéance.
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

  // Marquer une échéance comme terminée.
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

  // Calculer les échéances visibles selon la recherche et le filtre.
  List<Map<String, dynamic>> get echeancesFiltrees {
    final recherche = _rechercheController.text.toLowerCase().trim();

    return echeances.where((echeance) {
      final titre = echeance['titre'].toString().toLowerCase();

      final correspondRecherche =
      titre.contains(recherche);

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

  @override
  Widget build(BuildContext context) {
    final int total = echeances.length;

    final int terminees =
        echeances.where((e) => e['terminee'] == true).length;

    final int restantes = total - terminees;

    final int enRetard =
        echeances.where(_estEnRetard).length;

    final double progression =
    total == 0 ? 0 : terminees / total;

    return Scaffold(
      backgroundColor: couleurFond,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: couleurPrincipale,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Retour à l’accueil',
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'CampusFlow',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Color(0xFFEAF0FA),
              child: Icon(
                Icons.person,
                color: Color(0xFF173B70),
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
                maxWidth:
                estTablette ? 900 : double.infinity,
              ),
              child: _contenuPrincipal(
                total,
                terminees,
                restantes,
                enRetard,
                progression,
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE9EDF3)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.event_note,
                    color: Color(0xFF173B70),
                    size: 26,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Échéances',
                    style: TextStyle(
                      color: Color(0xFF173B70),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF454B55),
                    size: 26,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Terminées',
                    style: TextStyle(
                      color: Color(0xFF454B55),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: chargementTermine
                      ? _ajouterEcheance
                      : null,
                  icon: const Icon(Icons.add, size: 25),
                  label: const Text(
                    'Ajouter une échéance',
                    style: TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: couleurPrincipale,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Contenu principal.
  Widget _contenuPrincipal(
      int total,
      int terminees,
      int restantes,
      int enRetard,
      double progression,
      ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Bonjour 👋',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173B70),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Voici le suivi de vos activités universitaires.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF777777),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Vue d’ensemble',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173B70),
          ),
        ),

        const SizedBox(height: 14),

        // Statistiques principales.
        Row(
          children: [
            Expanded(
              child: _statCard(
                'Total',
                total.toString(),
                Icons.event_note,
                couleurPrincipale,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: _statCard(
                'Terminées',
                terminees.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: _statCard(
                'À faire',
                restantes.toString(),
                Icons.pending_actions,
                Colors.orange,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Statistique des retards.
        _statCard(
          'En retard',
          enRetard.toString(),
          Icons.warning_amber_rounded,
          Colors.red,
        ),

        const SizedBox(height: 20),

        // Progression générale.
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE9EDF3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progression générale',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF173B70),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Échéances terminées',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${(progression * 100).round()} %',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progression,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE9EDF3),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),

        // Titre de la liste.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mes échéances',
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

        const SizedBox(height: 14),

        // Barre de recherche.
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

        const SizedBox(height: 14),

        // Filtres.
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

        const SizedBox(height: 16),

        // Liste filtrée.
        if (echeancesFiltrees.isEmpty)
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.search_off,
                  size: 40,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'Aucune échéance trouvée.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        else
          ...echeancesFiltrees.map(
                (echeance) => _echeanceCard(echeance),
          ),
      ],
    );
  }

  // Carte statistique.
  Widget _statCard(
      String titre,
      String valeur,
      IconData icone,
      Color couleur,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE9EDF3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icone,
            color: couleur,
            size: 25,
          ),

          const SizedBox(height: 10),

          Text(
            valeur,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: couleur,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            titre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }

  // Carte d'une échéance.
  Widget _echeanceCard(
      Map<String, dynamic> echeance,
      ) {
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
                  Icon(Icons.edit, color: Color(0xFF173B70)),
                  SizedBox(width: 10),
                  Text('Modifier'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'supprimer',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
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
