# CampusFlow – Application de gestion des échéances universitaires

## 1. Présentation du projet

**CampusFlow** est une application développée avec Flutter dans le but de faciliter la gestion et le suivi des activités et des échéances universitaires.

Elle permet à l'utilisateur d'organiser ses différentes activités, de consulter les échéances à venir, de suivre leur état d'avancement et de gérer efficacement ses obligations universitaires.

L'application propose une interface simple, intuitive et adaptée aux différents écrans.

### Fonctionnalités principales

- **Authentification :** accès à l'application à travers une page de connexion.
- **Consultation des échéances :** affichage de la liste des activités universitaires enregistrées.
- **Ajout d'échéances :** création de nouvelles activités avec un titre et une date.
- **Modification des échéances :** possibilité de modifier les informations d'une échéance existante.
- **Suppression des échéances :** suppression d'une activité avec une demande de confirmation.
- **Consultation des détails :** affichage des informations détaillées d'une échéance.
- **Gestion des statuts :** possibilité de marquer une échéance comme terminée.
- **Recherche :** recherche d'une échéance à partir de son titre.
- **Filtrage :** affichage des échéances selon leur état :
  - Toutes ;
  - À faire ;
  - Terminées ;
  - En retard.
- **Détection des retards :** identification automatique des échéances non terminées dont la date est dépassée.
- **Tableau de bord statistique :** affichage du nombre total d'échéances, des échéances terminées, de celles à faire et de celles en retard.
- **Suivi de la progression :** affichage du pourcentage d'avancement des activités.
- **Sauvegarde locale :** conservation des échéances grâce à SharedPreferences.
- **Interface adaptative :** affichage adapté aux téléphones, tablettes et navigateurs Web.

## 2. Technologies utilisées

