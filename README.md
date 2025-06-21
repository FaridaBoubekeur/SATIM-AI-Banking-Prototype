# SATIM AI-Banking Prototype

**Next-gen mobile banking MVP for SATIM Hackathon**  
AI-powered, secure, and predictive—built for the future of digital finance on Algeria’s national rails.

---

## 🚀 Overview

This project is a hackathon prototype for a conversational, predictive, and secure mobile banking platform, powered by SATIM’s payments infrastructure and the latest AI models.

**Key Features (current & planned):**
- Conversational banking chatbot (Gemini-powered) 🗣️
- Secure biometric (FaceID) and phone (OTP) login
- Fast domestic money transfer
- ATM locator and live queue insights
- Mobile recharge and card management
- Fraud detection (ML-based prototype)
- Predictive reminders and suggestions *(planned)*
- Cardless ATM, panic mode, and more *(planned)*

---

## 🏗️ Architecture

- **Front-End:** Flutter app (Dart) — modular, secure, cross-platform
- **AI/ML:** Gemini API for chatbot, custom ML for fraud detection (see `ml_models/`)
- **Back-End:** [Demo only] Direct calls to SATIM endpoints and ML services (expandable)
- **Security:** FaceID, OTP, JWT tokens, local encrypted storage (planned)

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for full technical write-up.

---

## ⚡ Quick Start

1. **Clone this repo:**
   ```sh
   git clone https://github.com/<your-username>/satim-ai-banking-prototype.git
   cd satim-ai-banking-prototype/mobile_app
Install dependencies:
flutter pub get
Add your Gemini API key:
Get a Google Gemini API key
Create a .env file in mobile_app/:
GEMINI_API_KEY=your-key-here
The chatbot will not work without this!
Run the app:
flutter run
(Optional)
To try the fraud detection model, see ml_models/Fraud_detection_Main.ipynb.

## 🛠️ Feature Status

- Feature	Status	File(s)
- Home Screen	✅ Done	home_screen.dart
- Card Management	✅ Done	card_details.dart
- ATM Map/Locator	✅ Demo	ATM_centers.dart
- Money Transfer	✅ Demo	money_transfer.dart
- Chatbot (Gemini)	✅ Demo	chatbot.dart
- FaceID/Phone Verification	✅ Demo	faceid_verif.dart, phone_verif.dart
- Fraud Detection (ML)	🟡 Prototype	ml_models/Fraud_detection_Main.ipynb
- Voice Assistant	⬜ Planned	
- Notifications	⬜ Planned	
- Secure Storage	⬜ Planned	
- Panic Mode	⬜ Planned	
- Spending Insights/Extras	⬜ Planned	

## 👥 Team Pandas

- Boubekeur Farida
- Djaid Douaa
- Medjri Yasmina
- Chaoui Maab

## 📄 Documentation

- ARCHITECTURE.md – Technical write-up, stack, data flow, and roadmap
- ml_models/README.md – Running and understanding the ML prototype

## 🔒 Security & Compliance

- Biometric authentication (FaceID)
- OTP fallback
- No sensitive data stored in repo
- [Planned] Full local encryption and GDPR-style export/erase

## ⚠️ Notes

- You must provide your own Gemini API key for chatbot functionality.
- This is a hackathon MVP. Many features are planned or stubbed.
- For questions or demo requests, contact the team via GitHub Issues.
- Proudly built for the SATIM Hackathon – let’s make Algerian fintech world-class!
