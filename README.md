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

```
Flutter Mobile App
        │
        │ REST API
        ▼
Python Backend
        │
        ▼
Telegram Bot (Aiogram)
```

The mobile app communicates with a lightweight Python backend which also serves the Telegram bot.

---

## Tech Stack

### Mobile
Flutter  
Dart  
Firebase  
Cubit (Flutter Bloc State Management)

### Backend
Python  
REST API

### Telegram Bot
Python  
Aiogram

### Other Tools
Git  
GitHub

---

## Project Structure

```
YktHub
│
├── flutter_app
│   ├── lib
│   ├── assets
│   └── pubspec.yaml
│
├── backend
│   └── api.py
│
├── bot
│   ├── main.py
│   ├── handlers
│   ├── keyboards
│   └── requirements.txt
│
├── .gitignore
└── README.md
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

You can also include a demo video of the snowfall animation and weather UI.

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
• Using Firebase services in mobile apps  
• State management with Cubit (Flutter Bloc)  
• Creating a Telegram bot with Aiogram  
• Designing REST APIs with Python  
• Integrating mobile apps with backend services  
• Structuring multi-component projects

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



