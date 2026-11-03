
class Tache {
  final String id;
  final String titre;
  final String date;
  final bool terminee;
  final String icone;

  const Tache({
    required this.id,
    required this.titre,
    required this.date,
    required this.terminee,
    required this.icone,
  });

  // Convertir une Map en objet Tache
  factory Tache.fromMap(Map<String, dynamic> map) {
    return Tache(
      id: map['id']?.toString() ?? '',
      titre: map['titre']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      terminee: map['terminee'] == true,
      icone: map['icone']?.toString() ?? 'event_note',
    );
  }

  // Convertir un objet Tache en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'date': date,
      'terminee': terminee,
      'icone': icone,
    };
  }

  // Créer une copie avec certaines propriétés modifiées
  Tache copyWith({
    String? id,
    String? titre,
    String? date,
    bool? terminee,
    String? icone,
  }) {
    return Tache(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      date: date ?? this.date,
      terminee: terminee ?? this.terminee,
      icone: icone ?? this.icone,
    );
  }
}
