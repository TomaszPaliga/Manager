# Lab 2 report

> DRAFT. Replace every line marked TODO before tagging `lab-2`, and align the
> headings with the Lab 1 template if they differ.

## Done

- Layered `lib/`: `domain/`, `data/`, `ui/`.
- Immutable models with `copyWith`, `==` and `hashCode`: `Transaction`, `Budget`, `AppUser`.
- Repository interfaces with fake implementations (delay and simulated failures):
  `AuthRepository`, `TransactionRepository`, `BudgetRepository`.
- State management with provider + ChangeNotifier, justified in the README.
- Six main screens fed by view models: Login, Dashboard, Transactions,
  Transaction details, Transaction form, Budgets.
- Loading, empty and error-with-retry states on every screen with data.
- Shared state: a transaction added in the form appears on the dashboard, in
  the list and in the budget bars.
- A form with validation: create and edit a transaction.
- Unit tests for view models, including failure paths, and widget tests,
  including the error state.

## Who did what

TODO: each member, what they owned, links to their pull requests.

| Member | Feature | Pull requests |
| ------ | ------- | ------------- |
| TODO   | TODO    | TODO          |
| TODO   | TODO    | TODO          |

## Screenshots

TODO: one screen in all states. Set `failureRate: 1.0` in `main.dart` for the
error state and `initialTransactions: const []` for the empty state.

- Loading: TODO
- Error: TODO
- Loaded: TODO
- Empty: TODO

## Test results

TODO: paste the summary line of `flutter test`.

## Problems

TODO

## Scope changes

TODO: confirm that the six screens above match the project card. If they do not,
describe the change here.

## Plan

TODO: Lab 3 scope. Issues moved from Lab 2 to Lab 3.
