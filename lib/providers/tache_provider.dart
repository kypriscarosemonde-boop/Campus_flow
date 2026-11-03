
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/tache.dart';

// Provider principal
final tachesProvider =
AsyncNotifierProvider<TachesNotifier, List<Tache>>(
  TachesNotifier.new,
);

class TachesNotifier extends AsyncNotifier<List<Tache>> {
  static const String _cleStockage = 'mes_taches';

  // Chargement des tâches au démarrage
  @override
  Future<List<Tache>> build() async {
    final preferences = await SharedPreferences.getInstance();

    // Lire les nouvelles données
    var donnees = preferences.getString(_cleStockage);

    // Vérifier si la nouvelle liste est absente ou vide
    if (donnees == null || donnees == '[]') {
      final anciennesDonnees =
      preferences.getString('mes_echeances');

      // Récupérer les anciennes données si elles existent
      if (anciennesDonnees != null && anciennesDonnees != '[]') {
        donnees = anciennesDonnees;

        // Enregistrer les données dans la nouvelle clé
        await preferences.setString(
          _cleStockage,
          donnees,
        );
      }
    }

    // Aucune donnée disponible
    if (donnees == null) {
      return [];
    }

    // Convertir le JSON en liste
    final List<dynamic> listeJson = jsonDecode(donnees);

    return listeJson.map((element) {
      return Tache.fromMap(
        Map<String, dynamic>.from(element),
      );
    }).toList();
  }

  // Enregistrement dans SharedPreferences
  Future<void> _sauvegarder(List<Tache> taches) async {
    final preferences = await SharedPreferences.getInstance();

    final donnees = jsonEncode(
      taches.map((tache) => tache.toMap()).toList(),
    );

    await preferences.setString(_cleStockage, donnees);
  }

  // Ajouter une tâche
  Future<void> ajouter(Tache nouvelleTache) async {
    final anciennesTaches = state.asData?.value ?? [];

    final nouvelleListe = [
      ...anciennesTaches,
      nouvelleTache,
    ];

    await _sauvegarder(nouvelleListe);

    state = AsyncData(nouvelleListe);
  }

  // Modifier une tâche
  Future<void> modifier(Tache tacheModifiee) async {
    final anciennesTaches = state.asData?.value ?? [];

    final nouvelleListe = anciennesTaches.map((tache) {
      return tache.id == tacheModifiee.id
          ? tacheModifiee
          : tache;
    }).toList();

    await _sauvegarder(nouvelleListe);

    state = AsyncData(nouvelleListe);
  }

  // Supprimer une tâche grâce à son ID
  Future<void> supprimer(String id) async {
    final anciennesTaches = state.asData?.value ?? [];

    final nouvelleListe = anciennesTaches
        .where((tache) => tache.id != id)
        .toList();

    await _sauvegarder(nouvelleListe);

    state = AsyncData(nouvelleListe);
  }

  // Marquer une tâche comme terminée ou non terminée
  Future<void> marquerCommeTerminee(
      String id,
      bool terminee,
      ) async {
    final anciennesTaches = state.asData?.value ?? [];

    final nouvelleListe = anciennesTaches.map((tache) {
      if (tache.id == id) {
        return tache.copyWith(terminee: terminee);
      }

      return tache;
    }).toList();

    await _sauvegarder(nouvelleListe);

    state = AsyncData(nouvelleListe);
  }
}

// Convertir une date écrite en texte en DateTime
DateTime? _convertirDateTache(String date) {
  // Format : 01/11/2026
  final dateNumerique = date.split('/');

  if (dateNumerique.length == 3) {
    final jour = int.tryParse(dateNumerique[0]);
    final mois = int.tryParse(dateNumerique[1]);
    final annee = int.tryParse(dateNumerique[2]);

    if (jour != null && mois != null && annee != null) {
      return DateTime.tryParse(
        '$annee-${mois.toString().padLeft(2, '0')}-${jour.toString().padLeft(2, '0')}',
      );
    }
  }

  // Format : 01 novembre 2026
  final parties = date.toLowerCase().trim().split(RegExp(r'\s+'));

  if (parties.length == 3) {
    const moisFrancais = {
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

    final jour = int.tryParse(parties[0]);
    final mois = moisFrancais[parties[1]];
    final annee = int.tryParse(parties[2]);

    if (jour != null && mois != null && annee != null) {
      return DateTime(annee, mois, jour);
    }
  }

  // Autres formats reconnus par DateTime
  return DateTime.tryParse(date);
}

// Fournisseur des tâches À faire
final tachesAFaireProvider = Provider<AsyncValue<List<Tache>>>((ref) {
  final tachesAsync = ref.watch(tachesProvider);

  return tachesAsync.whenData(
        (taches) => taches.where((tache) => !tache.terminee).toList(),
  );
});

// Fournisseur des tâches Faites
final tachesFaitesProvider = Provider<AsyncValue<List<Tache>>>((ref) {
  final tachesAsync = ref.watch(tachesProvider);

  return tachesAsync.whenData(
        (taches) => taches.where((tache) => tache.terminee).toList(),
  );
});

// Fournisseur des tâches En retard
final tachesEnRetardProvider = Provider<AsyncValue<List<Tache>>>((ref) {
  final tachesAsync = ref.watch(tachesProvider);

  return tachesAsync.whenData((taches) {
    final aujourdHui = DateTime.now();

    final dateDuJour = DateTime(
      aujourdHui.year,
      aujourdHui.month,
      aujourdHui.day,
    );

    return taches.where((tache) {
      // Une tâche déjà faite ne peut pas être en retard
      if (tache.terminee) return false;

      final dateTache = _convertirDateTache(tache.date);

      return dateTache != null &&
          dateTache.isBefore(dateDuJour);
    }).toList();
  });
});
