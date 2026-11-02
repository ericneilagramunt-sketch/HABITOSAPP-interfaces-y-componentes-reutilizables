/// Modelo de un usuario (tabla usuarios).
class Usuario {
  static const String rolAdmin = 'administrador';
  static const String rolUsuario = 'usuario';

  int? id;
  String usuario;
  String nombre;
  String apellidos;
  String email;
  String contrasena;
  String fechaCreacion;
  String rol;

  Usuario({
    this.id,
    required this.usuario,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.contrasena,
    required this.fechaCreacion,
    required this.rol,
  });

  bool get esAdmin => rol == rolAdmin;

  // Objeto -> Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() => {
        'id': id,
        'usuario': usuario,
        'nombre': nombre,
        'apellidos': apellidos,
        'email': email,
        'contrasena': contrasena,
        'fecha_creacion': fechaCreacion,
        'rol': rol,
      };

  // Map -> objeto (al leer de la base de datos)
  factory Usuario.fromMap(Map<String, dynamic> m) => Usuario(
        id: m['id'] as int,
        usuario: m['usuario'] as String,
        nombre: m['nombre'] as String,
        apellidos: m['apellidos'] as String,
        email: m['email'] as String,
        contrasena: m['contrasena'] as String,
        fechaCreacion: m['fecha_creacion'] as String,
        rol: m['rol'] as String,
      );
}
