// Modelo que representa a una cuenta de HábitosApp.
class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String contrasena;
  final String fechaCreacion;
  final bool administrador;
  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.fechaCreacion,
    this.administrador = false,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'contrasena': contrasena,
    'fechaCreacion': fechaCreacion,
    'administrador': administrador,
  };
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json['id'],
    nombre: json['nombre'],
    correo: json['correo'],
    contrasena: json['contrasena'],
    fechaCreacion: json['fechaCreacion'],
    administrador: json['administrador'] ?? false,
  );
}