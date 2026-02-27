# Finance Assistant

Finance Assistant is a comprehensive Flutter application designed to help users manage their personal finances effectively. It provides tools for tracking income, expenses, budgets, debts, and bills, all within a user-friendly interface powered by modern technologies.

## 🚀 Key Features

- **Dashboard Overview**: Get a quick snapshot of your financial health with intuitive charts and summaries.
- **Income & Expense Tracking**: Log and categorize your transactions to keep track of your cash flow.
- **Budget Management**: Set monthly budgets and monitor your spending habits to stay on track.
- **Debt Tracking**: Manage personal debts and repayments efficiently.
- **Bill Management**: Organize individual and group bills to ensure timely payments.
- **AI Financial Assistant**: Ask questions and get insights about your finances using the integrated AI chat feature.
- **Secure Authentication**: Robust login and registration system, including social login options.
- **Multi-Currency Support**: Handle transactions in different currencies.
- **Profile & Settings**: Customize your experience and view detailed financial reports.

## 🛠️ Tech Stack

This project is built using a modern and scalable Flutter architecture:

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Flutter BLoC (Cubit)](https://pub.dev/packages/flutter_bloc)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Networking**: [Dio](https://pub.dev/packages/dio) with interceptors for robust API communication.
- **Local Storage**: [Hive](https://pub.dev/packages/hive) and [Shared Preferences](https://pub.dev/packages/shared_preferences).
- **Backend Services**: [Firebase](https://firebase.google.com/) (Core, Auth, Messaging).
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it).
- **UI & Charts**: [FL Chart](https://pub.dev/packages/fl_chart) for data visualization.

## 📂 Project Structure

The project follows a **Feature-First Architecture** to ensure scalability and maintainability:

```
lib/
├── src/
│   ├── core/           # Core utilities, configuration, and shared components
│   │   ├── config/     # Theme, routing, and app configuration
│   │   ├── di/         # Dependency injection setup
│   │   ├── network/    # API clients and endpoints
│   │   ├── services/   # External services (Storage, Firebase, etc.)
│   │   └── utils/      # Constants, extensions, and helper functions
│   │   └── view/       # Shared UI components
│   └── features/       # Feature-specific modules
│       ├── ask_ai/     # AI Assistant feature
│       ├── auth/       # Authentication (Login, Register, OTP)
│       ├── budget/     # Budget management
│       ├── currency/   # Currency handling
│       ├── debts/      # Debt tracking
│       ├── home/       # Home dashboard
│       ├── income/     # Income tracking
│       ├── onboarding/ # Onboarding screens
│       ├── profile/    # User profile and reports
│       ├── reminder/   # Reminders and notifications
│       └── services/   # Additional services like Bill and Expense management
├── main.dart           # Application entry point
└── firebase_options.dart # Firebase configuration
```
# Architecture & Design


This document provides an overview of the architectural decisions and design patterns used in the Finance Assistant application.


## High-Level Architecture


The application follows a **Feature-First (or Layered by Feature)** architecture. This approach organizes code around business features rather than technical layers, making the codebase more scalable and easier to navigate.


### Directory Structure


- **`lib/src/features/`**: Contains all feature-specific code. Each feature (e.g., `auth`, `budget`, `income`) is a self-contained module with its own:
 - **`data/`**: Repositories, data sources (remote/local), and models.
 - **`domain/`**: Entities and business logic (if applicable).
 - **`presentation/`**: UI components, screens, and state management (Cubits/Blocs).
- **`lib/src/core/`**: Contains shared code used across multiple features, such as:
 - **`config/`**: App-wide configuration (themes, routing).
 - **`network/`**: API clients and interceptors.
 - **`services/`**: Third-party service integrations (Firebase, Local Storage).
 - **`utils/`**: Helper functions and extensions.
 - **`view/`**: Reusable UI widgets.



## State Management


We use **Flutter BLoC (Cubit)** for state management. This pattern separates business logic from UI, making the code testable and maintainable.


- **Cubits**: Handle the business logic and emit states.
- **States**: Represent the different UI states (e.g., `Loading`, `Success`, `Error`).
- **UI**: Reacts to state changes using `BlocBuilder` and `BlocListener`.


## Dependency Injection


We use **GetIt** for dependency injection. This allows us to decouple classes and easily swap implementations for testing.


- Services and repositories are registered as singletons or lazy singletons.
- Cubits/Blocs are often provided via `BlocProvider` in the widget tree or via DI if needed.


## Navigation


**GoRouter** is used for declarative routing. It simplifies deep linking and navigation logic.


- Routes are defined in `lib/src/core/routing/`.
- Each feature can define its own sub-routes.


## Data Layer


- **Networking**: `Dio` is used for HTTP requests. Custom interceptors handle authentication tokens and logging.
- **Local Storage**: `Hive` is used for fast, key-value storage (e.g., user preferences, cache).




## Clean Code Practices


- **Linting**: We adhere to strict linting rules to ensure code consistency.
- **Immutability**: Models and states are immutable (using `equatable` or `freezed` concepts).
- **Separation of Concerns**: Each class has a single responsibility.


## 🏁 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10.4 or higher)
- Dart SDK
- An IDE (VS Code or Android Studio)

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/finance_assistant.git
    cd finance_assistent
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the application:**

    ```bash
    flutter run
    ```

## 👥 Mobile Team - Group(5)

- Mustafa Shihab 
- Rozan Alawar
- Alaa Moqade
- Zainab Atwa
- Marah Saadeh



