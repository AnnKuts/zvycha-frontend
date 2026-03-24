<h1>
  <img src="./assets/logos/white-bg-no-mouth-cat.png" alt="Zvycha logo" width="40" />
  Zvycha frontend
</h1>

Zvycha is a habit-building app that combines the body doubling method through shared focus rooms with gamification — supporting your habit formation journey by caring for a virtual Tamagotchi-style pet.

## Table of Contents
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [Demo](#demo)
- [Getting Started for Local Development](#getting-started-for-local-development)
- [Contact](#contact)

### Key Features

- Habit tracker
- User authentication/authorization
- Shared focus rooms
- Social interactions
- Pomodoro timer (not implemented yet)
- Virtual Tamagotchi pet to visualize habit progress
- Pet customization system
- Statistics/dashboard (not implemented yet)

### Technology Stack
<p align="left">
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg" width="45" height="45" alt="Dart" />
<img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg" width="45" height="45" alt="Flutter" />
</p>

### Demo
To ask for a live demo, visit [this page](https://zvycha-landing.vercel.app/)

<img width="393" height="1704" alt="image" src="https://github.com/user-attachments/assets/f0ce4361-22ad-4051-bd4d-ef2a29490e08" />
<img width="393" height="852" alt="image" src="https://github.com/user-attachments/assets/91ed42a0-7cfc-42a3-805c-6342e71a7aeb" />
<img width="393" height="852" alt="image" src="https://github.com/user-attachments/assets/b1b456a0-ddb5-4cbd-a526-d74f40d4de24" />
<img width="393" height="1704" alt="image" src="https://github.com/user-attachments/assets/e5ebe514-138e-4930-b38f-d494506e2f42" />
<img width="393" height="1704" alt="image" src="https://github.com/user-attachments/assets/fddd3d30-3c96-4245-8ab3-040c64b11f2d" />
<img width="393" height="1704" alt="image" src="https://github.com/user-attachments/assets/1471593f-527a-4b3e-b2ba-6b0468fcaad2" />
<img width="393" height="852" alt="image" src="https://github.com/user-attachments/assets/0d7c676a-50b9-40e4-b5c6-0324a71392a7" />
<img width="393" height="1704" alt="image" src="https://github.com/user-attachments/assets/0a349b52-2322-4b73-af1c-e69f06abe4f3" />
<img width="393" height="852" alt="image" src="https://github.com/user-attachments/assets/2a777073-714e-4f9c-91ae-38430ebceb8d" />


### Getting Started for Local Development
1. Clone the repository:
```bash
git clone https://github.com/AnnKuts/zvycha-frontend.git
cd zvycha-frontend
```
2. Download backend and enter all neccessary .env there
3. Run docker
```bash
docker compose build
docker compose up
```
3. Fill the [.env file](https://github.com/AnnKuts/zvycha-frontend/blob/main/.env.example). Then add your environment variables:
```env
BASE_URL=http://your-backend-api-url.com
```
4. Install dependencies:
```bash
flutter pub get
```
5. Start the development server
```bash
flutter run
```
6. Open emulator

### Contact
If you have questions or suggestions, open an issue or contact the maintainers listed in the repository.  
We welcome your pull requests! Before contributing, please read our [CONTRIBUTING.md](https://github.com/AnnKuts/zvycha-app/blob/main/docs/CONTRIBUTING.md).
