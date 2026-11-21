class KineticRecord {
  final int? id;
  final double mass;
  final double velocity;
  final double energy;
  final DateTime createdAt;

  KineticRecord({
    this.id,
    required this.mass,
    required this.velocity,
    required this.energy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'mass': mass,
        'velocity': velocity,
        'energy': energy,
        'created_at': createdAt.toIso8601String(),
      };

  factory KineticRecord.fromMap(Map<String, dynamic> m) => KineticRecord(
        id: m['id'] as int?,
        mass: (m['mass'] as num).toDouble(),
        velocity: (m['velocity'] as num).toDouble(),
        energy: (m['energy'] as num).toDouble(),
        createdAt: DateTime.parse(m['created_at'] as String),
      );
}