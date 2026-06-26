# Zana Shop 🛒

**Zana Shop is a modern, full-stack e-commerce application. Built with performance and scalability in mind, this project serves as a showcase of clean architecture, efficient state management, and robust backend integration.***

## 🚀 Technical Stack

### Mobile (Frontend)

- Framework: Flutter
- State Management: BLoC / Cubit for scalable and predictable state handling.
- Networking: Dio for reliable API communication.
- Asset Handling: CachedNetworkImage for optimized image loading.

### Backend

- Framework: Django
- API: Django REST Framework (DRF) for secure and standardized data delivery.

## 🛠 Key Features

- BLoC Architecture: Implemented the Repository Pattern to ensure a clean separation between data sources and UI logic.
- Interactive Cart System: Real-time cart management allowing users to increment, decrement, and remove items with instant synchronization with the Django backend.
- State-Driven UI: Efficiently managed complex UI states (Loading, Loaded, Error) using the BLoC pattern.
- Modern UI/UX: Designed with a user-centric approach, featuring smooth transitions and responsive layouts.

## 📦 Getting Started

```bash
git clone https://github.com/mobin-abdi/zana_shop.git

cd zana_shop
```

**in this project you need python to run backend**

```bash
cd bacend

python -m venv venv

venv\Scripts\activate # source venv/bin/activate (for Linux and Macos)

cd bacend

python manage.py runserver
```

```bash
cd zana_shop

flutter pub get

flutter run
```

**if you run it on emulator set httpClien with http://10.0.2.2:8000**

**you can see the api document in localhost:8000/api/docs**

## 👨‍💻 About

**Developed by Mobein Abdi. This project reflects a passion for building robust software systems and implementing scalable mobile-backend architectures.**

- **github**: [github.com/mobin-abdi/](https://github.com/mobin-abdi/)
- **Telegram**: [@ZanaHub](https://t.me/ZanaHub)

## 📜 License
Distributed under the MIT License. See `LICENSE` for more information.
