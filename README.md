# Ykt Hub

**Ykt Hub** is a mobile application and Telegram bot designed for residents of Yakutsk and the Russian Far East.  
The project combines city and regional services into a single, convenient tool.

---

## Project Highlights

- Extreme North & Arctic Conditions — weather forecasts account for harsh northern climate.
- Telegram Bot — provides instant access to weather, currency rates, ferries, flights, and news; helps users interact with Ykt Hub even without opening the app.
- Ferries across Lena River — schedules for the world's widest river, a unique local feature.
- Currencies — Chinese Yuan reflected as primary currency for the Far East.
- Flights & Tickets — sorting for subsidized flights, checks residency documents.
- Weather Visuals — animated snow and stars in the 5-day forecast block.

---

## Project Structure


YktHub/
├── flutter_app/ # Flutter mobile application
│ ├── lib/ # Dart code
│ ├── assets/ # Images, icons, fonts
│ └── pubspec.yaml # Flutter project configuration
├── backend/ # Mini-backend providing API for bot and Flutter app
│ └── api.py
├── bot/ # Telegram bot (Python + Aiogram)
│ ├── main.py
│ ├── handlers/ # Bot command handlers
│ ├── keyboards/ # Reply keyboards
│ └── requirements.txt # Python dependencies
├── .gitignore
└── README.md


---

## Technologies & Tools

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)  
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)  
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)  
[![Aiogram](https://img.shields.io/badge/Aiogram-2CA2F2?style=for-the-badge)](https://docs.aiogram.dev/)  
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com/)

---

## How to Run

1. Clone the repository:

```bash
git clone https://github.com/maria-popova-dev/yakutsk_hub.git

Configure .env with your Firebase keys (local only)

Run the Flutter app:

cd flutter_app
flutter run

Run the Telegram bot:

cd bot
python main.py
Screenshots & Demo
Mobile App Screenshots




Telegram Bot Demo

Optional: Video Demo

Watch Video

Animated snow and stars in the 5-day forecast make the interface visually engaging.

What I Learned

Flutter: state management, navigation, UI/UX

Python: building Telegram bots with Aiogram

Firebase: authentication, Firestore, storage

REST APIs: integration, JSON handling

Git/GitHub: repository management and professional workflow

License

This project is licensed under the MIT License. See the LICENSE
 file for details.

About Me

Maria Popova | Flutter Developer & Aspiring Full-Stack Developer

Passionate about building useful apps for local communities.
Constantly learning Flutter, Python, and backend development (Java/Kotlin in future).
Open to collaboration and opportunities.

Contact:
📧 maria.popova.dev@outlook.com

🐙 GitHub: maria-popova-dev

💬 Telegram: @YourTelegramUsername

"The journey of a thousand miles begins with a single step."



