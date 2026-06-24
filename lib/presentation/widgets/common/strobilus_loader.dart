import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/design_system.dart';

enum LoaderType { spinner, shimmer, scan }

class StrobilusLoader extends StatelessWidget {
  final LoaderType type;
  final Widget? child; // For shimmer/scan modes
  final String? message; // Optional message
  final double width;
  final double height;

  const StrobilusLoader({
    super.key,
    this.type = LoaderType.spinner,
    this.child,
    this.message,
    this.width = 40,
    this.height = 40,
  });

  factory StrobilusLoader.spinner({String? message}) => 
      StrobilusLoader(type: LoaderType.spinner, message: message);

  factory StrobilusLoader.shimmer({
    required Widget child, 
    String? message,
  }) => StrobilusLoader(type: LoaderType.shimmer, child: child, message: message);

  factory StrobilusLoader.scan({
    required Widget child, 
    String? message,
  }) => StrobilusLoader(type: LoaderType.scan, child: child, message: message);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget loader;
    switch (type) {
      case LoaderType.spinner:
        loader = SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: theme.colorScheme.primary,
          ),
        );
        break;
      case LoaderType.shimmer:
        loader = Shimmer.fromColors(
          baseColor: theme.colorScheme.surfaceContainerHighest,
          highlightColor: theme.colorScheme.surface,
          child: child ?? 
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: DS.borderRadiusMd,
                ),
              ),
        );
        break;
      case LoaderType.scan:
        loader = _ScannerAnimation(child: child!);
        break;
    }

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loader,
          const SizedBox(height: DS.md),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loader;
  }
}

class _ScannerAnimation extends StatefulWidget {
  final Widget child;

  const _ScannerAnimation({required this.child});

  @override
  State<_ScannerAnimation> createState() => _ScannerAnimationState();
}

class _ScannerAnimationState extends State<_ScannerAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                    stops: [
                      _controller.value - 0.2,
                      _controller.value,
                      _controller.value + 0.2,
                    ],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcATop,
                child: Container(
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
