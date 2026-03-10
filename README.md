# YktHub — Yakutsk Local Services Platform

YktHub is a mobile application designed for residents of Yakutsk and the Sakha Republic (Yakutia).  
The project integrates a Flutter mobile app, a Python backend, and a Telegram bot to provide useful everyday services adapted to the extreme conditions of the Arctic region.

The platform focuses on solving real local problems such as extreme winter conditions, transportation across the Lena River, regional travel specifics, and local information services.

---

## Key Features

• Weather information with snowfall animation and star effects  
• School **actirovka notifications** (school cancellation due to extreme cold)  
• Ferry schedule across the **Lena River** — one of the widest rivers in the world  
• Flight ticket search with **subsidized ticket sorting**  
• Currency exchange including **Chinese Yuan**, important for the Russian Far East  
• Telegram bot integration for quick access to services  
• Local news updates

The project demonstrates how technology can be adapted for **Arctic and Far North living conditions**.

---

## Architecture

The project follows a **Single Source of Truth** architecture, where the Java backend centralizes all business logic and data storage.

```text
      Flutter App 📱       Telegram Bot 🤖
            │                   │
            └───────┬───────────┘
                    ▼
          Java Backend ☕ (Spring Boot)
                    │
            ┌───────┴───────┐
            ▼               ▼
      H2 Database 📁   Python Scrapers 🐍

```

The mobile app communicates with a lightweight Python backend which also serves the Telegram bot.

---

## Tech Stack

### Mobile (Flutter)
Dart  
Firebase  
Cubit (Flutter Bloc State Management)
fl_chart (Data Visualization)

### Backend Core (Java)
Java 17  
Spring Boot 3  
Spring Data JPA  
H2 Database (Persistent)

### Automation & Bot (Python)
Python 3.10  
Aiogram 3.x  
REST API  
Pytz (Timezones)

### Other Tools
Git  
GitHub
Postman

---

## Project Structure

```
YktHub
│
├── ☕ java_backend (Spring Boot Core)
│   ├── src/main/java/.../backend  # API, Holidays & Business Logic
│   ├── resources/application.properties # DB & Server Config
│   └── yakutsk_db.mv.db           # Persistent H2 Database File
│
├── 🐍 python_services (Bot & Scrapers)
│   ├── bot/handlers               # Telegram command logic
│   ├── bot/keyboards/menu.py      # Keyboard layouts
│   └── backend/test_*.py          # Python scrapers (S7, News)
│
└── 📱 flutter_app (Mobile Client)
    ├── lib/screens                # UI: YKT LIVE & Summary
    └── lib/widgets                # Neon UI & Price Charts

```

---

## Screenshots

Screenshots of the application will be added here.

Example sections:

Weather screen  
Flights search  
Currency exchange  
Ferry schedule  
Telegram bot interaction

A demo video of the snowfall animation and weather UI.

---

## How to Run the Project

### Clone repository

```
git clone https://github.com/maria-popova-dev/yakutsk_hub.git
```

### Flutter application

```
cd flutter_app
flutter pub get
flutter run
```

### Telegram bot

```
cd bot
pip install -r requirements.txt
python main.py
```

### Backend API

```
cd backend
python api.py
```

---

## What I Learned

• Building a full Flutter mobile application  
• Visualizing analytical data with Neon UI and fl_chart  
• State management with Cubit (Flutter Bloc)  
• Creating a professional Java Spring Boot backend  
• Implementing persistent storage with H2 File Database  
• Developing an asynchronous Telegram bot with Aiogram  
• Automating data collection with Python scrapers  
• Synchronizing mobile apps and bots via a unified REST API  
• Adapting digital solutions for Arctic conditions (Aktirovka, Timezones)  
• Structuring complex multi-component (Java, Python, Flutter) projects

---

## About Me

Maria Popova  
Flutter Developer | Year-Long Program Graduate

Passionate about creating mobile applications and constantly learning new technologies.

Open to collaboration and new opportunities.

Contact:

Email: maria.popova.dev@outlook.com  
GitHub: https://github.com/maria-popova-dev

---

## License

This project is licensed under the MIT License.

---

## Quote

"The journey of a thousand miles begins with a single step."



