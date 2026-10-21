import 'package:flutter/material.dart';

/// Lite: toque simple, sin escala animada ni vibración (menos trabajo por frame).
class Pressable extends StatelessWidget {
  const Pressable({super.key, required this.child, this.onTap, this.scale = 0.96});

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap, child: child);
  }
}

/// Lite: sin animación de entrada; el contenido aparece directo.
class FadeSlideIn extends StatelessWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = 24,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  Widget build(BuildContext context) => child;
}

/// Lite: placeholder estático (sin animación continua).
class Skeleton extends StatelessWidget {
  const Skeleton({super.key, this.height, this.width, this.radius = 20});

  final double? height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E2D3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
