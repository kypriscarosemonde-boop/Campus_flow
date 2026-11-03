
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/tache_provider.dart';
import 'pages/echeances_page.dart';
import 'pages/echeance_detail_page.dart';

// =====================================================
// ROUTES GO ROUTER
// =====================================================

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),

        GoRoute(
          path: '/echeances',
          builder: (context, state) => const EcheancesPage(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return EcheanceDetailPage(id: id);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

// =====================================================
// DEMARRAGE DE L'APPLICATION
// =====================================================

void main() {
  runApp(
    const ProviderScope(
      child: CampusFlowApp(),
    ),
  );
}

class CampusFlowApp extends StatelessWidget {
  const CampusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CampusFlow',
      routerConfig: appRouter,
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
    );
  }
}

// =====================================================
// SHELL PRINCIPAL : NAVIGATION BAR
// =====================================================

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final emplacement = GoRouterState.of(context).uri.path;

    final int indexSelectionne =
    emplacement.startsWith('/echeances') ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: indexSelectionne,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCE7F7),
        onDestinationSelected: (index) {
          if (index == 0) {
            context.go('/dashboard');
          } else {
            context.go('/echeances');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: "Vue d'ensemble",
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Échéances',
          ),
        ],
      ),
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

  void _seConnecter() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = emailController.text.trim();
    final motDePasse = passwordController.text;

    if (email == emailAutorise &&
        motDePasse == motDePasseAutorise) {
      context.go('/dashboard');
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
                            backgroundColor:
                            const Color(0xFF173B70),
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

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  DateTime? _convertirDate(String date) {
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

  // ===================================================
  // CARTE STATISTIQUE
  // ===================================================

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
            color: Colors.black.withValues(alpha: 0.05),
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
              color: couleur.withValues(alpha: 0.12),
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

  // ===================================================
  // CARTE PROGRESSION GENERALE AMELIOREE
  // ===================================================

  Widget _construireCarteProgression({
    required int total,
    required int terminees,
    required int aFaire,
    required double progression,
  }) {
    final pourcentage = (progression * 100).round();

    final Color couleurProgression;

    if (pourcentage >= 75) {
      couleurProgression = const Color(0xFF16A36A);
    } else if (pourcentage >= 40) {
      couleurProgression = const Color(0xFF2F80ED);
    } else {
      couleurProgression = const Color(0xFFFF9800);
    }

    final String message;
    final String sousMessage;
    final IconData iconeMessage;

    if (total == 0) {
      message = 'Aucune activité enregistrée';
      sousMessage = 'Ajoutez une échéance pour commencer votre suivi.';
      iconeMessage = Icons.event_note_outlined;
    } else if (pourcentage == 100) {
      message = 'Félicitations !';
      sousMessage = 'Toutes vos échéances sont terminées.';
      iconeMessage = Icons.emoji_events_outlined;
    } else if (pourcentage >= 75) {
      message = 'Excellent travail !';
      sousMessage = 'Vous êtes presque au bout de vos objectifs.';
      iconeMessage = Icons.rocket_launch_outlined;
    } else if (pourcentage >= 40) {
      message = 'Bonne progression !';
      sousMessage = 'Continuez ainsi, vous avancez bien.';
      iconeMessage = Icons.trending_up;
    } else {
      message = 'Chaque effort compte !';
      sousMessage = 'Continuez à avancer étape par étape.';
      iconeMessage = Icons.flag_outlined;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITRE
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights_outlined,
                  color: Color(0xFF173B70),
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Progression générale',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF173B70),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Suivez votre avancement dans la réalisation de vos activités.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 28),

          // CERCLE ET INFORMATIONS
          LayoutBuilder(
            builder: (context, contraintes) {
              final petitEcran = contraintes.maxWidth < 400;

              final cercle = SizedBox(
                width: 145,
                height: 145,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: progression,
                        ),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutCubic,
                        builder: (context, valeur, child) {
                          return CircularProgressIndicator(
                            value: valeur,
                            strokeWidth: 11,
                            strokeCap: StrokeCap.round,
                            backgroundColor:
                            const Color(0xFFE8EDF5),
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                              couleurProgression,
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$pourcentage%',
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.bold,
                            color: couleurProgression,
                          ),
                        ),
                        const Text(
                          'Complété',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              final informations = Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      iconeMessage,
                      color: couleurProgression,
                      size: 27,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF173B70),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      sousMessage,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              );

              if (petitEcran) {
                return Column(
                  children: [
                    cercle,
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: informations,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  cercle,
                  const SizedBox(width: 25),
                  informations,
                ],
              );
            },
          ),

          const SizedBox(height: 28),

          // BARRE DE PROGRESSION
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Avancement global',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '$pourcentage %',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: couleurProgression,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TweenAnimationBuilder<double>(
              tween: Tween(
                begin: 0,
                end: progression,
              ),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, valeur, child) {
                return LinearProgressIndicator(
                  value: valeur,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE8EDF5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    couleurProgression,
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 22),

          // DETAILS DES TACHES
          Row(
            children: [
              Expanded(
                child: _construireIndicateur(
                  couleur: const Color(0xFF16A36A),
                  titre: 'Terminées',
                  valeur: terminees,
                  icone: Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _construireIndicateur(
                  couleur: const Color(0xFFFF9800),
                  titre: 'Restantes',
                  valeur: aFaire,
                  icone: Icons.pending_actions,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _construireIndicateur(
                  couleur: const Color(0xFF2F80ED),
                  titre: 'Total',
                  valeur: total,
                  icone: Icons.calendar_month_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================================================
  // PETIT INDICATEUR DE STATISTIQUE
  // ===================================================

  Widget _construireIndicateur({
    required Color couleur,
    required String titre,
    required int valeur,
    required IconData icone,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icone,
            color: couleur,
            size: 20,
          ),
          const SizedBox(height: 7),
          Text(
            valeur.toString(),
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: couleur,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            titre,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // ===================================================
  // CONSTRUCTION DU TABLEAU DE BORD
  // ===================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tachesAsync = ref.watch(tachesProvider);

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
              context.go('/');
            },
          ),
        ],
      ),

      body: tachesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (erreur, trace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Erreur de chargement des échéances : $erreur',
              textAlign: TextAlign.center,
            ),
          ),
        ),

        data: (taches) {
          final total = taches.length;

          final terminees = taches
              .where((tache) => tache.terminee)
              .length;

          final aFaire = total - terminees;

          final aujourdHui =
          DateUtils.dateOnly(DateTime.now());

          final enRetard = taches.where((tache) {
            if (tache.terminee) return false;

            final date = _convertirDate(tache.date);

            return date != null &&
                DateUtils.dateOnly(date)
                    .isBefore(aujourdHui);
          }).length;

          final progression =
          total == 0 ? 0.0 : terminees / total;

          return RefreshIndicator(
            onRefresh: () {
              return ref
                  .refresh(tachesProvider.future)
                  .then((_) {});
            },

            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),

              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 900,
                  ),

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

                      // CARTES STATISTIQUES
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

                      // PROGRESSION GENERALE AMELIOREE
                      _construireCarteProgression(
                        total: total,
                        terminees: terminees,
                        aFaire: aFaire,
                        progression: progression,
                      ),

                      const SizedBox(height: 30),

                      // BOUTON MES ECHEANCES
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/echeances');
                          },
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
          );
        },
      ),
    );
  }
}
