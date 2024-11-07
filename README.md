# 🎉 Reward Rush App - Code Overview

Welcome to the **Reward Rush App**! This application is a gamified rewards platform developed using **Flutter** and **Bloc** for state management. It allows users to earn coins, scratch cards for rewards, and redeem items in the store. Below, you'll find an overview of the code structure and how Bloc manages state transitions in this app. 🚀

## 📂 Project Structure

The project follows **Clean Architecture** principles to organize code in a modular, testable way. Here’s a quick breakdown of the folder structure:

```plaintext
lib/
├── core/                # Core utilities and constants
│   ├── constants/
│   ├── utils/
├── features/            # Feature-specific code, divided by functionality
│   ├── home/
│   │   ├── bloc/        # Bloc files for managing coin balance and scratch cards
│   │   ├── data/        # Repositories and data sources
│   │   ├── presentation # UI code for the home screen
│   ├── redemption_store/
│   │   ├── bloc/        # Bloc files for managing item redemption
│   │   ├── data/        # Redemption data
│   │   ├── presentation # UI code for redemption pages and widgets
│   └── scratch_cards/
│       ├── bloc/        # Bloc for managing scratch card states
│       ├── data/        # Scratch card data management
│       ├── presentation # UI for scratch card components
└── test/                # Unit and integration tests
```

## 🧠 State Management with Bloc

Bloc is the backbone of state management in this application. It allows the app to manage complex state transitions efficiently. Here’s how Bloc is used across different features:

### 1. 🏠 Home Feature - `CoinBloc`

- **Purpose**: Manages the user's coin balance and scratch card availability.
- **Events**:
    - `LoadInitialCoins`: Loads initial coin data.
    - `ScratchCardEvent`: Updates coin balance after a scratch card is used.
- **States**:
    - `CoinLoading`: Initial loading state for coins.
    - `CoinLoaded`: State when the coin data is available.
- **Flow**: The `CoinBloc` listens for events, fetches data, and updates the UI when the coin balance changes. This makes the scratch card functionality seamless by updating the balance in real-time without refresh.

### 2. 🎁 Redemption Store - `RedemptionBloc`

- **Purpose**: Handles item redemption processes.
- **Events**:
    - `LoadRedemptionItems`: Loads items available for redemption.
    - `RedeemItem`: Redeems an item and updates the store.
- **States**:
    - `RedemptionLoading`: Loading state for the store.
    - `RedemptionLoaded`: Loaded state with available items.
    - `RedemptionSuccess`/`RedemptionFailure`: Success or failure states for the redemption process.
- **Flow**: `RedemptionBloc` controls the state of the store, enabling real-time feedback on item redemption. Successful redemption triggers a transition to `RedemptionSuccess`, which is then displayed on the screen.

### 3. 🎟️ Scratch Cards - `ScratchCardBloc`

- **Purpose**: Manages the lifecycle of scratch cards, including availability and scratch progress.
- **Events**:
    - `LoadScratchCards`: Loads available scratch cards.
    - `ScratchCardUsed`: Updates the scratch card as used.
- **States**:
    - `ScratchCardLoading`: Initial loading state for scratch cards.
    - `ScratchCardAvailable`: State when scratch cards are ready to be used.
    - `ScratchCardRedeemed`: State after a card has been scratched and reward granted.
- **Flow**: The `ScratchCardBloc` keeps track of scratch card states. When a scratch card is scratched, it updates the state, making the user experience smooth and intuitive.

## ⚙️ Key Features

1. **Coin Management**: Real-time tracking of coin balance with `CoinBloc`.
2. **Scratch Cards**: Scratch cards are periodically available, and each provides a reward that increases the user’s balance.
3. **Redemption Store**: Users can redeem items in exchange for coins. The `RedemptionBloc` manages this process, updating the store and user balance accordingly.

## 🧪 Testing

The project includes unit and integration tests for critical functionalities:

- **CoinBloc**: Tests coin balance loading, updates, and scratch card functionality.
- **RedemptionBloc**: Validates redemption success and failure scenarios.
- **ScratchCardBloc**: Ensures scratch card states are correctly updated.

### 📑 Test Structure

Here’s the test file organization:

```plaintext
test/
├── core/
│   └── utils/
│       └── date_time_utils_test.dart
├── features/
│   ├── home/
│   │   ├── bloc/
│   │   │   └── coin_bloc_test.dart
│   │   └── presentation/
│   │       └── home_page_test.dart
│   ├── redemption_store/
│   │   ├── bloc/
│   │   │   └── redemption_bloc_test.dart
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       └── redeem_item_test.dart
│   │   └── presentation/
│   │       └── widgets/
│   │           └── redemption_item_widget_test.dart
│   └── scratch_cards/
│       ├── bloc/
│       │   └── scratch_card_bloc_test.dart
│       └── presentation/
│           └── scratch_card_widget_test.dart
└── integration/
    └── app_flow_test.dart
```


Thank you for exploring the **Reward Rush App**! 🎉 We hope this README provides a comprehensive overview of the project. Happy coding! 👨‍💻👩‍💻


