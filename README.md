# ❄️ Ykt Hub | Arctic Region Ecosystem

[![Python 3.9+](https://shields.io)](https://python.org)
[![Aiogram 3.x](https://shields.io)](https://aiogram.dev)
[![Flutter](https://shields.io)](https://flutter.dev)
[![License: MIT](https://shields.io)](https://opensource.org)

**Ykt Hub** is a professional cross-platform solution tailored for the extreme conditions of Yakutsk and the Russian Far East. It bridges urban services and residents through a high-performance Flutter application and an asynchronous Telegram bot.

---

## 🚀 Key Features

*   **Arctic-Ready Weather Engine:** Real-time processing for temperatures down to -60°C.
*   **Northern Logistics:** Schedules for Lena River ferries and subsidized flight monitoring.
*   **Fintech Module:** Multi-currency tracker (RUB/CNY, RUB/USD) catering to regional trade.
*   **Modular Bot Architecture:** Event-driven design using **Aiogram 3.x** magic filters.

---

## 🏗 Project Structure

```text
YktHub/
├── flutter_app/         # Mobile client (Flutter + Dart)
│   ├── lib/             # UI & Business logic
│   └── assets/          # Weather animations & icons
├── bot/                 # Telegram Bot Engine (Python)
│   ├── main.py          # Entry point & Dispatcher
│   ├── handlers/        # Async event handlers (Weather, Currency)
│   ├── keyboards/       # Reply/Inline UI components
│   └── config.py        # Secrets & API management
├── backend/             # Future FastAPI/Kotlin gateway
└── README.md            # System documentation
Используйте код с осторожностью.

🛠 Tech Stack & Full-Stack Evolution
Frontend: Flutter (Mobile/Web), State Management.
Bot/Backend: Python 3.9+, Aiogram 3.x (Asyncio), Aiohttp.
Cloud/DB: Firebase (Auth, Firestore), transitioning to PostgreSQL.
Logistics Integration: OpenWeather API, ExchangeRate REST API.
📈 Roadmap
Base Aiogram 3.x Bot implementation
Multi-currency support (USD/EUR/CNY)
Next: Migration to a dedicated FastAPI backend for centralized data.
Future: Implementing Kotlin/Java microservices for logistics.
🛠 Setup & Run
Clone repository:
bash
git clone https://github.com
Используйте код с осторожностью.

Run Bot:
bash
cd bot
pip install -r requirements.txt
python main.py
Используйте код с осторожностью.

👩‍💻 About Me
Maria Popova | Flutter Developer & Aspiring Full-Stack Developer
Passionate about building resilient, community-driven applications for the North. Currently mastering Full-Stack development (Python/Dart) with plans for Java/Kotlin.
Contact: maria.popova.dev@outlook.com | GitHub
"The journey of a thousand miles begins with a single step."



