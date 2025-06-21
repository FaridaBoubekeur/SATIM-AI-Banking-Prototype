import 'package:flutter/material.dart';
import 'dart:async';

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage>
    with TickerProviderStateMixin {
  List<String> code = ['', '', '', ''];
  int currentIndex = 0;
  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  Timer? _timer;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));

    _animationController.forward();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shakeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onNumberPressed(String number) {
    if (currentIndex < 4) {
      setState(() {
        code[currentIndex] = number;
        currentIndex++;
      });

      if (currentIndex == 4) {
        _verifyCode();
      }
    }
  }

  void _onBackspacePressed() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        code[currentIndex] = '';
      });
    }
  }

  void _verifyCode() {
    // Simulate verification
    Future.delayed(Duration(milliseconds: 500), () {
      if (code.join() == '1234') {
        // Success
        Navigator.pop(context);
      } else {
        // Error - shake animation
        _shakeController.forward().then((_) {
          _shakeController.reverse();
          setState(() {
            code = ['', '', '', ''];
            currentIndex = 0;
          });
        });
      }
    });
  }

  Widget _buildCodeInput(int index) {
    bool isActive = index == currentIndex;
    bool isFilled = code[index].isNotEmpty;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset:
              Offset(_shakeAnimation.value * 10 * (index % 2 == 0 ? 1 : -1), 0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 50,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color:
                  isFilled ? Color(0xFFD64341).withOpacity(0.1) : Colors.white,
              border: Border.all(
                color: isActive
                    ? Color(0xFFD64341)
                    : isFilled
                        ? Color(0xFFD64341).withOpacity(0.5)
                        : Colors.grey.shade300,
                width: isActive ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Color(0xFFD64341).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                code[index],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isFilled ? Color(0xFFE57373) : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberButton(String number) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.all(4),
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => _onNumberPressed(number),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE57373), Color(0xFFEF5350)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE57373).withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Phone Verification',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      // Instructions
                      FadeTransition(
                        opacity: _animationController,
                        child: Column(
                          children: [
                            Text(
                              'Please enter the 4-digit code sent to you at',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '+61 44 535 235',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // Code input
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(4, (index) => _buildCodeInput(index)),
                      ),

                      SizedBox(height: 24),

                      // Resend code
                      TextButton(
                        onPressed: _resendCountdown == 0
                            ? () {
                                setState(() {
                                  _resendCountdown = 30;
                                });
                                _startResendTimer();
                              }
                            : null,
                        child: Text(
                          _resendCountdown > 0
                              ? 'Resend Code ($_resendCountdown)'
                              : 'Resend Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _resendCountdown == 0
                                ? Color(0xFFE57373)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Number pad
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                _buildNumberButton('1'),
                                _buildNumberButton('2'),
                                _buildNumberButton('3'),
                              ],
                            ),
                            Row(
                              children: [
                                _buildNumberButton('4'),
                                _buildNumberButton('5'),
                                _buildNumberButton('6'),
                              ],
                            ),
                            Row(
                              children: [
                                _buildNumberButton('7'),
                                _buildNumberButton('8'),
                                _buildNumberButton('9'),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(child: Container(height: 65)),
                                _buildNumberButton('0'),
                                Flexible(
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    height: 65,
                                    child: Material(
                                      elevation: 0,
                                      borderRadius: BorderRadius.circular(16),
                                      child: InkWell(
                                        onTap: _onBackspacePressed,
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: Colors.grey.shade200),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 8,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.backspace_outlined,
                                              color: Colors.grey.shade600,
                                              size: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
