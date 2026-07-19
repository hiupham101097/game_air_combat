import 'dart:math' as math;
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const SplashScreen({required this.onComplete, Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _progressController;
  late AnimationController _glowController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  final List<_StarParticle> _stars = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Generate background stars
    for (int i = 0; i < 80; i++) {
      _stars.add(_StarParticle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 2.5 + 0.5,
        speed: _random.nextDouble() * 0.003 + 0.001,
        brightness: _random.nextDouble() * 0.7 + 0.3,
      ));
    }

    // Logo pop-in animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _logoScale =
        CurvedAnimation(parent: _logoController, curve: Curves.elasticOut)
            .drive(Tween<double>(begin: 0.0, end: 1.0));
    _logoOpacity = CurvedAnimation(
            parent: _logoController, curve: const Interval(0.0, 0.5))
        .drive(Tween<double>(begin: 0.0, end: 1.0));

    // Title slide-in
    _titleOpacity = CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOut))
        .drive(Tween<double>(begin: 0.0, end: 1.0));
    _titleSlide = CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.4, 0.9, curve: Curves.easeOut))
        .drive(Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero));

    // Tagline
    _taglineOpacity = CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut))
        .drive(Tween<double>(begin: 0.0, end: 1.0));
    _taglineSlide = CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut))
        .drive(Tween<Offset>(begin: const Offset(0, 0.8), end: Offset.zero));

    // Particle / star drift animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Progress bar
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    // Glow pulse
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat(reverse: true);

    // Start sequence
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _progressController.forward();
    });

    // Complete splash after 3.2 seconds
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _particleController.dispose();
    _progressController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Deep space gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.2),
                radius: 1.2,
                colors: [
                  Color(0xFF0A0020),
                  Color(0xFF010008),
                  Colors.black,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Nebula glow layer
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.0, -0.1),
                    radius: 0.9,
                    colors: [
                      Color.fromARGB((30 + _glowController.value * 20).toInt(),
                          100, 40, 255),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),

          // Twinkling stars
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, _) {
              return CustomPaint(
                painter: _StarFieldPainter(
                    _stars, _particleController.value, _glowController.value),
              );
            },
          ),

          // Center content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo / Ship icon
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  );
                },
                child: AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(
                                (120 + _glowController.value * 80).toInt(),
                                100,
                                50,
                                255),
                            blurRadius: 40 + _glowController.value * 20,
                            spreadRadius: 10,
                          ),
                          BoxShadow(
                            color: Color.fromARGB(
                                (60 + _glowController.value * 40).toInt(),
                                50,
                                150,
                                255),
                            blurRadius: 60,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/app_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // Game title
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _titleOpacity.value,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: child,
                    ),
                  );
                },
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFFB060FF),
                      Color(0xFF60B0FF),
                      Color(0xFFFFFFFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'SPACE BLAST',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 6.0,
                      shadows: [
                        Shadow(
                          color: Color(0xFF8040FF),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tagline
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _taglineOpacity.value,
                    child: SlideTransition(
                      position: _taglineSlide,
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  'GALAXY COMBAT',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8899CC),
                    letterSpacing: 8.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Loading bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, _) {
                        return Column(
                          children: [
                            // Progress bar container
                            Container(
                              height: 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFF1A1030),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: FractionallySizedBox(
                                  widthFactor: _progressController.value,
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF6020CC),
                                          Color(0xFF9060FF),
                                          Color(0xFFCCAEFF),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _progressController.value < 0.4
                                  ? 'INITIALIZING...'
                                  : _progressController.value < 0.75
                                      ? 'LOADING ASSETS...'
                                      : 'READY TO LAUNCH',
                              style: const TextStyle(
                                color: Color(0xFF6655AA),
                                fontSize: 11,
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),

          // Corner accent dots (decorative)
          Positioned(
            top: 24,
            left: 24,
            child: _CornerDot(glowAnim: _glowController),
          ),
          Positioned(
            top: 24,
            right: 24,
            child: _CornerDot(glowAnim: _glowController),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: _CornerDot(glowAnim: _glowController),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: _CornerDot(glowAnim: _glowController),
          ),
        ],
      ),
    );
  }
}

// ─── Custom painter for star field ───────────────────────────────────────────

class _StarParticle {
  double x, y, size, speed, brightness;
  _StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.brightness,
  });
}

class _StarFieldPainter extends CustomPainter {
  final List<_StarParticle> stars;
  final double time;
  final double glowTime;

  _StarFieldPainter(this.stars, this.time, this.glowTime);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      // Drift downward (parallax)
      double y = (star.y + star.speed * time * 10) % 1.0;
      double x = star.x;

      double twinkle = 0.6 + 0.4 * math.sin(time * math.pi * 6 + star.x * 20);
      double alpha = star.brightness * twinkle;

      final paint = Paint()
        ..color = Color.fromARGB(
          (alpha * 220).toInt().clamp(0, 255),
          200,
          210,
          255,
        )
        ..maskFilter = star.size > 1.5
            ? MaskFilter.blur(BlurStyle.normal, star.size * 0.8)
            : null;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter old) => true;
}

// ─── Spaceship icon drawn with Canvas ────────────────────────────────────────

// ─── Corner decorative element ────────────────────────────────────────────────

class _CornerDot extends StatelessWidget {
  final AnimationController glowAnim;
  const _CornerDot({required this.glowAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnim,
      builder: (_, __) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF8060FF),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(
                  (100 + glowAnim.value * 100).toInt(), 100, 60, 255),
              blurRadius: 8 + glowAnim.value * 6,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
