import 'package:flutter/material.dart';
import 'dart:math' as math;

class ATMCentersPage extends StatefulWidget {
  const ATMCentersPage({Key? key}) : super(key: key);

  @override
  State<ATMCentersPage> createState() => _ATMCentersPageState();
}

class _ATMCentersPageState extends State<ATMCentersPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _mapController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _mapAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _mapController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _mapAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mapController,
      curve: Curves.elasticOut,
    ));

    _mapController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB85450),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Centres ATM',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                ),
                const SizedBox(width: 44), // Balance the back button
              ],
            ),
          ),

          // Map Section
          Expanded(
            flex: 3,
            child: AnimatedBuilder(
              animation: _mapAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _mapAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Animated background pattern
                          Positioned.fill(
                            child: CustomPaint(
                              painter: ModernMapPainter(_mapAnimation.value),
                            ),
                          ),

                          // Glassmorphism overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // ATM markers with animations
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 800 + (0 * 200)),
                            curve: Curves.elasticOut,
                            top: _mapAnimation.value * 80 + 20,
                            right: _mapAnimation.value * 100 + 50,
                            child: ATMMarker(
                              color: const Color(0xFFFF6B6B),
                              icon: Icons.account_balance,
                              label: 'DBS',
                              isActive: false,
                              animation: _mapAnimation,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 800 + (1 * 200)),
                            curve: Curves.elasticOut,
                            top: _mapAnimation.value * 140 + 40,
                            left: _mapAnimation.value * 80 + 30,
                            child: ATMMarker(
                              color: const Color(0xFF4ECDC4),
                              icon: Icons.atm,
                              label: 'NIB',
                              isActive: false,
                              animation: _mapAnimation,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 800 + (2 * 200)),
                            curve: Curves.elasticOut,
                            bottom: _mapAnimation.value * 120 + 40,
                            left: _mapAnimation.value * 70 + 20,
                            child: ATMMarker(
                              color: const Color(0xFFFFE66D),
                              icon: Icons.payment,
                              label: 'CITI',
                              isActive: false,
                              animation: _mapAnimation,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 800 + (3 * 200)),
                            curve: Curves.elasticOut,
                            top: _mapAnimation.value * 160 + 60,
                            right: _mapAnimation.value * 60 + 40,
                            child: ATMMarker(
                              color: const Color(0xFF95E1D3),
                              icon: Icons.credit_card,
                              label: 'ATM',
                              isActive: true,
                              animation: _mapAnimation,
                              pulseAnimation: _pulseAnimation,
                            ),
                          ),
                          AnimatedPositioned(
                            duration: Duration(milliseconds: 800 + (4 * 200)),
                            curve: Curves.elasticOut,
                            bottom: _mapAnimation.value * 100 + 30,
                            right: _mapAnimation.value * 120 + 60,
                            child: ATMMarker(
                              color: const Color(0xFFA8E6CF),
                              icon: Icons.local_atm,
                              label: 'FSB',
                              isActive: false,
                              animation: _mapAnimation,
                            ),
                          ),

                          // Floating location button
                          Positioned(
                            top: 16,
                            right: 16,
                            child: AnimatedScale(
                              scale: _mapAnimation.value,
                              duration: const Duration(milliseconds: 600),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  color: Color(0xFF667eea),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bank List Section
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: const [
                  BankListItem(
                    logo: 'assets/dbs_logo.png',
                    bankName: 'DBS Bank',
                    address: '72, Gotham Road, New York.',
                    distance: '1.3 KM',
                  ),
                  BankListItem(
                    logo: 'assets/nib_logo.png',
                    bankName: 'NIB Bank',
                    address: '72, Gotham Road, New York.',
                    distance: '2.2 KM',
                  ),
                  BankListItem(
                    logo: 'assets/citi_logo.png',
                    bankName: 'Citi Bank',
                    address: '72, Gotham Road, New York.',
                    distance: '3.4 KM',
                  ),
                  BankListItem(
                    logo: 'assets/fsb_logo.png',
                    bankName: 'FSB Bank',
                    address: '72, Gotham Road, New York.',
                    distance: '1.1 KM',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ATMMarker extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final bool isActive;
  final Animation<double> animation;
  final Animation<double>? pulseAnimation;

  const ATMMarker({
    Key? key,
    required this.color,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.animation,
    this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnimation ?? animation,
      builder: (context, child) {
        final pulseValue = pulseAnimation?.value ?? 0.0;
        final scale = isActive ? 1.0 + (pulseValue * 0.3) : 1.0;

        return Transform.scale(
          scale: scale * animation.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse rings for active marker
                  if (isActive && pulseAnimation != null) ...[
                    Container(
                      width: 60 + (pulseValue * 20),
                      height: 60 + (pulseValue * 20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withOpacity(0.3 - (pulseValue * 0.3)),
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 40 + (pulseValue * 10),
                      height: 40 + (pulseValue * 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.2 - (pulseValue * 0.2)),
                      ),
                    ),
                  ],

                  // Main marker
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color,
                          color.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          spreadRadius: 0,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ModernMapPainter extends CustomPainter {
  final double animationValue;

  ModernMapPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Dynamic gradient background
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF667eea).withOpacity(0.1),
          const Color(0xFF764ba2).withOpacity(0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Animated grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1 * animationValue)
      ..strokeWidth = 1.0;

    const spacing = 40.0;

    // Animated grid lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
          Offset(x, 0), Offset(x, size.height * animationValue), gridPaint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
          Offset(0, y), Offset(size.width * animationValue, y), gridPaint);
    }

    // Dynamic flowing paths
    final pathPaint = Paint()
      ..color = Colors.white.withOpacity(0.2 * animationValue)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Animated flowing river/road
    final path1 = Path();
    path1.moveTo(0, size.height * 0.3);
    path1.quadraticBezierTo(
      size.width * 0.3 * animationValue,
      size.height * 0.1,
      size.width * animationValue,
      size.height * 0.4,
    );
    canvas.drawPath(path1, pathPaint);

    final path2 = Path();
    path2.moveTo(size.width * 0.2, 0);
    path2.quadraticBezierTo(
      size.width * 0.6 * animationValue,
      size.height * 0.6,
      size.width * 0.9 * animationValue,
      size.height,
    );
    canvas.drawPath(path2, pathPaint);

    // Floating geometric shapes
    final shapePaint = Paint()
      ..color = Colors.white.withOpacity(0.05 * animationValue);

    // Animated circles
    for (int i = 0; i < 5; i++) {
      final x =
          (size.width / 5) * i + (math.sin(animationValue * math.pi + i) * 20);
      final y =
          (size.height / 3) + (math.cos(animationValue * math.pi + i) * 30);
      canvas.drawCircle(
        Offset(x, y),
        15 + (math.sin(animationValue * math.pi * 2 + i) * 5),
        shapePaint,
      );
    }

    // Connection lines between points
    final connectionPaint = Paint()
      ..color = Colors.white.withOpacity(0.1 * animationValue)
      ..strokeWidth = 1.0;

    // Draw connecting lines
    for (int i = 0; i < 4; i++) {
      final startX = (size.width / 5) * i;
      final startY = (size.height / 3);
      final endX = (size.width / 5) * (i + 1);
      final endY = (size.height / 3) + 50;

      canvas.drawLine(
        Offset(startX * animationValue, startY),
        Offset(endX * animationValue, endY),
        connectionPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BankListItem extends StatelessWidget {
  final String logo;
  final String bankName;
  final String address;
  final String distance;

  const BankListItem({
    Key? key,
    required this.logo,
    required this.bankName,
    required this.address,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: Image.asset(
              logo,
              width: 32,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            distance,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D2D2D),
            ),
          ),
        ],
      ),
    );
  }
}
