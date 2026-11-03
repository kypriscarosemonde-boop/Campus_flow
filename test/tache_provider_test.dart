
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:campus_flow/models/tache.dart';
import 'package:campus_flow/providers/tache_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Tests de TachesNotifier', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      container = ProviderContainer();

      // Attendre le chargement initial des tâches.
      await container.read(tachesProvider.future);
    });

    tearDown(() {
      container.dispose();
    });

    test('Le chargement initial doit retourner une liste vide', () async {
      final taches = await container.read(tachesProvider.future);

      expect(taches, isEmpty);
    });

    test('Ajouter une tâche doit mettre à jour la liste', () async {
      final nouvelleTache = Tache(
        id: '1',
        titre: 'Réviser Flutter',
        date: '10/11/2026',
        terminee: false,
        icone: 'event_note',
      );

      await container
          .read(tachesProvider.notifier)
          .ajouter(nouvelleTache);

      final taches = container.read(tachesProvider).requireValue;

      expect(taches.length, 1);
      expect(taches.first.titre, 'Réviser Flutter');
      expect(taches.first.id, '1');
    });

    test('Ajouter une tâche doit la sauvegarder', () async {
      final nouvelleTache = Tache(
        id: '2',
        titre: 'Apprendre Riverpod',
        date: '12/11/2026',
        terminee: false,
        icone: 'event_note',
      );

      await container
          .read(tachesProvider.notifier)
          .ajouter(nouvelleTache);

      final preferences = await SharedPreferences.getInstance();
      final donnees = preferences.getString('mes_taches');

      expect(donnees, isNotNull);
      expect(donnees, contains('Apprendre Riverpod'));
    });
    test('Modifier une tâche doit mettre à jour ses informations', () async {
      final tache = Tache(
        id: '3',
        titre: 'Ancien titre',
        date: '10/11/2026',
        terminee: false,
        icone: 'event_note',
      );

      final notifier = container.read(tachesProvider.notifier);

      await notifier.ajouter(tache);

      final tacheModifiee = tache.copyWith(
        titre: 'Nouveau titre',
      );

      await notifier.modifier(tacheModifiee);

      final taches = container.read(tachesProvider).requireValue;

      expect(taches.length, 1);
      expect(taches.first.titre, 'Nouveau titre');
    }); test('Supprimer une tâche doit la retirer de la liste', () async {
      final tache = Tache(
        id: '4',
        titre: 'Tâche à supprimer',
        date: '10/11/2026',
        terminee: false,
        icone: 'event_note',
      );

      final notifier = container.read(tachesProvider.notifier);

      await notifier.ajouter(tache);
      await notifier.supprimer(tache.id);

      final taches = container.read(tachesProvider).requireValue;

      expect(taches, isEmpty);
    });});

}