| Technologie | Rôle |
|---|---|
| Flutter | Développement de l'interface de l'application |
| Dart | Langage de programmation |
| Material Design | Conception des composants graphiques |
| SharedPreferences | Sauvegarde locale des données |
| JSON | Organisation et sérialisation des données |
| Git et GitHub | Gestion des versions et hébergement du code source |

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
│   └── widget_test.dart
│
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
└── README.md
```

### Description des principaux fichiers

**`lib/main.dart`**

C'est le point d'entrée de l'application. Il initialise Flutter, configure le thème général et affiche l'interface principale de CampusFlow ainsi que la page de connexion.

**`lib/pages/echeances_page.dart`**

Cette page constitue l'interface principale de gestion des échéances. Elle permet notamment :

- D'afficher la liste des échéances ;
- D'ajouter, de modifier et de supprimer une échéance ;
- D'effectuer une recherche par titre ;
- De filtrer les échéances selon leur statut ;
- De consulter les statistiques et la progression ;
- De charger et de sauvegarder les données localement.

**`lib/pages/echeance_detail_page.dart`**

Cette page présente les informations détaillées d'une échéance. Elle permet également de consulter son état et de la marquer comme terminée.

**`lib/pages/echeance_form_page.dart`**

Cette page contient le formulaire de création et de modification d'une échéance. Elle permet de saisir ou de mettre à jour le titre et la date d'une activité.

**`assets/images/logo.png`**

Contient le logo utilisé dans l'application.

**`pubspec.yaml`**

Ce fichier contient les informations générales du projet, les dépendances utilisées et la déclaration des ressources, notamment les images.

**`test/widget_test.dart`**

Contient les tests permettant de vérifier le lancement de l'application et le bon fonctionnement des widgets concernés.

## 4. Installation et configuration

### 4.1. Prérequis

Avant de lancer le projet, il faut disposer des éléments suivants :

- Flutter SDK installé ;
- Dart installé (fourni avec Flutter) ;
- Visual Studio Code ou Android Studio ;
- Google Chrome pour exécuter l'application en version Web ;
- Une connexion Internet pour télécharger les dépendances lors de la première installation ;
- Git pour récupérer le projet depuis GitHub.

### 4.2. Récupération du projet

Pour récupérer le projet depuis GitHub, exécuter la commande suivante :

```bash
git clone https://github.com/kypriscarosemonde-boop/Campus_flow.git
```

Entrer ensuite dans le dossier du projet :

```bash
cd Campus_flow
```

### 4.3. Installation des dépendances

Exécuter la commande suivante :

```bash
flutter pub get
```

Cette commande permet de télécharger et d'installer les bibliothèques nécessaires au fonctionnement de l'application, notamment `shared_preferences`.

## 5. Lancement de l'application

### 5.1. Vérifier l'installation de Flutter

```bash
flutter doctor
```

Cette commande vérifie l'installation de Flutter et signale les éventuels problèmes de configuration.

### 5.2. Vérifier les appareils disponibles

```bash
flutter devices
```

Cette commande affiche les appareils et les navigateurs disponibles pour exécuter l'application.

### 5.3. Lancer l'application sur Google Chrome

À la racine du projet, exécuter :

```bash
flutter run -d chrome --web-port=5000
```

L'application sera compilée et ouverte dans Google Chrome.

L'adresse locale d'accès sera :

```text
http://localhost:5000
```

## 6. Identifiants de connexion

Pour accéder à l'application CampusFlow, une page de connexion est proposée à l'utilisateur.

Les identifiants de connexion utilisés pour les tests et la démonstration sont les suivants :

| Informations | Valeurs |
|---|---|
| Adresse e-mail | admin@campusflow.com |
| Mot de passe | CampusFlow2026 |

**Remarque :** ces identifiants sont définis directement dans le code de l'application. Ils servent uniquement aux tests et à la démonstration. Ils ne constituent pas un système d'authentification sécurisé pour une utilisation en production.

## 7. Pourquoi préciser le port 5000 ?

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

- Utiliser toujours la même adresse pour accéder à l'application ;
- Éviter que Flutter choisisse automatiquement un port différent à chaque lancement ;
- Faciliter les tests et le débogage ;
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

## 8. Fonctionnement général de l'application

Le fonctionnement de CampusFlow repose sur plusieurs étapes :

1. L'utilisateur ouvre l'application et accède à la page de connexion.
2. Il saisit ses identifiants pour accéder à l'application.
3. Il accède à la page principale des échéances.
4. Il consulte les statistiques et les activités enregistrées.
5. Il peut rechercher une échéance à partir de son titre.
6. Il peut filtrer les échéances selon leur état : toutes, à faire, terminées ou en retard.
7. Il peut sélectionner une échéance pour consulter ses détails.
8. Il peut ajouter une nouvelle échéance à partir du formulaire.
9. Il peut modifier les informations d'une échéance existante.
10. Il peut supprimer une échéance après confirmation.
11. Il peut marquer une échéance comme terminée.
12. Les statistiques et la progression sont actualisées en fonction des modifications effectuées.
13. Les informations sont sauvegardées localement grâce à SharedPreferences.

## 9. Gestion des échéances

CampusFlow propose plusieurs opérations permettant à l'utilisateur de gérer ses activités universitaires.

### 9.1. Ajout d'une échéance

L'utilisateur peut créer une nouvelle échéance en renseignant son titre et sa date à travers un formulaire.

Après validation, l'activité est ajoutée à la liste des échéances.

### 9.2. Modification d'une échéance

L'utilisateur peut modifier une échéance déjà enregistrée. Les informations existantes sont automatiquement récupérées dans le formulaire afin de faciliter leur modification.

Après enregistrement, la liste est actualisée.

### 9.3. Suppression d'une échéance

L'utilisateur peut supprimer une échéance qui n'est plus nécessaire.

Une boîte de dialogue de confirmation est affichée avant la suppression afin d'éviter les suppressions accidentelles.

### 9.4. Consultation des détails

En sélectionnant une échéance, l'utilisateur accède à une page présentant ses informations et son état d'avancement.

### 9.5. Gestion des statuts

Une échéance peut avoir différents états :

- **À faire :** l'activité n'a pas encore été réalisée.
- **Terminée :** l'activité a été réalisée et validée.
- **En retard :** la date prévue est dépassée alors que l'activité n'est pas encore terminée.

## 10. Recherche et filtrage

Pour faciliter la navigation dans la liste des activités, CampusFlow intègre une fonctionnalité de recherche et un système de filtres.

### 10.1. Recherche

La barre de recherche permet de retrouver rapidement une échéance en saisissant son titre.

Les résultats affichés correspondent aux échéances dont le titre contient le texte recherché.

### 10.2. Filtres disponibles

| Filtre | Fonctionnement |
|---|---|
| Toutes | Affiche l'ensemble des échéances |
| À faire | Affiche uniquement les échéances non terminées |
| Terminées | Affiche uniquement les échéances terminées |
| En retard | Affiche les échéances non terminées dont la date est dépassée |

La recherche et les filtres permettent de retrouver plus facilement les activités à suivre.

## 11. Tableau de bord et statistiques

CampusFlow intègre un tableau de bord permettant à l'utilisateur de suivre l'évolution de ses activités universitaires.

Les indicateurs affichés sont :

| Indicateur | Description |
|---|---|
| Total | Nombre total d'échéances enregistrées |
| Terminées | Nombre d'échéances réalisées |
| À faire | Nombre d'échéances qui restent à réaliser |
| En retard | Nombre d'échéances dont la date est dépassée et qui ne sont pas terminées |
| Progression | Pourcentage des échéances terminées par rapport au nombre total |

Une barre de progression permet également de visualiser l'avancement global des activités.

Ces statistiques sont actualisées lorsque l'utilisateur ajoute, modifie, supprime ou termine une échéance.

## 12. Sauvegarde des données

L'application utilise le package `shared_preferences` pour conserver les échéances sur l'appareil.

Les données sont transformées au format JSON avant leur sauvegarde.

Lors du prochain lancement de l'application, les informations enregistrées sont récupérées afin de restaurer la liste des échéances.

Cette méthode permet :

- De conserver les échéances après la fermeture de l'application ;
- De retrouver les activités lors d'une nouvelle ouverture ;
- De sauvegarder les modifications apportées aux échéances ;
- De supprimer définitivement les activités retirées de la liste sauvegardée.

**Remarque :** les données sont stockées localement sur l'appareil. Elles ne sont pas synchronisées entre plusieurs appareils et ne nécessitent actuellement ni serveur distant ni base de données centralisée.

## 13. Tests des fonctionnalités

Les fonctionnalités de CampusFlow peuvent être vérifiées à travers les tests suivants.

### 13.1. Tests de gestion des échéances

| Test | Action à effectuer | Résultat attendu |
|---|---|---|
| Ajout | Ajouter une nouvelle échéance avec un titre et une date. | L'échéance apparaît dans la liste. |
| Modification | Modifier le titre ou la date d'une échéance. | Les nouvelles informations sont enregistrées. |
| Suppression | Supprimer une échéance et confirmer. | L'échéance disparaît de la liste. |
| Consultation | Sélectionner une échéance. | Ses détails s'affichent. |
| Validation | Marquer une échéance comme terminée. | Son statut devient « Terminée ». |

### 13.2. Tests de recherche et de filtrage

| Test | Action à effectuer | Résultat attendu |
|---|---|---|
| Recherche | Saisir un titre dans la barre de recherche. | Les échéances correspondantes s'affichent. |
| Toutes | Sélectionner le filtre « Toutes ». | Toutes les échéances sont affichées. |
| À faire | Sélectionner le filtre « À faire ». | Les échéances non terminées sont affichées. |
| Terminées | Sélectionner le filtre « Terminées ». | Les échéances terminées sont affichées. |
| En retard | Sélectionner le filtre « En retard ». | Les échéances non terminées dont la date est dépassée sont affichées. |

### 13.3. Tests des statistiques

| Test | Action à effectuer | Résultat attendu |
|---|---|---|
| Total | Ajouter ou supprimer une échéance. | Le nombre total est actualisé. |
| Terminées | Marquer une échéance comme terminée. | Le nombre d'échéances terminées est actualisé. |
| À faire | Ajouter une nouvelle échéance non terminée. | Le nombre d'échéances à faire est actualisé. |
| En retard | Laisser dépasser la date d'une échéance non terminée. | Elle est comptabilisée parmi les échéances en retard. |
| Progression | Modifier le nombre d'échéances terminées. | Le pourcentage de progression est actualisé. |

### 13.4. Tests de sauvegarde

| Test | Action à effectuer | Résultat attendu |
|---|---|---|
| Sauvegarde | Ajouter ou modifier une échéance. | Les données sont enregistrées localement. |
| Persistance | Actualiser ou redémarrer l'application. | Les échéances enregistrées sont toujours disponibles. |

### 13.5. Exécution des tests Flutter

Pour lancer les tests automatisés du projet, exécuter :

```bash
flutter test
```

Cette commande permet de vérifier les tests présents dans le dossier `test`.

## 14. Perspectives d'amélioration

Plusieurs améliorations pourraient être apportées à CampusFlow afin d'enrichir ses fonctionnalités :

- Intégration d'une base de données distante pour synchroniser les données ;
- Mise en place d'un système d'authentification sécurisé ;
- Gestion de plusieurs utilisateurs ;
- Ajout de notifications et de rappels avant les dates limites ;
- Possibilité de classer les échéances par matière ou par catégorie ;
- Ajout d'un calendrier universitaire ;
- Synchronisation des échéances entre plusieurs appareils.

## 15. Conclusion

CampusFlow est une application de gestion et de suivi des échéances universitaires développée avec Flutter et Dart.

Elle permet de centraliser les activités universitaires, de gérer les échéances, de suivre leur état d'avancement et de visualiser des statistiques sur les activités réalisées et celles qui restent à effectuer.

Ce projet met en pratique plusieurs concepts essentiels du développement d'applications, notamment la création d'interfaces graphiques, la navigation entre les pages, la gestion des formulaires, la manipulation des données, la recherche, le filtrage et la persistance locale des informations.

CampusFlow constitue ainsi une solution simple et pratique pour améliorer l'organisation et le suivi des activités universitaires.

## 16. Dépôt GitHub

Le code source du projet est disponible sur GitHub :

**Lien du dépôt :** https://github.com/kypriscarosemonde-boop/Campus_flow

