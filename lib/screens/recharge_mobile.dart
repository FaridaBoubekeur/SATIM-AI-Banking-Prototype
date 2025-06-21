import 'package:flutter/material.dart';
import 'verif_method.dart';

class MobileRechargePage extends StatefulWidget {
  @override
  _MobileRechargePageState createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargePage>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String selectedProvider = '';
  String? selectedProfileId;
  bool isProviderDropdownOpen = false;

  late AnimationController _profileAnimationController;
  late AnimationController _fieldAnimationController;

  final List<String> providers = ['Djezzy', 'Ooredoo', 'Mobilis'];

  final List<Map<String, dynamic>> profiles = [
    {
      'id': 'add',
      'name': 'Ajouter',
      'image': null,
      'phone': '',
      'provider': '',
      'amount': ''
    },
    {
      'id': 'yamilet',
      'name': 'Yamilet',
      'image': 'assets/yamllet.png',
      'phone': '0555 123 456',
      'provider': 'Djezzy',
      'amount': '500'
    },
    {
      'id': 'alexa',
      'name': 'Alexa',
      'image': 'assets/alexa.png',
      'phone': '0666 789 012',
      'provider': 'Ooredoo',
      'amount': '300'
    },
    {
      'id': 'yakub',
      'name': 'Yakub',
      'image': 'assets/yakub.png',
      'phone': '0777 345 678',
      'provider': 'Mobilis',
      'amount': '200'
    },
    {
      'id': 'krishna',
      'name': 'Krishna',
      'image': 'assets/krishna.png',
      'phone': '0888 901 234',
      'provider': 'Djezzy',
      'amount': '1000'
    }
  ];

  @override
  void initState() {
    super.initState();

    _profileAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fieldAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _profileAnimationController.dispose();
    _fieldAnimationController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _handleProfileSelection(Map<String, dynamic> profile) {
    if (profile['id'] == 'add') return;

    setState(() {
      selectedProfileId = profile['id'];
    });

    // Animation du profil sélectionné
    _profileAnimationController.forward().then((_) {
      _profileAnimationController.reverse();
    });

    // Animation des champs avec délais
    _fieldAnimationController.forward();

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _phoneController.text = profile['phone'];
      });
    });

    Future.delayed(Duration(milliseconds: 400), () {
      setState(() {
        selectedProvider = profile['provider'];
      });
    });

    Future.delayed(Duration(milliseconds: 600), () {
      setState(() {
        _amountController.text = profile['amount'];
      });
    });
  }

  void _handlePayment() {
    // Basic validation
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez entrer un numéro de téléphone',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (selectedProvider.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez sélectionner un opérateur',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez entrer un montant',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Navigate to VerificationMethodPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationMethodPage(),
      ),
    );
  }

  Widget _buildProfileAvatar(Map<String, dynamic> profile) {
    bool isSelected = selectedProfileId == profile['id'];
    bool isAddButton = profile['id'] == 'add';

    return GestureDetector(
      onTap: () => _handleProfileSelection(profile),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Color(0xFFE53E3E) : Colors.grey.shade300,
                  width: isSelected ? 3 : 2,
                ),
                color: isAddButton ? Colors.white : Colors.grey.shade100,
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Color(0xFFE53E3E).withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: isAddButton
                    ? Icon(
                        Icons.add,
                        color: Color(0xFFE53E3E),
                        size: 28,
                      )
                    : profile['image'] != null
                        ? Image.asset(
                            profile['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Colors.grey.shade600,
                                size: 32,
                              );
                            },
                          )
                        : Icon(
                            Icons.person,
                            color: Colors.grey.shade600,
                            size: 32,
                          ),
              ),
            ),
            Text(
              profile['name'],
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Color(0xFFE53E3E) : Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildProviderDropdown() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isProviderDropdownOpen = !isProviderDropdownOpen;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isProviderDropdownOpen
                    ? Color(0xFFE53E3E)
                    : Colors.grey.shade200,
                width: isProviderDropdownOpen ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedProvider.isEmpty
                          ? 'Sélectionner un opérateur'
                          : selectedProvider,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: selectedProvider.isEmpty
                            ? Colors.grey.shade500
                            : Colors.black87,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isProviderDropdownOpen ? 0.5 : 0,
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isProviderDropdownOpen ? null : 0,
          child: Container(
            margin: EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: isProviderDropdownOpen
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: providers.map((provider) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedProvider = provider;
                        isProviderDropdownOpen = false;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade100,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        provider,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // En-tête avec bouton retour et titre centré
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
                        colors: [Color(0xFFE53E3E), Color(0xFFD32F2F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFE53E3E).withOpacity(0.3),
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
                        'Recharge Mobile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 44), // Balance the back button
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),

                    // Section Envoyer à
                    Center(
                      child: Text(
                        'Envoyer à',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Avatars de profil
                    Container(
                      height: 110,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: profiles.map((profile) {
                              int index = profiles.indexOf(profile);
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 12),
                                child: _buildProfileAvatar(profile),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Formulaire
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Numéro de téléphone',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildTextField(
                          controller: _phoneController,
                          hintText: 'Entrez le numéro de téléphone',
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: 24),

                        Text(
                          'Opérateur',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildProviderDropdown(),

                        SizedBox(height: 24),

                        Text(
                          'Montant (DA)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        _buildTextField(
                          controller: _amountController,
                          hintText: 'Entrez le montant',
                          keyboardType: TextInputType.number,
                        ),

                        SizedBox(height: 40),

                        // Bouton Payer
                        Container(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFE53E3E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFE53E3E),
                                    Color(0xFFD32F2F)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'Payer',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}

// Note: Make sure you have imported your VerificationMethodPage
// import 'path/to/verification_method_page.dart';