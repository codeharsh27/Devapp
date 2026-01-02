# 🚀 DevApp

**The AI-Powered Career Ecosystem for Developers**

DevApp bridges the gap between learning and getting hired. It is an intelligent, offline-first platform that automates job applications, identifies skill gaps, and provides personalized mentorship to accelerate developer career growth.

Built with **Scalability**, **Clean Architecture**, and **Offline-First** principles at its core.

---

## 📸 Interface

<p align="center">
  <img width="45%" alt="Dashboard" src="https://github.com/user-attachments/assets/cdea6f23-6912-4a8e-a6b1-966fef1a7b06" />
  <img width="45%" alt="Features" src="https://github.com/user-attachments/assets/e9962aa3-a019-4fc5-85fd-ac7cc2b41a8b" />
</p>

---

## ⚡ Core Features

### 🧠 Intelligence & Growth
- **Skill Gap Analysis**  
  Scans your developer profile against real market demands and recommends realistic, personalized learning paths.
  
- **AI Career Mentor**  
  A 24/7 assistant for technical queries, system design guidance, interview preparation, and career advice.

- **Smart Learning**  
  Curated courses, resources, and roadmaps tailored to your current skill level and career goals.

---

### 💼 Career Automation
- **Auto-Apply System**  
  Automatically finds relevant job opportunities, fills application forms, applies on your behalf, and tracks application status.

- **AI Resume Builder**  
  Instantly generates ATS-optimized resumes and developer portfolio websites.

- **AI Cover Letter Generator**  
  Creates custom, job-specific cover letters using AI for higher response rates.

---

### 🛠 Utility & Performance
- **Tech Aggregator**  
  Real-time startup insights and tech news using an API-free implementation.

- **Offline-First Support (Hive)**  
  Read articles, write notes, and track tasks even without an internet connection.

---

## 🏗️ Architecture & Tech Stack

DevApp follows **Clean Architecture** and **SOLID principles**, ensuring separation of concerns, scalability, and testability.

| Layer | Technology |
|------|-----------|
| **Language** | Dart |
| **Framework** | Flutter |
| **State Management** | Riverpod / Provider |
| **Architecture** | Clean Architecture + SOLID |
| **Backend** | Firebase (Auth, Firestore, Cloud Functions) |
| **Local Storage** | Hive (NoSQL) |
| **AI Engine** | Custom API + Local ML Integration |

---

## 📂 Project Structure

```bash
lib/
├── core/                  # Global utilities, themes, constants
├── data/                  # Data layer (API calls, Hive, Models)
│   ├── repositories/      # Repository implementations
│   └── services/          # External services (Firebase, HTTP)
├── domain/                # Business logic (Entities, Use Cases)
├── presentation/          # UI Layer (Screens, Widgets, State Management)
└── utils/                 # Extensions and helper functions
````

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK
* Firebase Project

---

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/codeharsh27/devapp.git
   cd devapp
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**

   * Add `google-services.json` to `android/app/`
   * Add `GoogleService-Info.plist` to `ios/Runner/`

4. **Run the application**

   ```bash
   flutter run
   ```

---

## 🛡️ Security & Privacy

* **Authentication**
  Secure Google and Email login using Firebase Authentication.

* **Data Privacy**
  Firestore security rules are enforced. Sensitive data is never stored in plain text.

* **Local Encryption**
  Hive boxes are encrypted to ensure offline data security.

---

## 🤝 Contributing

Contributions are welcome!
Please fork the repository and submit a Pull Request with clear descriptions of your changes.

---

## 👨‍💻 Author

**Harsh Mule**
📧 Email: [code.harsh26@gmail.com](mailto:code.harsh26@gmail.com)

---

⭐ If you like this project, consider giving it a star!

