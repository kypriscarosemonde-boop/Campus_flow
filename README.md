# CampusFlow – Gestion des échéances universitaires

## 1. Présentation

**CampusFlow** est une application développée avec Flutter et Dart pour faciliter l'organisation et le suivi des activités universitaires.

Elle permet de créer, modifier, supprimer et consulter des échéances, de suivre leur état d'avancement et de visualiser des statistiques à travers un tableau de bord.

## 2. Fonctionnalités principales

- **Authentification :** accès à l'application par une page de connexion.
- **Gestion des échéances :** ajout, modification, consultation et suppression.
- **Gestion des statuts :** échéances à faire, terminées ou en retard.
- **Recherche :** recherche d'une échéance par son titre.
- **Filtrage :** affichage selon le statut des échéances.
- **Tableau de bord :** statistiques sur les échéances et suivi de la progression.
- **Sauvegarde locale :** conservation des données avec SharedPreferences.
- **Interface adaptative :** utilisation sur différents formats d'écran.

## 3. Technologies utilisées

| Technologie | Utilisation |
|---|---|
| Flutter | Développement de l'interface |
| Dart | Langage de programmation |
| Material Design | Composants graphiques |
| Riverpod | Gestion de l'état |
| GoRouter | Navigation entre les pages |
| SharedPreferences | Stockage local |
| JSON | Format de sauvegarde des données |
| Git et GitHub | Gestion des versions et hébergement du code |

## 4. Structure du projet

```text
campus_flow/
│
├── assets/
│   └── images/
│       └── logo.png
│
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── tache.dart
│   ├── providers/
│   │   └── tache_provider.dart
│   └── pages/
│       ├── echeances_page.dart
│       ├── echeance_detail_page.dart
│       └── echeance_form_page.dart
│
├── test/
├── web/
├── android/
├── ios/
├── pubspec.yaml
└── README.md
```

### Rôle des principaux fichiers

- `main.dart` : point d'entrée, configuration du thème et navigation.
- `models/tache.dart` : définition du modèle de données d'une échéance.
- `providers/tache_provider.dart` : gestion des échéances et sauvegarde locale.
- `pages/echeances_page.dart` : affichage et gestion de la liste.
- `pages/echeance_detail_page.dart` : consultation des détails.
- `pages/echeance_form_page.dart` : création et modification.
- `assets/images/logo.png` : logo de l'application.

## 5. Installation

### Prérequis

- Flutter SDK et Dart ;
- Visual Studio Code ou Android Studio ;
- Google Chrome pour la version Web ;
- Git.

### Récupération du projet

```bash
git clone https://github.com/kypriscarosemonde-boop/Campus_flow.git
cd Campus_flow
```

### Installation des dépendances

```bash
flutter pub get
```

## 6. Lancement de l'application

Vérifier la configuration de Flutter :

```bash
flutter doctor
```

Afficher les appareils disponibles :

```bash
flutter devices
```

Lancer CampusFlow sur Google Chrome :

```bash
flutter run -d chrome --web-port=5000
```

L'application est accessible à l'adresse :

```text
http://localhost:5000
```

Le port `5000` permet de fixer l'adresse locale utilisée pendant le développement. Il peut être remplacé par un autre port disponible si nécessaire.

## 7. Identifiants de démonstration

| Informations | Valeurs |
|---|---|
| Adresse e-mail | admin@campusflow.com |
| Mot de passe | CampusFlow2026 |

**Remarque :** ces identifiants sont définis directement dans le code. L'authentification actuelle est destinée à la démonstration et n'est pas adaptée à une utilisation en production.

## 8. Tests

Pour exécuter les tests automatisés :

```bash
flutter test
```

Pour vérifier le code et détecter les éventuelles erreurs :

```bash
flutter analyze
```

## 9. Stockage des données

CampusFlow utilise **SharedPreferences** pour enregistrer les échéances localement au format JSON.

Les données sont conservées après la fermeture et la réouverture de l'application. Elles ne sont toutefois pas synchronisées entre plusieurs appareils.

## 10. Perspectives d'amélioration

- Intégration d'une base de données distante ;
- Authentification sécurisée et gestion de plusieurs utilisateurs ;
- Notifications et rappels des échéances ;
- Classement par matière ou catégorie ;
- Intégration d'un calendrier universitaire ;
- Synchronisation entre plusieurs appareils.



## 11. Dépôt GitHub

Le code source du projet est disponible sur GitHub :

**Lien du dépôt :** https://github.com/kypriscarosemonde-boop/Campus_flow

