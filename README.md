# Manager

A multiplatform Flutter app for tracking personal finances: log in, see your
balance, record income and expenses, and compare spending with your budgets.

## Getting started

```
flutter pub get
flutter run
```

The app runs on fake data until Lab 3. Log in with `demo` / `demo123`. The fake
repositories wait 0.8 s and fail on purpose in 10–20% of requests, so the
loading and error states are easy to see.

Run the checks with:

```
flutter analyze
flutter test
```

## Architecture

```
lib/
├── main.dart            composition root, creates the repositories
├── domain/
│   ├── exceptions.dart
│   └── models/          Transaction, Budget, AppUser
├── data/
│   └── repositories/    interfaces and fake implementations
└── ui/
    ├── app.dart         MaterialApp and the login gate
    ├── home_shell.dart  bottom navigation
    ├── core/            formatters, icons, shared widgets
    ├── auth/            AuthViewModel, login screen
    ├── dashboard/       dashboard screen
    ├── transactions/    TransactionsViewModel, list, details, form
    └── budgets/         BudgetsViewModel, budgets screen
```

Data flows one way, from repository to view model to screen; events flow back
from a tap on a screen, through a view model method, to the repository.

**State management: provider + ChangeNotifier.** It is the approach used in the
lab example, it needs little code, and it keeps view models plain Dart classes
that can be tested without an emulator. Our app has a small amount of shared
state, so the extra structure of BLoC or Riverpod would not pay off yet.

View models depend only on the repository interfaces. Screens import nothing
from `data/`, and `main.dart` is the only file that knows the fake classes.

### Shared state

There is one `TransactionsViewModel` for the whole app. A transaction added or
edited in the form appears at once on the dashboard (balance, recent list), in
the transaction list, in the details and in the budget bars.

### Repositories

| Interface               | Provides                                     | Implementation              |
| ----------------------- | -------------------------------------------- | --------------------------- |
| `AuthRepository`        | Logging in and out                           | `FakeAuthRepository`        |
| `TransactionRepository` | Reading, adding, editing, deleting transactions | `FakeTransactionRepository` |
| `BudgetRepository`      | Reading spending limits per category         | `FakeBudgetRepository`      |
