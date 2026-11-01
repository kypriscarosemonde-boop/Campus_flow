# CampusFlow – Application de gestion des échéances universitaires

## 1. Présentation du projet

**CampusFlow** est une application développée avec Flutter dans le but de faciliter le suivi des activités et des échéances universitaires.

Elle permet à l'utilisateur de consulter ses échéances, de suivre leur état d'avancement et d'ajouter de nouvelles activités.

L'application propose notamment :
- L'affichage de la liste des échéances universitaires.
- La consultation des détails d'une échéance.
- L'ajout de nouvelles échéances.
- La validation d'une échéance comme terminée.
- Le calcul du nombre total d'activités, des activités terminées et de celles qui restent à faire.
- La sauvegarde locale des échéances.
- Une interface adaptée aux téléphones et aux tablettes.

## 2. Technologies utilisées

| Technologie | Rôle |
|---|---|
| Flutter | Développement de l'interface de l'application |
| Dart | Langage de programmation |
| Material Design | Conception des composants graphiques |
| SharedPreferences | Sauvegarde locale des données |
| JSON | Organisation et sérialisation des données |

## 3. Arborescence du projet

Le projet est organisé de la manière suivante :

```text
campus_flow/
│
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
│
├── assets/
│   └── images/
│       └── logo.png
│
├── lib/
│   ├── main.dart
│   │
│   └── pages/
│       ├── echeances_page.dart
│       ├── echeance_detail_page.dart
│       └── echeance_form_page.dart
│
├── test/
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

### Description des principaux fichiers

**`lib/main.dart`**

C'est le point d'entrée de l'application. Il initialise Flutter, configure le thème général et affiche la page d'accueil CampusFlow.

**`lib/pages/echeances_page.dart`**

Cette page constitue l'interface principale de gestion des échéances. Elle affiche les statistiques, la liste des activités et permet d'ajouter une nouvelle échéance. Elle assure également la sauvegarde et le chargement des données.

**`lib/pages/echeance_detail_page.dart`**

Cette page présente les informations détaillées d'une échéance et permet de la marquer comme terminée.

**`lib/pages/echeance_form_page.dart`**

Cette page contient le formulaire de création d'une nouvelle échéance. Elle permet de saisir les informations nécessaires et de vérifier leur validité.

**`assets/images/logo.png`**

Contient le logo utilisé dans l'application.

**`pubspec.yaml`**

Ce fichier contient les informations générales du projet, les dépendances utilisées et la déclaration des ressources comme les images.

## 4. Installation et configuration

### Prérequis

Avant de lancer le projet, il faut disposer des éléments suivants :

- Flutter SDK installé.
- Dart installé (fourni avec Flutter).
- Visual Studio Code ou Android Studio.
- Google Chrome pour exécuter l'application en version Web.
- Une connexion Internet pour télécharger les dépendances lors de la première installation.

### Récupération du projet

Si le projet est déjà présent sur l'ordinateur, ouvrir un terminal dans son dossier.

Si le projet est récupéré depuis GitHub :

```bash
git clone https://github.com/kypriscarosemonde-boop/Campus_flow.git
```

Entrer ensuite dans le dossier :

```bash
cd Campus_flow
```

### Installation des dépendances

Exécuter la commande suivante :

```bash
flutter pub get
```

Cette commande permet de télécharger et d'installer les bibliothèques nécessaires au fonctionnement de l'application, notamment `shared_preferences`.

## 5. Lancement de l'application

### Vérifier l'installation de Flutter

```bash
flutter doctor
```

Cette commande vérifie l'installation de Flutter et signale les éventuels problèmes de configuration.

### Vérifier les appareils disponibles

```bash
flutter devices
```

Cette commande affiche les appareils et les navigateurs disponibles pour exécuter l'application.

### Lancer l'application sur Google Chrome

Exécuter les commandes suivantes :

```bash
cd C:\Users\user\AndroidStudioProjects\campus_flow
```

Puis :

```bash
flutter run -d chrome --web-port=5000
```

L'application sera compilée et ouverte dans Google Chrome.

## 6. Pourquoi préciser le port 5000 ?

Dans la commande :

```bash
flutter run -d chrome --web-port=5000
```

L'option `--web-port=5000` permet de définir le numéro du port utilisé par le serveur Web local de Flutter.

Un port est un numéro qui permet à un ordinateur de distinguer les différents services et applications qui communiquent sur le réseau.

Le port 5000 est utilisé ici pour accéder à CampusFlow avec une adresse locale fixe :

```text
http://localhost:5000
```

### Les avantages de préciser le port

- Utiliser toujours la même adresse pour accéder à l'application.
- Éviter que Flutter choisisse automatiquement un port différent à chaque lancement.
- Faciliter les tests et le débogage.
- Simplifier l'accès à l'application pendant le développement.

**Remarque :** le port 5000 n'est pas obligatoire. Flutter peut choisir automatiquement un port disponible si l'option `--web-port` n'est pas précisée.

Si le port 5000 est déjà utilisé par une autre application, il faut choisir un autre port disponible, par exemple :

```bash
flutter run -d chrome --web-port=5001
```

Dans ce cas, l'adresse devient :

```text
http://localhost:5001
```

## 7. Fonctionnement général de l'application

Le fonctionnement de CampusFlow repose sur plusieurs étapes :

1. L'utilisateur ouvre l'application et accède à la page d'accueil.
2. Il accède à la page principale des échéances.
3. Il consulte les statistiques et les activités enregistrées.
4. Il peut sélectionner une échéance pour consulter ses détails.
5. Il peut marquer une échéance comme terminée.
6. Il peut ajouter une nouvelle échéance à partir du formulaire.
7. Les informations sont enregistrées localement grâce à SharedPreferences.

## 8. Sauvegarde des données

L'application utilise le package `shared_preferences` pour conserver les échéances sur l'appareil.

Les données sont transformées en format JSON avant leur sauvegarde. Lors du prochain lancement, l'application récupère les informations enregistrées afin de restaurer la liste des échéances.

Cette méthode permet une conservation locale des données, sans nécessiter actuellement de serveur ou de base de données distante.

## 9. Conclusion

CampusFlow est une application de suivi des activités universitaires développée avec Flutter. Elle met en œuvre les principaux concepts du développement mobile et Web, notamment la création d'interfaces, la navigation entre les pages, la gestion des formulaires, la validation des données, l'adaptation aux différentes tailles d'écran et la persistance locale des informations.

Voici le lien github : https://github.com/kypriscarosemonde-boop/Campus_flow.git