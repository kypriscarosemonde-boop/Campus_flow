
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/echeances_page.dart';

void main() {
  runApp(const CampusFlowApp());
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusFlow',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF4F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF173B70),
          primary: const Color(0xFF173B70),
          secondary: const Color(0xFF2F80ED),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF173B70),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF173B70),
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================
// PAGE DE CONNEXION
// =====================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool masquerMotDePasse = true;

  final String emailAutorise = 'admin@campusflow.com';
  final String motDePasseAutorise = 'CampusFlow2026';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Vérification des identifiants
  void _seConnecter() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final motDePasse = passwordController.text;

    if (email == emailAutorise &&
        motDePasse == motDePasseAutorise) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Adresse e-mail ou mot de passe incorrect.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CampusFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              elevation: 3,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        'Bienvenue sur CampusFlow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF173B70),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Votre espace universitaire intelligent',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Adresse e-mail
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Adresse e-mail',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre adresse e-mail',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Veuillez saisir votre adresse e-mail';
                          }

                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(value.trim())) {
                            return 'Veuillez saisir une adresse e-mail valide';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      // Mot de passe
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mot de passe',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: passwordController,
                        obscureText: masquerMotDePasse,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre mot de passe',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              masquerMotDePasse
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                masquerMotDePasse =
                                !masquerMotDePasse;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir votre mot de passe';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Bouton de connexion
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _seConnecter,
                          icon: const Icon(Icons.login),
                          label: const Text(
                            'Connexion',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF173B70),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'CampusFlow - Gestion de la vie universitaire',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// PAGE VUE D'ENSEMBLE / TABLEAU DE BORD
// =====================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int total = 0;
  int terminees = 0;
  int aFaire = 0;
  int enRetard = 0;

  bool chargement = true;

  @override
  void initState() {
    super.initState();
    _chargerStatistiques();
  }

  // Conversion des dates en DateTime
  DateTime? _convertirDate(String date) {
    // Format dd/MM/yyyy
    final formatNumerique =
    RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$');

    final resultat = formatNumerique.firstMatch(date.trim());

    if (resultat != null) {
      return DateTime(
        int.parse(resultat.group(3)!),
        int.parse(resultat.group(2)!),
        int.parse(resultat.group(1)!),
      );
    }

    // Format avec les mois en français
    final mois = {
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

    final parties = date.toLowerCase().trim().split(
      RegExp(r'\s+'),
    );

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

    return DateTime.tryParse(date);
  }

  // Chargement des statistiques enregistrées
  Future<void> _chargerStatistiques() async {
    try {
      final preferences = await SharedPreferences.getInstance();

      final donnees = preferences.getString('mes_echeances');

      final List<dynamic> liste = donnees == null
          ? []
          : jsonDecode(donnees) as List<dynamic>;

      int nombreTerminees = 0;
      int nombreRetard = 0;

      final aujourdHui = DateUtils.dateOnly(DateTime.now());

      for (final element in liste) {
        final echeance = Map<String, dynamic>.from(element);

        final estTerminee = echeance['terminee'] == true;

        if (estTerminee) {
          nombreTerminees++;
        } else {
          final date = _convertirDate(
            echeance['date']?.toString() ?? '',
          );

          if (date != null &&
              DateUtils.dateOnly(date).isBefore(aujourdHui)) {
            nombreRetard++;
          }
        }
      }

      if (!mounted) return;

      setState(() {
        total = liste.length;
        terminees = nombreTerminees;
        aFaire = total - terminees;
        enRetard = nombreRetard;
        chargement = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        chargement = false;
      });
    }
  }

  double get progression {
    if (total == 0) return 0;
    return terminees / total;
  }

  // Accès à la page Mes échéances
  Future<void> _ouvrirMesEcheances() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EcheancesPage(),
      ),
    );

    // Actualiser les statistiques au retour
    _chargerStatistiques();
  }

  Widget _construireCarteStatistique({
    required String titre,
    required int valeur,
    required IconData icone,
    required Color couleur,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icone,
              color: couleur,
              size: 24,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            valeur.toString(),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173B70),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            titre,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vue d'ensemble",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: _chargerStatistiques,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  const Text(
                    'Bienvenue sur CampusFlow !',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B70),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Retrouvez ici un aperçu de vos activités universitaires.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Vue générale',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173B70),
                    ),
                  ),

                  const SizedBox(height: 15),

                  if (chargement)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, contraintes) {
                        final largeur = contraintes.maxWidth;

                        final nombreColonnes =
                        largeur >= 650 ? 4 : 2;

                        return GridView.count(
                          crossAxisCount: nombreColonnes,
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio:
                          nombreColonnes == 4 ? 1.15 : 1.25,
                          children: [
                            _construireCarteStatistique(
                              titre: 'Total des échéances',
                              valeur: total,
                              icone: Icons.calendar_month,
                              couleur: const Color(0xFF2F80ED),
                            ),
                            _construireCarteStatistique(
                              titre: 'Terminées',
                              valeur: terminees,
                              icone: Icons.check_circle_outline,
                              couleur: Colors.green,
                            ),
                            _construireCarteStatistique(
                              titre: 'À faire',
                              valeur: aFaire,
                              icone: Icons.pending_actions,
                              couleur: Colors.orange,
                            ),
                            _construireCarteStatistique(
                              titre: 'En retard',
                              valeur: enRetard,
                              icone: Icons.warning_amber,
                              couleur: Colors.red,
                            ),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: 30),

                  // Progression générale
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Progression générale',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF173B70),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Suivez votre avancement dans la réalisation de vos activités.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Avancement global',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(progression * 100).round()} %',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF173B70),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: progression,
                            minHeight: 12,
                            backgroundColor:
                            const Color(0xFFE5EAF2),
                            valueColor:
                            const AlwaysStoppedAnimation<Color>(
                              Colors.green,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          '$terminees échéance(s) terminée(s) sur $total.',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Bouton vers Mes échéances
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: _ouvrirMesEcheances,
                      icon: const Icon(Icons.calendar_month),
                      label: const Text(
                        'Mes échéances',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF173B70),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Center(
                    child: Text(
                      'CampusFlow - Gestion de la vie universitaire',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
