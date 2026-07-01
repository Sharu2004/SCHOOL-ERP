# School ERP Management System

A full-stack school management application with a Flutter mobile frontend, a PHP REST API backend, and a MySQL database. Built to handle student records, attendance tracking, fee management, notifications, and role-based authentication.

## Tech Stack

| Layer     | Technology |
|-----------|------------|
| Frontend  | Flutter (Dart) |
| Backend   | PHP (REST API, PDO) |
| Database  | MySQL |
| Auth      | Token-based login with bcrypt password hashing |
| Version Control | Git / GitHub |

## Features

- **Authentication** — Role-based login (admin, teacher, parent) with hashed passwords
- **Student Management** — Add, view, update, and list students by class
- **Attendance Tracking** — Mark daily attendance per class, view attendance history per student
- **Fee Management** — Track dues, record payments, auto-updating payment status (pending / partial / paid)
- **Notifications** — Broadcast announcements to specific classes or the whole school
- **REST API integration** — Flutter frontend communicates with the PHP backend over JSON REST endpoints

## My Role

I designed and built this project end-to-end:
- Designed the Flutter UI (login, dashboard, student list, attendance, fees, notifications)
- Built the PHP REST API layer (`auth.php`, `students.php`, `attendance.php`, `fees.php`, `notifications.php`)
- Designed the MySQL schema and relationships (`database/schema.sql`)
- Implemented authentication and password hashing
- Wired up HTTP integration between Flutter and PHP using the `http` package
- Tested and debugged both frontend and backend
- Managed the project with Git/GitHub

## Project Structure

```
school-erp-management-system/
├── flutter_app/              # Flutter mobile frontend
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/            # Student, Attendance, Fee data models
│   │   ├── screens/           # Login, Dashboard, Students, Attendance, Fees, Notifications
│   │   ├── services/          # API service (HTTP calls to backend)
│   │   └── utils/             # Constants (API base URL etc.)
│   └── pubspec.yaml
├── backend_php/               # PHP REST API
│   ├── config/db.php          # DB connection
│   ├── auth.php               # Login / register
│   ├── students.php           # Student CRUD
│   ├── attendance.php         # Attendance marking/history
│   ├── fees.php                # Fee tracking/payment
│   └── notifications.php      # Announcements
└── database/
    └── schema.sql             # MySQL schema + seed data
```

## Setup Instructions

### 1. Database
```bash
mysql -u root -p < database/schema.sql
```

### 2. Backend (PHP)
1. Copy `backend_php/` into your PHP server root (e.g. XAMPP's `htdocs/`, or serve with `php -S localhost:8000`).
2. Update credentials in `backend_php/config/db.php` if needed.

### 3. Frontend (Flutter)
```bash
cd flutter_app
flutter pub get
flutter run
```
Update `lib/utils/constants.dart` with your backend URL:
- Android emulator → `http://10.0.2.2/backend_php`
- Physical device / iOS simulator → your machine's local IP, e.g. `http://192.168.x.x/backend_php`

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/auth.php?action=login` | POST | Log in, returns token + user |
| `/auth.php?action=register` | POST | Register a new user |
| `/students.php` | GET/POST/PUT/DELETE | Student CRUD |
| `/attendance.php` | GET/POST | Mark and fetch attendance |
| `/fees.php` | GET/POST | Fetch fee records, record payments |
| `/notifications.php` | GET/POST | Fetch and post announcements |

## Screenshots

> Screenshots will be added here after running the app (`flutter run`) on an emulator/device.
> Suggested shots: Login screen, Dashboard, Student list, Attendance marking, Fee status, Notifications.

## Future Improvements

- JWT-based authentication instead of the current simple token
- Push notifications via Firebase Cloud Messaging
- Report card / grades module
- Admin web dashboard

## License

This project is open source and available for educational purposes.
