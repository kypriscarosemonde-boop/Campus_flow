
import 'package:flutter/material.dart';
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

  // Identifiants de connexion
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
          builder: (context) => const EcheancesPage(),
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
