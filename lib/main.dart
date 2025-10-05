import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geofence/auth/auth_page.dart';
import 'package:geofence/pages/about_page.dart';
import 'package:geofence/pages/home_page.dart';
import 'package:geofence/pages/profile_page.dart';
import 'package:geofence/pages/result_screen.dart';
import 'package:geofence/pages/settings_page.dart';
import 'package:geofence/theme/dark_mode.dart';
import 'package:geofence/theme/light_mode.dart';
import 'firebase_options.dart';
import 'auth/login_or_register.dart';
import 'providers/theme_provider.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);  // Use WidgetRef for Riverpod

    final _router = GoRouter(
      initialLocation: '/auth', // Adjust to your initial route
      routes: [
        // Define all routes
        GoRoute(
          name: "auth",
          path: '/auth',
          builder: (context, state) => const AuthPage(),
        ),
        GoRoute(
          name: "login_register_page",
          path: '/login_register_page',
          builder: (context, state) => const LoginOrRegister(),
        ),
        GoRoute(
          name: "home_page",
          path: '/home_page',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          name: "about_page",
          path: '/about_page',
          builder: (context, state) => const AboutPage(),
        ),
        GoRoute(
          name: "profile_page",
          path: '/profile_page',
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          name: "settings_page",
          path: '/settings_page',
          builder: (context, state) => SettingsPage(),
        ),
        // GoRoute(
        //   name: "result_page",
        //   path: '/results',
        //   builder: (context, state) => const ResultScreen(), // Create this page
        // ),
        GoRoute(
          name: "result_page",
          path: '/results',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>?; // the response we’ll send
            return ResultScreen(data: data);
          },
        ),

      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Stenter Machine Monitoring',
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      routerConfig: _router, // Use GoRouter config
    );
  }
}
