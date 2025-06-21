import 'package:flutter/material.dart';

class CardDetailsPage extends StatefulWidget {
  const CardDetailsPage({Key? key}) : super(key: key);

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  int selectedPeriod = 1; // 0: Jour, 1: Mois, 2: Annuel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Détails de la carte',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8E8E8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Solde actuel',
                    style: TextStyle(
                      color: Color(0xFFD64341),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '30,567',
                          style: TextStyle(
                            color: Color(0xFFD64341),
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' DZD',
                          style: TextStyle(
                            color: Color(0xFFD64341),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Period Selection
            Row(
              children: [
                Expanded(
                  child: _buildPeriodButton('Jour', 0),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPeriodButton('Mois', 1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPeriodButton('Annuel', 2),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Chart
            Container(
              height: 250,
              child: Column(
                children: [
                  // Y-axis labels and chart
                  Expanded(
                    child: Row(
                      children: [
                        // Y-axis labels
                        Container(
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('30k dzd',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                              Text('20k dzd',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                              Text('10k dzd',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                              Text('0 dzd',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 10)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Chart area
                        Expanded(
                          child: CustomPaint(
                            painter: LineChartPainter(),
                            child: Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // X-axis labels
                  Padding(
                    padding: const EdgeInsets.only(left: 68),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Jan',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Feb',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Mar',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Apr',
                            style: TextStyle(
                                color: Color(0xFFD64341),
                                fontWeight: FontWeight.w600,
                                fontSize: 12)),
                        Text('May',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                        Text('Jun',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Data point annotation
            Container(
              margin: const EdgeInsets.only(left: 160, top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '-9,100',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Transaction History
            const Text(
              'Historique des transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),

            const SizedBox(height: 20),

            // Transaction Items
            _buildTransactionItem(
              Icons.arrow_outward,
              'Course Yassir',
              '27-Apr | 08:25pm',
              '-574.00',
              Colors.red,
            ),

            const SizedBox(height: 16),

            _buildTransactionItem(
              Icons.arrow_downward,
              'Argent reçu',
              '25-Apr | 10:50am',
              '+ 2047.00',
              Colors.blue,
            ),

            const SizedBox(height: 16),

            _buildTransactionItem(
              Icons.shopping_cart,
              'Analyses pop',
              '24-Apr | 02:15pm',
              '-125.50',
              Colors.orange,
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFD64341),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.support_agent,
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 8,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.credit_card, true),
              _buildBottomNavItem(Icons.send, false),
              const SizedBox(width: 40), // Space for FAB
              _buildBottomNavItem(Icons.receipt, false),
              _buildBottomNavItem(Icons.person_outline, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String title, int index) {
    bool isSelected = selectedPeriod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD64341) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(IconData icon, String title, String subtitle,
      String amount, Color iconColor) {
    bool isPositive = amount.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2A2A2A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isPositive ? Colors.green : const Color(0xFF2A2A2A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, bool isActive) {
    return Icon(
      icon,
      color: isActive ? const Color(0xFFD64341) : const Color(0xFF9E9E9E),
      size: 24,
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Chart data points (normalized to chart area)
    final List<Offset> points = [
      Offset(0, size.height * 0.6), // 12k
      Offset(size.width * 0.2, size.height * 0.5), // 15k
      Offset(size.width * 0.4, size.height * 0.4), // 18k
      Offset(size.width * 0.6, size.height * 0.67), // 10k (lowest point)
      Offset(size.width * 0.8, size.height * 0.47), // 16k
      Offset(size.width, size.height * 0.17), // 25k
    ];

    // Draw horizontal grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 3; i++) {
      double y = (size.height / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw gradient fill under the curve
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFD64341).withOpacity(0.15),
          const Color(0xFFD64341).withOpacity(0.03),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Create path for gradient fill
    final fillPath = Path();
    fillPath.moveTo(points.first.dx, size.height);
    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      final controlPoint1 = Offset(
        currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.5,
        currentPoint.dy,
      );
      final controlPoint2 = Offset(
        currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.5,
        nextPoint.dy,
      );

      if (i == 0) {
        fillPath.lineTo(currentPoint.dx, currentPoint.dy);
      }
      fillPath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        nextPoint.dx,
        nextPoint.dy,
      );
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, gradientPaint);

    // Draw the curved line
    final linePaint = Paint()
      ..color = const Color(0xFFD64341)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      final controlPoint1 = Offset(
        currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.5,
        currentPoint.dy,
      );
      final controlPoint2 = Offset(
        currentPoint.dx + (nextPoint.dx - currentPoint.dx) * 0.5,
        nextPoint.dy,
      );

      linePath.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        nextPoint.dx,
        nextPoint.dy,
      );
    }
    canvas.drawPath(linePath, linePaint);

    // Draw data points
    final dotPaint = Paint()
      ..color = const Color(0xFFD64341)
      ..style = PaintingStyle.fill;

    final highlightDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final highlightBorderPaint = Paint()
      ..color = const Color(0xFFD64341)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < points.length; i++) {
      if (i == 3) {
        // Highlight the April point (index 3)
        canvas.drawCircle(points[i], 6, highlightDotPaint);
        canvas.drawCircle(points[i], 6, highlightBorderPaint);
      } else {
        canvas.drawCircle(points[i], 3, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
