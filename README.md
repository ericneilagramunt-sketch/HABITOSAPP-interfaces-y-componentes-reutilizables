# HábitosApp
Aplicación Flutter de seguimiento de hábitos (DAM2). Usa SQLite (sqflite) para los datos y SharedPreferences para recordar la sesión.
## Estructura de lib/
- `main.dart`: inicio y configuración (un único MaterialApp).
- `modelos/`: Usuario, Habito, Estadistica, ColoresHabito.
- `servicios/`: BaseDatos, UsuarioService, HabitoService, EstadisticaService (CRUD) y SesionService.
- `widgets/`: CampoTextoApp, BotonPrincipal, TarjetaHabito, DatoEstadistica.
- `pantallas/`: login, registro, hábitos, editar hábito, estadísticas y administración.

## Acceso
- Administrador por defecto: usuario `admin`, contraseña `admin123`.
- Los usuarios nuevos se registran desde la pantalla de registro (rol usuario).

## Ejecutar (Android / iOS; sqflite no funciona en web)
```
flutter pub get
flutter run
```
