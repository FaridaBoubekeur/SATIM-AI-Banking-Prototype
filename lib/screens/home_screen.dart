import 'package:flutter/material.dart';
import 'chatbot.dart';
import 'recharge_mobile.dart';
import 'ATM_centers.dart';
import 'card_details.dart';
import 'money_transfer.dart';
import 'profile_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4A4A4A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.apps,
            color: Colors.white,
          ),
        ),
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
            // Credit Card
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF4A4A4A),
                    Color(0xFF2A2A2A),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  // Background VISA watermark
                  Positioned(
                    right: -20,
                    top: 20,
                    child: Opacity(
                      opacity: 0.1,
                      child: Text(
                        'VISA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bank logo and name
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFE91E63),
                                    Color(0xFF2196F3),
                                    Color(0xFF4CAF50),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Dutch Bangla Bank',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Card number
                        const Text(
                          '**** **** **** 1690',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Card type and expiry
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Platinum',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Plus',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Exp 01/22',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'VISA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
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

            const SizedBox(height: 30),

            // Frequently Used section
            const Text(
              'Fréquemment Utilisées',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileRechargePage(),
                      ),
                    );
                  },
                  child: _buildFrequentlyUsedItem(
                    Icons.phone_android,
                    'Recharge\nMobile',
                    const Color(0xFF4CAF50),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Demo navigation - replace with actual BillPaymentPage when available
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileRechargePage(), // Demo only
                      ),
                    );
                  },
                  child: _buildFrequentlyUsedItem(
                    Icons.receipt_long,
                    'Paiement\nfactures',
                    const Color(0xFFD64341),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Demo navigation - replace with actual MoneyTransferPage when available
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileRechargePage(), // Demo only
                      ),
                    );
                  },
                  child: _buildFrequentlyUsedItem(
                    Icons.send,
                    'Virement\nbancaire',
                    const Color(0xFFFF9800),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Demo navigation - replace with actual RequestMoneyPage when available
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MobileRechargePage(), // Demo only
                      ),
                    );
                  },
                  child: _buildFrequentlyUsedItem(
                    Icons.monetization_on,
                    'Demander\nde l\'argent',
                    const Color(0xFFD64341),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Services section
            const Text(
              'Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _buildServiceCard(
                    Icons.account_balance,
                    'Ouvrir un\ncompte',
                    const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildServiceCard(
                    Icons.credit_card,
                    'Gérer les\ncartes',
                    const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BankingChatbotPage(),
            ),
          );
        },
        child: Container(
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
              _buildBottomNavItem(context, Icons.credit_card, true, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardDetailsPage(),
                  ),
                );
              }),
              _buildBottomNavItem(context, Icons.send, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MoneyTransferPage(),
                  ),
                );
              }),
              const SizedBox(width: 40), // Space for FAB
              _buildBottomNavItem(context, Icons.receipt, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ATMCentersPage(),
                  ),
                );
              }),
              _buildBottomNavItem(context, Icons.person_outline, false, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrequentlyUsedItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 120,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2A2A2A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
      BuildContext context, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: isActive ? const Color(0xFFD64341) : const Color(0xFF9E9E9E),
        size: 24,
      ),
    );
  }
}
