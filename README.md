# Ykt Hub 🏙️

**A comprehensive project for Yakutsk residents** — a Flutter mobile app complemented by a Telegram bot for quick access to local services such as weather, currency, news, ferries, and flights.

This project demonstrates:
- Flutter mobile development (Dart)
- Python backend and Telegram bot development (Aiogram)
- API integration and asynchronous data handling
- Modular and maintainable project structure

---

## 📂 Project Structure


YktHub/
├── flutter_app/ # Flutter mobile application
├── backend/ # Mini-backend providing API for bot and Flutter app
├── bot/ # Telegram bot (Python + Aiogram)
├── requirements.txt # Python dependencies
├── .gitignore
└── README.md


---

## ⚡ Features

### Flutter App
- Current and 5-day weather forecast for Yakutsk
- Real-time currency rates
- News feed and event listings
- Ferries and flight information

### Telegram Bot
- Mirrors the same data as the Flutter app
- Personalized greetings by username
- Command and button handling via Aiogram

---

## 🛠️ Technologies

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)  
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)](https://dart.dev/)  
[![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)](https://www.python.org/)  
[![Aiogram](https://img.shields.io/badge/Aiogram-00C1D4?style=flat)](https://docs.aiogram.dev/en/latest/)  
[![OpenWeatherMap](https://img.shields.io/badge/OpenWeatherMap-ffcc00?style=flat)](https://openweathermap.org/)  
[![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat&logo=github&logoColor=white)](https://github.com/)

---

## 🚀 Installation & Setup

### 1️⃣ Flutter Application
```bash
cd flutter_app
flutter pub get
flutter run
2️⃣ Telegram Bot

Install Python dependencies:

pip install -r requirements.txt

Create a .env file in the project root:

TELEGRAM_TOKEN=your_bot_token
WEATHER_API=your_weather_api_key

Run the bot:

python bot/main.py

⚠️ Do not commit your tokens. .env is ignored via .gitignore.

📌 Screenshots
Flutter App
Main Screen	Weather Forecast	Currency Rates

	
	

Screenshots show the main dashboard, weather, and currency screens.		
Telegram Bot
Bot Start	Bot Weather

	

Bot greeting and showing weather forecast.	

💡 Tip: Save screenshots in flutter_app/assets/screenshots/ and bot/assets/screenshots/ with the same filenames as above.

🎯 Purpose

Showcase Flutter mobile development

Demonstrate integration with Python backend and Telegram bot

Highlight full-stack development skills for potential employers

Ready for deployment and further feature expansion

🔗 Future Improvements

Connect Flutter app directly to backend via REST API

Add user authentication and personalized settings

Implement caching for faster bot responses

Expand services (local transport, restaurants, events)



