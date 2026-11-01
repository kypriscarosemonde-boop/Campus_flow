
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
  // Liste initiale des échéances
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

  // Couleurs de l'application
  final Color couleurPrincipale = const Color(0xFF173B70);
  final Color couleurFond = const Color(0xFFF4F6FA);

  @override
  void initState() {
    super.initState();
    _chargerEcheances();
  }

  // Convertir le nom d'une icône en icône Flutter
  IconData _iconeDepuisNom(dynamic nom) {
    if (nom is IconData) {
      return nom;
    }

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
        return Icons.event_note;
      default:
        return Icons.event_note;
    }
  }

  // Convertir une icône Flutter en texte
  String _nomDepuisIcone(dynamic icone) {
    if (icone is String) {
      return icone;
    }

    if (icone == Icons.calendar_month) {
      return 'calendar_month';
    }

    if (icone == Icons.assignment) {
      return 'assignment';
    }

    if (icone == Icons.menu_book) {
      return 'menu_book';
    }

    if (icone == Icons.people_alt) {
      return 'people_alt';
    }

    if (icone == Icons.code) {
      return 'code';
    }

    return 'event_note';
  }

  // Sauvegarder les échéances
  Future<void> _sauvegarderEcheances() async {
    final preferences = await SharedPreferences.getInstance();

    final listeCompatible = echeances.map((echeance) {
      return {
        ...echeance,
        'icone': _nomDepuisIcone(echeance['icone']),
      };
    }).toList();

    final donnees = jsonEncode(listeCompatible);

    await preferences.setString('mes_echeances', donnees);
  }

  // Charger les échéances sauvegardées
  Future<void> _chargerEcheances() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final donnees = preferences.getString('mes_echeances');

      if (donnees != null) {
        final List<dynamic> liste = jsonDecode(donnees);

        final listeChargee = liste.map((element) {
          final Map<String, dynamic> nouvelle =
          Map<String, dynamic>.from(element);

          nouvelle['icone'] =
              _nomDepuisIcone(nouvelle['icone']);

          nouvelle['terminee'] =
              nouvelle['terminee'] == true;

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

  // Ajouter une nouvelle échéance
  Future<void> _ajouterEcheance() async {
    final nouvelleEcheance = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EcheanceFormPage(),
      ),
    );

    if (!mounted || nouvelleEcheance == null) {
      return;
    }

    try {
      final Map<String, dynamic> nouvelle =
      Map<String, dynamic>.from(nouvelleEcheance);

      nouvelle['icone'] =
          _nomDepuisIcone(nouvelle['icone']);

      nouvelle['terminee'] =
          nouvelle['terminee'] == true;

      setState(() {
        echeances.add(nouvelle);
      });

      await _sauvegarderEcheances();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nouvelle échéance ajoutée et sauvegardée !',
          ),
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

  // Ouvrir les détails d'une échéance
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

  // Marquer une échéance comme terminée
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

  @override
  Widget build(BuildContext context) {
    final int total = echeances.length;

    final int terminees =
        echeances.where((e) => e['terminee'] == true).length;

    final int restantes = total - terminees;

    return Scaffold(
      backgroundColor: couleurFond,

      // Barre supérieure
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: couleurPrincipale,
        elevation: 0,
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

      // Adaptation téléphone et tablette
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
              child: _contenuPrincipal(
                total,
                terminees,
                restantes,
              ),
            ),
          );
        },
      ),



      // Navigation inférieure
      bottomNavigationBar: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE9EDF3)),
          ),
        ),
        child: Row(
          children: [
            // Échéances
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

            // Terminées
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

            // Bouton Ajouter une échéance
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: chargementTermine ? _ajouterEcheance : null,
                  icon: const Icon(Icons.add, size: 25),
                  label: const Text(
                    'Ajouter une échéance',
                    style: TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: couleurPrincipale,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
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
  // Contenu principal
  Widget _contenuPrincipal(
      int total,
      int terminees,
      int restantes,
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

        // Statistiques
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

            const SizedBox(width: 10),

            Expanded(
              child: _statCard(
                'Terminées',
                terminees.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),

            const SizedBox(width: 10),

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

        const SizedBox(height: 28),

        // Titre de la liste
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
              '$total activités',
              style: const TextStyle(
                color: Color(0xFF777777),
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // Liste des échéances
        ...echeances.map((echeance) {
          return _echeanceCard(echeance);
        }),
      ],
    );
  }

  // Carte statistique
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

  // Carte d'une échéance
  Widget _echeanceCard(
      Map<String, dynamic> echeance,
      ) {
    final bool terminee = echeance['terminee'] == true;

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
                  color: terminee
                      ? const Color(0xFFE5F5EA)
                      : const Color(0xFFFFF1DC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  terminee ? 'Terminée' : 'À faire',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: terminee
                        ? Colors.green.shade700
                        : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF9E9E9E),
        ),

        // Ouvrir les détails au clic
        onTap: () => _ouvrirDetails(echeance),
      ),
    );
  }
}
