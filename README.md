# Demo SwiftUI Project
A clean and modern SwiftUI template designed to showcase recommended app architecture, navigation handling, async data streams, and deep link support.

This project can be used as a solid starting point for your own application.

## 🚀 Installation

This project uses **Tuist** to generate the Xcode workspace.

1. Install Tuist  
   👉 https://docs.tuist.dev

2. Generate the project:
   ```sh
   tuist generate
   ```


## 📦 Included Features
### 🧩 Architecture
- MVVM pattern
- AppEnvironment for dependency injection
- Clear separation between Views, ViewModels, and Services
### 🔄 Reactive Data Flow
- AsyncStream service example — demonstrates async sequence–based state updates.
- Combine service example — demonstrates @Published, AnyPublisher, and publisher merging.
### 🧭 Navigation
- DeepLink-driven navigation
  - Open specific tabs/screens via Local Notifications
  - Can be extended for Push Notifications and Associated Domain links
- Internal navigation using NavigationStack: Strongly-typed screen routing
### 🧪 Tests
- Unit tests for services and viewModels

