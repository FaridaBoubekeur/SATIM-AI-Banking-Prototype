import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:convert'; // For JSON parsing
import 'package:http/http.dart' as http; // To make HTTP requests
import 'dart:async'; // Add this line
import 'dart:io';

class BankingChatbotPage extends StatefulWidget {
  @override
  _BankingChatbotPageState createState() => _BankingChatbotPageState();
}

class _BankingChatbotPageState extends State<BankingChatbotPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isTyping = false;
  late AnimationController _pulseController;

  // Animation controllers for mic button
  late AnimationController _micPulseController;
  late AnimationController _rippleController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _micPulseAnimation;

  // GEMINI API Configuration
  static const String GEMINI_API_KEY =
      'AIzaSyD719uhCSCFsV9X-Qykc_Js6vLdAhlzU8w'; // Replace with your actual API key
  static const String GEMINI_API_URL =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // USER DATA SIMULATION
  final UserBankingData _userData = UserBankingData();

  // Suggestions bancaires
  final List<String> _bankingSuggestions = [
    "Mon solde",
    "Payer factures",
    "Virement express",
    "Historique",
    "Recharge mobile",
    "Mes cartes"
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _addWelcomeMessages();
    _checkAccountStatus(); // Check for low balance and upcoming payments
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _micPulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _micPulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _micPulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _addWelcomeMessages() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(ChatMessage(
          text:
              "Bonjour ${_userData.userName} ! 👋\nJe suis votre assistant SATIM, votre passerelle de paiement électronique interbancaire. Comment puis-je vous aider avec vos paiements aujourd'hui ?",
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  void _checkAccountStatus() {
    Future.delayed(Duration(milliseconds: 2000), () {
      // Check for low balance warning
      if (_userData.accountBalance < 10000) {
        setState(() {
          _messages.add(ChatMessage(
            text:
                "⚠️ Attention : Votre solde est faible (${_userData.accountBalance.toStringAsFixed(0)} DA). Vous avez des factures à payer ce mois-ci.",
            isUser: false,
            timestamp: DateTime.now(),
            isWarning: true,
          ));
        });
      }

      // Check for upcoming automatic transactions
      _checkUpcomingTransactions();
    });
  }

  void _checkUpcomingTransactions() {
    Future.delayed(Duration(milliseconds: 3500), () {
      setState(() {
        _messages.add(ChatMessage(
          text:
              "💡 Rappel : Vous envoyez habituellement 50 000 DA à votre sœur ce week-end. Voulez-vous que je prépare le virement ?",
          isUser: false,
          timestamp: DateTime.now(),
          isReminder: true,
        ));
      });
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _micPulseController.dispose();
    _rippleController.dispose();
    _scaleController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Enhanced Gemini API with banking context and user data
  Future<String> fetchGeminiResponse(String userInput) async {
    // Check if it's a banking command first
    String? bankingResponse = _handleBankingCommands(userInput);
    if (bankingResponse != null) {
      return bankingResponse;
    }

    try {
      final url = Uri.parse('$GEMINI_API_URL?key=$GEMINI_API_KEY');

      // Improved banking context - concise and focused
      final String bankingContext = """
Tu es l'assistant de paiement SATIM pour ${_userData.userName}. SATIM est l'opérateur de paiement électronique interbancaire d'Algérie qui connecte 17 institutions financières (16 banques + Algérie Poste).

DONNÉES CLIENT:
- Solde: ${_userData.accountBalance.toStringAsFixed(0)} DA
- Limite transfert: ${_userData.dailyTransferLimit.toStringAsFixed(0)} DA
- Factures en attente: ${_userData.pendingBills.length}

RÔLE SATIM:
- Facilite les paiements électroniques entre banques
- Gère les cartes CIB et EDDAHABIA
- Traite les paiements en ligne et virements interbancaires
- Connecte tous les services bancaires algériens

RÈGLES DE RÉPONSE:
1. Sois bref et précis (max 2-3 phrases)
2. Rappelle que SATIM traite via votre banque
3. Pour les urgences (solde <10000 DA, factures échues), alerte brièvement
4. Propose des actions concrètes plutôt que des explications
5. Utilise des emojis appropriés (💰 🚨 ✅ ❌)

CONTEXTE ACTUEL:
${_getUserContextSummary()}

Question: $userInput

Réponds directement sans préambule.
""";

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": bankingContext}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.3, // Reduced for more consistent, focused responses
          "topK": 20,
          "topP": 0.8,
          "maxOutputTokens": 200, // Reduced to encourage concise responses
        },
        "safetySettings": [
          {
            "category": "HARM_CATEGORY_HARASSMENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_HATE_SPEECH",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          },
          {
            "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
            "threshold": "BLOCK_MEDIUM_AND_ABOVE"
          }
        ]
      };

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(requestBody),
          )
          .timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          String responseText =
              data['candidates'][0]['content']['parts'][0]['text'];
          return responseText.trim();
        }
      }
      return "Désolé, je n'ai pas pu traiter votre demande.";
    } catch (e) {
      return "Erreur de connexion. Veuillez réessayer.";
    }
  }

  String _getUserContextSummary() {
    List<String> contextItems = [];

    // Add critical alerts only
    if (_userData.accountBalance < 10000) {
      contextItems.add("🚨 Solde faible");
    }

    // Add urgent bills only
    var urgentBills = _userData.pendingBills
        .where((bill) => bill.dueDate.difference(DateTime.now()).inDays <= 3);
    if (urgentBills.isNotEmpty) {
      contextItems.add("⏰ ${urgentBills.length} facture(s) urgente(s)");
    }

    // Add recent recurring transaction reminder
    var upcomingRecurring = _userData.recurringTransactions.where(
        (transaction) =>
            transaction.nextDate.difference(DateTime.now()).inDays <= 2);
    if (upcomingRecurring.isNotEmpty) {
      contextItems.add("🔄 Virement habituel prévu");
    }

    return contextItems.isEmpty ? "Aucune alerte" : contextItems.join(" | ");
  }

  // Enhanced command handling with better categorization
  String? _handleBankingCommands(String input) {
    String lowerInput = input.toLowerCase().trim();

    // Quick balance check
    if (_isBalanceQuery(lowerInput)) {
      return "💰 ${_userData.accountBalance.toStringAsFixed(0)} DA";
    }

    // Bill payment commands
    if (_isBillPaymentQuery(lowerInput)) {
      return _handleBillPayment(lowerInput);
    }

    // Transfer commands
    if (_isTransferQuery(lowerInput)) {
      return _handleTransfer(lowerInput);
    }

    // Mobile recharge
    if (_isMobileRechargeQuery(lowerInput)) {
      return _handleMobileRecharge();
    }

    // Transaction history
    if (_isHistoryQuery(lowerInput)) {
      return _getTransactionHistory();
    }

    // Help/guidance
    if (_isHelpQuery(lowerInput)) {
      return _getQuickHelp();
    }

    return null; // Let Gemini handle other queries
  }

// Helper methods for better intent recognition
  bool _isBalanceQuery(String input) {
    List<String> balanceKeywords = ['solde', 'combien', 'argent', 'compte'];
    return balanceKeywords.any((keyword) => input.contains(keyword));
  }

  bool _isBillPaymentQuery(String input) {
    List<String> billKeywords = [
      'facture',
      'payer',
      'électricité',
      'eau',
      'internet'
    ];
    return billKeywords.any((keyword) => input.contains(keyword));
  }

  bool _isTransferQuery(String input) {
    List<String> transferKeywords = [
      'virement',
      'envoyer',
      'transférer',
      'sœur',
      'famille'
    ];
    return transferKeywords.any((keyword) => input.contains(keyword));
  }

  bool _isMobileRechargeQuery(String input) {
    List<String> rechargeKeywords = [
      'recharge',
      'mobile',
      'téléphone',
      'crédit'
    ];
    return rechargeKeywords.any((keyword) => input.contains(keyword));
  }

  bool _isHistoryQuery(String input) {
    List<String> historyKeywords = [
      'historique',
      'transactions',
      'dernières',
      'récent'
    ];
    return historyKeywords.any((keyword) => input.contains(keyword));
  }

  bool _isHelpQuery(String input) {
    List<String> helpKeywords = ['aide', 'comment', 'puis-je', 'que faire'];
    return helpKeywords.any((keyword) => input.contains(keyword));
  }

  String _getQuickHelp() {
    return "💡 Actions rapides :\n"
        "• \"Mon solde\" - Consulter votre compte\n"
        "• \"Payer factures\" - Régler vos factures\n"
        "• \"Virement\" - Transférer de l'argent\n"
        "• \"Recharge mobile\" - Recharger votre téléphone";
  }

  String _handleBillPayment(String input) {
    if (input.contains('électricité')) {
      return _payBill('Facture d\'électricité', 8500);
    } else if (input.contains('eau')) {
      return _payBill('Facture d\'eau', 3200);
    } else if (input.contains('internet')) {
      return _payBill('Facture internet', 4500);
    } else {
      return "💡 Factures disponibles à payer:\n\n" +
          _userData.pendingBills
              .map((bill) =>
                  "• ${bill.description}: ${bill.amount.toStringAsFixed(0)} DA (Échéance: ${bill.dueDate.day}/${bill.dueDate.month})")
              .join('\n') +
          "\n\nDites-moi quelle facture vous voulez payer.";
    }
  }

  String _payBill(String billName, double amount) {
    if (_userData.accountBalance >= amount) {
      _userData.accountBalance -= amount;
      _userData.recentTransactions.insert(
          0,
          Transaction(
              description: billName,
              amount: -amount,
              date: DateTime.now(),
              type: 'Paiement'));

      // Remove from pending bills
      _userData.pendingBills.removeWhere(
          (bill) => bill.description.contains(billName.split(' ')[1]));

      return "✅ Paiement effectué avec succès!\n\n"
          "$billName: ${amount.toStringAsFixed(0)} DA\n"
          "Nouveau solde: ${_userData.accountBalance.toStringAsFixed(0)} DA\n\n"
          "🔐 Vérification requise: Code reçu par SMS";
    } else {
      return "❌ Solde insuffisant pour payer $billName (${amount.toStringAsFixed(0)} DA)\n"
          "Solde actuel: ${_userData.accountBalance.toStringAsFixed(0)} DA\n\n"
          "💡 Vous pouvez effectuer un virement depuis votre compte épargne.";
    }
  }

  String _handleMobileRecharge() {
    return "📱 Recharge mobile rapide:\n\n"
        "• 500 DA - 5 GB + 100 min\n"
        "• 1000 DA - 12 GB + 200 min\n"
        "• 2000 DA - 25 GB + 500 min\n\n"
        "Choisissez le montant ou dites 'recharge habituelle' pour 1000 DA.";
  }

  String _handleTransfer(String input) {
    if (input.contains('sœur') || input.contains('soeur')) {
      return _processTransfer('Virement à votre sœur', 50000);
    } else {
      return "💸 Virement express:\n\n"
          "Pour qui voulez-vous faire un virement?\n"
          "• Famille (contacts enregistrés)\n"
          "• Nouveau bénéficiaire\n"
          "• Virement interne\n\n"
          "Limite journalière: ${_userData.dailyTransferLimit.toStringAsFixed(0)} DA";
    }
  }

  String _processTransfer(String description, double amount) {
    if (_userData.accountBalance >= amount) {
      if (amount <= _userData.dailyTransferLimit) {
        _userData.accountBalance -= amount;
        _userData.recentTransactions.insert(
            0,
            Transaction(
                description: description,
                amount: -amount,
                date: DateTime.now(),
                type: 'Virement'));

        return "✅ Virement préparé avec succès!\n\n"
            "$description: ${amount.toStringAsFixed(0)} DA\n"
            "Nouveau solde: ${_userData.accountBalance.toStringAsFixed(0)} DA\n\n"
            "🔐 Confirmez avec votre code PIN pour finaliser.";
      } else {
        return "❌ Montant supérieur à votre limite journalière (${_userData.dailyTransferLimit.toStringAsFixed(0)} DA)";
      }
    } else {
      return "❌ Solde insuffisant pour ce virement\n"
          "Montant demandé: ${amount.toStringAsFixed(0)} DA\n"
          "Solde actuel: ${_userData.accountBalance.toStringAsFixed(0)} DA";
    }
  }

  String _getTransactionHistory() {
    return "📊 Historique des transactions récentes:\n\n" +
        _userData.recentTransactions
            .take(5)
            .map((transaction) =>
                "${transaction.type}: ${transaction.description}\n"
                "${transaction.amount > 0 ? '+' : ''}${transaction.amount.toStringAsFixed(0)} DA\n"
                "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}\n")
            .join('\n') +
        "\n💡 Consultez l'app pour l'historique complet.";
  }

  String _getAccountStatus() {
    int pendingCount = _userData.pendingBills.length;
    int recurringCount = _userData.recurringTransactions.length;

    return "📋 Statut de votre compte:\n\n"
        "💰 Solde: ${_userData.accountBalance.toStringAsFixed(0)} DA\n"
        "🏷️ Type: ${_userData.accountType}\n"
        "✅ Statut: ${_userData.accountStatus}\n"
        "📅 Factures en attente: $pendingCount\n"
        "🔄 Transactions auto: $recurringCount\n"
        "💳 Limite journalière: ${_userData.dailyTransferLimit.toStringAsFixed(0)} DA";
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    final responseText = await fetchGeminiResponse(text);

    setState(() {
      _isTyping = false;
      _messages.add(ChatMessage(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      _micPulseController.repeat();
      _rippleController.repeat();
    } else {
      _micPulseController.stop();
      _rippleController.stop();
    }

    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    if (_isListening) {
      Future.delayed(Duration(seconds: 3), () {
        if (_isListening) {
          setState(() {
            _isListening = false;
          });
          _micPulseController.stop();
          _rippleController.stop();
          _sendMessage("Mon solde");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFD14A3C),
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assistant SATIM",
                  style: TextStyle(
                    color: Color(0xFF2D3748),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Paiements via votre banque",
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Color(0xFF2D3748)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    message.isWarning ? Color(0xFFFF9800) : Color(0xFF6B7AED),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(message.isWarning ? Icons.warning : Icons.smart_toy,
                  color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? Color(0xFFD14A3C)
                        : message.isReminder
                            ? Color(0xFFFFF3CD)
                            : message.isWarning
                                ? Color(0xFFFFEBEE)
                                : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: message.isReminder
                        ? Border.all(color: Color(0xFFE6A700), width: 1)
                        : message.isWarning
                            ? Border.all(color: Color(0xFFFF9800), width: 1)
                            : null,
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white
                          : message.isReminder
                              ? Color(0xFF8B6914)
                              : message.isWarning
                                  ? Color(0xFFD32F2F)
                                  : Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFD14A3C),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFF6B7AED),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.smart_toy, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                SizedBox(width: 4),
                _buildDot(1),
                SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Color(0xFF6B7AED).withOpacity(
              0.3 +
                  0.7 *
                      (0.5 +
                          0.5 *
                              math.sin(_pulseController.value * 2 * math.pi +
                                  index * 0.5)),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_messages.length <= 3) ...[
            Text(
              "Actions rapides :",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _bankingSuggestions.map((suggestion) {
                return GestureDetector(
                  onTap: () => _sendMessage(suggestion),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD14A3C)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: Color(0xFFD14A3C),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
          ],
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Demandez-moi quelque chose...",
                      hintStyle: TextStyle(
                        color: Color(0xFFA0AEC0),
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: _startListening,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    _micPulseController,
                    _rippleController,
                    _scaleController,
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color:
                              _isListening ? Color(0xFFD14A3C) : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: _isListening
                                  ? Color(0xFFD14A3C).withOpacity(0.4)
                                  : Color(0xFF000000).withOpacity(0.1),
                              blurRadius: _isListening ? 15 : 5,
                              spreadRadius: _isListening ? 1 : 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.mic,
                          color:
                              _isListening ? Colors.white : Color(0xFFD14A3C),
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                onTap: () => _sendMessage(_messageController.text),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFFD14A3C),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isReminder;
  final bool isWarning;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isReminder = false,
    this.isWarning = false,
  });
}

// USER DATA MODELS
class UserBankingData {
  String userName = "Ahmed Benali";
  String accountNumber = "001234567890";
  String accountType = "Compte Courant";
  String accountStatus = "Actif";
  double accountBalance = 125750.0;
  double dailyTransferLimit = 200000.0;

  List<Transaction> recentTransactions = [
    Transaction(
        description: "Virement reçu de Karim",
        amount: 25000.0,
        date: DateTime.now().subtract(Duration(days: 1)),
        type: "Crédit"),
    Transaction(
        description: "Paiement facture électricité",
        amount: -8500.0,
        date: DateTime.now().subtract(Duration(days: 2)),
        type: "Paiement"),
    Transaction(
        description: "Retrait DAB",
        amount: -15000.0,
        date: DateTime.now().subtract(Duration(days: 3)),
        type: "Retrait"),
    Transaction(
        description: "Salaire mensuel",
        amount: 180000.0,
        date: DateTime.now().subtract(Duration(days: 5)),
        type: "Crédit"),
    Transaction(
        description: "Achat en ligne",
        amount: -12500.0,
        date: DateTime.now().subtract(Duration(days: 7)),
        type: "Achat"),
  ];

  List<PendingBill> pendingBills = [
    PendingBill(
        description: "Facture d'électricité",
        amount: 8500.0,
        dueDate: DateTime.now().add(Duration(days: 5)),
        category: "Utilities"),
    PendingBill(
        description: "Facture d'eau",
        amount: 3200.0,
        dueDate: DateTime.now().add(Duration(days: 8)),
        category: "Utilities"),
    PendingBill(
        description: "Facture internet",
        amount: 4500.0,
        dueDate: DateTime.now().add(Duration(days: 12)),
        category: "Telecom"),
    PendingBill(
        description: "Assurance voiture",
        amount: 15000.0,
        dueDate: DateTime.now().add(Duration(days: 15)),
        category: "Insurance"),
  ];

  List<RecurringTransaction> recurringTransactions = [
    RecurringTransaction(
        description: "Virement mensuel à maman",
        amount: 30000.0,
        frequency: "Mensuel",
        nextDate: DateTime.now().add(Duration(days: 10))),
    RecurringTransaction(
        description: "Virement hebdomadaire à sœur",
        amount: 50000.0,
        frequency: "Hebdomadaire",
        nextDate: DateTime.now().add(Duration(days: 2))),
    RecurringTransaction(
        description: "Épargne automatique",
        amount: 20000.0,
        frequency: "Mensuel",
        nextDate: DateTime.now().add(Duration(days: 20))),
  ];
}

class Transaction {
  final String description;
  final double amount;
  final DateTime date;
  final String type;

  Transaction({
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}

class PendingBill {
  final String description;
  final double amount;
  final DateTime dueDate;
  final String category;

  PendingBill({
    required this.description,
    required this.amount,
    required this.dueDate,
    required this.category,
  });
}

class RecurringTransaction {
  final String description;
  final double amount;
  final String frequency;
  final DateTime nextDate;

  RecurringTransaction({
    required this.description,
    required this.amount,
    required this.frequency,
    required this.nextDate,
  });
}
