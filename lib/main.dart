import 'package:app_planes/screens/Register/register_datos_medicos.dart';
import 'package:app_planes/screens/Register/register_user.dart';
import 'package:app_planes/screens/VentanaPerfil/ventana_perfil.dart';
import 'package:flutter/material.dart';
import 'package:app_planes/utils/dimensiones_pantalla.dart';

// Importaciones Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importaciones Screens
import 'screens/Login/login_screen.dart';
import 'screens/Register/register_datos_personales.dart';
import 'screens/home.dart';
import 'screens/start_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Manejo de errores en la inicialización de Firebase
    print('Error al inicializar Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Planes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthenticationWrapper(),
      routes: {
        '/register-1': (context) => const RegistroDatosPersonales(),
        '/register-2': (context) => const RegistroDatosMedicos(),
        '/register-3': (context) => const RegistroUsuario(),
        '/login': (context) => const VentanaInicioSeccion(),
        '/profile': (context) => const VentanaPerfil(),
        '/home': (context) => const Inicio(),
        '/start': (context) => const ArranqueApp(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    DimensionesDePantalla.init(context);

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Pantalla de carga
            ),
          );
        } else if (snapshot.hasData) {
          // Usuario autenticado, redirige a Home
          return const Inicio();
        } else {
          // Usuario no autenticado, redirige a pantalla inicial
          return const ArranqueApp();
        }
      },
    );
  }
}
