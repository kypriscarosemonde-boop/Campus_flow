
class Echeance {
  final String id;
  final String titre;
  final String date;
  final bool terminee;
  final String icone;

  const Echeance({
    required this.id,
    required this.titre,
    required this.date,
    required this.terminee,
    required this.icone,
  });

  // Transformer les données en objet Echeance
  factory Echeance.fromMap(Map<String, dynamic> map) {
    return Echeance(
      id: map['id']?.toString() ?? '',
      titre: map['titre']?.toString() ?? '',
      date: map['date']?.toString() ?? '',
      terminee: map['terminee'] == true,
      icone: map['icone']?.toString() ?? 'event_note',
    );
  }

  // Transformer l'objet Echeance en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'date': date,
      'terminee': terminee,
      'icone': icone,
    };
  }

  // Créer une copie en modifiant uniquement certains attributs
  Echeance copyWith({
    String? id,
    String? titre,
    String? date,
    bool? terminee,
    String? icone,
  }) {
    return Echeance(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      date: date ?? this.date,
      terminee: terminee ?? this.terminee,
      icone: icone ?? this.icone,
    );
  }
}
