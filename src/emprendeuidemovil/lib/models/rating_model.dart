class RatingModel {
  final String id;
  final String emprendedorId;
  final String clienteId;
  final String clienteName;
  final String emprendimientoId;
  final String emprendimientoName;
  final String comentario;
  final double rating;
  final DateTime fecha;

  const RatingModel({
    required this.id,
    required this.emprendedorId,
    required this.clienteId,
    required this.clienteName,
    required this.emprendimientoId,
    required this.emprendimientoName,
    required this.comentario,
    required this.rating,
    required this.fecha,
  });

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      id: map['id'] ?? '',
      emprendedorId: map['emprendedorId'] ?? '',
      clienteId: map['clienteId'] ?? '',
      clienteName: map['clienteName'] ?? '',
      emprendimientoId: map['emprendimientoId'] ?? '',
      emprendimientoName: map['emprendimientoName'] ?? '',
      comentario: map['comentario'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      fecha: DateTime.fromMillisecondsSinceEpoch(map['fecha'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emprendedorId': emprendedorId,
      'clienteId': clienteId,
      'clienteName': clienteName,
      'emprendimientoId': emprendimientoId,
      'emprendimientoName': emprendimientoName,
      'comentario': comentario,
      'rating': rating,
      'fecha': fecha.millisecondsSinceEpoch,
    };
  }
}