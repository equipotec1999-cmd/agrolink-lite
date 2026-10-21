import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text.dart';
import '../../features/chat/application/chat_controller.dart';
import '../../features/my_listings/data/my_listings_repository.dart';
import '../../features/settings/data/account_repository.dart';
import 'motion.dart';

/// Contenedor con barra de navegación flotante y botón central "Publicar".
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: shell,
      bottomNavigationBar: _AgroNavBar(
        index: shell.currentIndex,
        onSelect: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        onPublish: () => context.push('/create'),
      ),
    );
  }
}

class _AgroNavBar extends ConsumerWidget {
  const _AgroNavBar({required this.index, required this.onSelect, required this.onPublish});

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onPublish;

  static const _items = [
    (Icons.home_outlined, 'Inicio'),
    (Icons.search_rounded, 'Buscar'),
    (Icons.chat_bubble_outline_rounded, 'Mensajes'),
    (Icons.person_outline_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);

    Widget item(int i) {
      final (icon, label) = _items[i];
      final active = i == index;
      return Expanded(
        child: Pressable(
          scale: 0.9,
          onTap: () {
            // Al entrar a Perfil se vuelven a pedir sus cifras y sus publicaciones (pudieron cambiar).
            if (i == 3) {
              ref.invalidate(profileStatsProvider);
              ref.invalidate(myListingsProvider);
            }
            onSelect(i);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 24, color: active ? AppColors.ink : AppColors.muted),
                  if (i == 2 && unread > 0)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: AppColors.clay, borderRadius: BorderRadius.circular(6)),
                        child: Text('$unread', style: AppText.label.copyWith(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: AppText.label.copyWith(
                  fontSize: 10.5,
                  color: active ? AppColors.ink : AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Lite: barra plana de borde a borde (sin pastilla flotante, sin sombra).
    return SafeArea(
      top: false,
      child: Container(
        height: 58,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            item(0),
            item(1),
            _PublishButton(onTap: onPublish),
            item(2),
            item(3),
          ],
        ),
      ),
    );
  }
}

class _PublishButton extends StatelessWidget {
  const _PublishButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Pressable(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.add_rounded, color: AppColors.bone, size: 26),
        ),
      ),
    );
  }
}
