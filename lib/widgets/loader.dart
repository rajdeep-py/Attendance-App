import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLoader extends StatefulWidget {
  final String subText;

  const AppLoader({this.subText = 'Please wait...', super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Frosted dark overlay ──────────────────────────────────────────
        Positioned.fill(
          child: Container(
            color: kBlack.withAlpha((0.45 * 255).toInt()),
          ),
        ),

        // ── Centred content card ──────────────────────────────────────────
        Center(
          child: Container(
            width: 220,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: kGreen.withAlpha((0.35 * 255).toInt()),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withAlpha((0.22 * 255).toInt()),
                  blurRadius: 40,
                  spreadRadius: 4,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: kGreen.withAlpha((0.12 * 255).toInt()),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Pulsing logo with green arc ───────────────────────────
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Green spinning arc
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(kGreen),
                          backgroundColor:
                              kGreen.withAlpha((0.12 * 255).toInt()),
                          strokeWidth: 3.5,
                          strokeCap: StrokeCap.round,
                        ),
                      ),

                      // Pulsing logo circle
                      ScaleTransition(
                        scale: _pulseAnim,
                        child: Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kWhiteGrey,
                            boxShadow: [
                              BoxShadow(
                                color: kBrown.withAlpha((0.12 * 255).toInt()),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            'assets/logo/A24.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Label ─────────────────────────────────────────────────
                Text(
                  widget.subText,
                  style: kCaptionTextStyle.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: kBlack,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),

                // ── Subtle dot-row progress hint ──────────────────────────
                _AnimatedDots(controller: _controller),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Three bouncing dots that animate in sync with [controller].
class _AnimatedDots extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final phase = (controller.value + i * 0.25) % 1.0;
            final opacity = Curves.easeInOut.transform(phase);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kGreen.withOpacity(0.3 + opacity * 0.7),
              ),
            );
          }),
        );
      },
    );
  }
}
