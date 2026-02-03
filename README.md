# Flutter CRUD App

A modern Flutter application for managing payments with full CRUD operations, real-time updates via WebSockets, and data insights. Built with clean architecture principles for maximum modularity and extensibility.

## Features

### CRUD Operations
Complete payment management with Create, Read, and Delete functionality:
- **Create**: Add new payment records with date, amount, type, category, and description
- **Read**: View all payments in a master list with detailed view for individual items
- **Delete**: Remove payments from both local database and remote server
- Offline detection with user feedback when the server is unavailable

### Insights & Reports
Data analytics features to help understand spending patterns:

- **Top Categories Insight**: Analyzes all payments and displays the top 3 spending categories ranked by total amount
- **Monthly Reports**: Aggregates payment data by month, showing total spending per month in chronological order

### Real-Time Updates (WebSockets)
Stay synchronized with live data:
- WebSocket connection for real-time notifications when new payments are added
- Automatic snackbar notifications with option to refresh the data
- Seamless integration with the existing data flow

## Architecture & Clean Code Principles

This application follows clean code principles with a layered, modular architecture that promotes separation of concerns and extensibility.

### Project Structure

```
lib/
├── main.dart                 # Application entry point with dependency injection
├── model/
│   └── model.dart            # Payment data model with JSON serialization
├── repository/
│   └── repository.dart       # Data access layer with local SQLite caching
├── service/
│   ├── api_service.dart      # HTTP client and WebSocket connection
│   ├── insight_service.dart  # Business logic for category insights
│   └── report_service.dart   # Business logic for monthly reports
└── screens/
    ├── master.dart           # Main list view with navigation
    ├── detail.dart           # Create/view payment details
    ├── insight.dart          # Top categories display
    └── report.dart           # Monthly totals display
```

### Modularity & Extensibility

- **Separation of Concerns**: Each layer has a single responsibility
  - Models handle data structure and serialization
  - Repository manages data persistence (SQLite) and synchronization
  - Services encapsulate business logic and API communication
  - Screens handle UI presentation and user interaction

- **Dependency Injection**: Services are injected through constructors, making components loosely coupled and easily testable

- **Service-Based Design**: Adding new features (e.g., new report types, additional insights) requires only:
  1. Creating a new service class
  2. Adding a new screen
  3. Injecting the service in `main.dart`

- **Extensible Data Layer**: The repository pattern allows easy switching between data sources (local SQLite, remote API) without affecting other layers

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- A running backend server on port 2627 (for API and WebSocket connections)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Silea-Horia/flutter-crud-app.git
   cd flutter-crud-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## API Endpoints

The app connects to a backend server with the following endpoints:
- `GET /payments` - Retrieve all payments
- `POST /payment` - Create a new payment
- `GET /payment/:id` - Get payment by ID
- `DELETE /payment/:id` - Delete a payment
- `GET /allPayments` - Get all payments (for reports/insights)
- `WebSocket ws://10.0.2.2:2627` - Real-time payment notifications (uses Android emulator loopback)

## Technologies Used

- **Flutter** - Cross-platform UI framework
- **SQLite (sqflite)** - Local database for offline caching
- **HTTP** - RESTful API communication
- **WebSocket** - Real-time bidirectional communication
- **Material Design** - Modern UI components
