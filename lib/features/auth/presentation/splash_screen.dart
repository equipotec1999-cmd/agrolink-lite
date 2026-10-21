import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/agrolink_logo.dart';
import '../application/auth_controller.dart';
import '../../../core/push/push_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void initState() {
    super.initState();
    _c.forward().whenComplete(() async {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      // El usuario ya viene resuelto desde main.dart (token válido restaurado o no);
      // aquí solo decidimos a dónde navegar, sin ninguna llamada de red nueva.
      final loggedIn = ref.read(authProvider) != null;
      context.go(loggedIn ? '/home' : '/login');
      // App abierta tocando una notificación push: se va directo a esa conversación.
      if (loggedIn) {
        final route = await ref.read(pushServiceProvider)?.takePendingRoute();
        if (route != null && mounted) context.push(route);
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lite: pantalla estática, fondo blanco y logo negro (sin animación).
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AgroLinkMark(size: 150, color: Colors.black),
            SizedBox(height: 22),
            AgroLinkWordmark(size: 34, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
