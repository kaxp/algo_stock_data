# AlgoStocks

This application is developed on Flutter v3.19.6 in the Stable channel.

## 📌 Quick Navigation  
🔹 [Objective](#objective)  
🔹 [Implementation](#implementation)  
🔹 [Project tree](#project-tree)  
🔹 [Project Setup](#project-setup)  
🔹 [Screenshots & Recording](#screenshots)  
🔹 [APK Link](#apk-link) 

### Objective
Build a real-time option chain for BANKNIFTY that updates every few seconds
using data from a Public API and WebSocket.

### Project Details:
1. Display a table with option contracts (calls and puts)
2. An option chain has multiple expiries. ( show these as filters on top)
3. Each EXPIRY has a list of tradable strikes ( these are rows )
4. Each STRIKE has a CALL and PUT associated with it ( these are the two columns on both sides of STRIKE)
5. Each row in the table should show:
- Call Price
- Strike
- Put Price

- <img width = "300" src="https://github.com/user-attachments/assets/06eaf684-9800-42b3-9bfc-60d4f3f2f05f">

### API Integration(You’ll need VPN):
1. For the initial load of the page, you should call
   - https://prices.loremipsum.xyz/contracts?underlying=BANKNIFTY -> To get the info on all the valid contracts
   - https://prices.loremipsum.xyz/option-chain-with-ltp?underlying=BANKNIFTY -> To get the latest option chain of Banknifty
2. WebSocket: https://prices.loremipsum.xyz/mock/updates
   - After connection send the following JSON message, Replace expiry with whatever expiry you’re currently on
```
{
  "msg": {
    "type": "subscribe",
    "datatypes": [
      "ltp"
    ],
    "underlyings": [
      {
        "underlying": "BANKNIFTY",
        "cash": true,
        "options": [
          "expiry"
        ]
      }
    ]
  }
}
```



> 1. The response from WebSocket will be a list, in this list every item will have a token, close/ltp/price, and timestamp. <br>
> 2. To match the token received in WebSocket to the exact contract, use the response from the `contracts` API call we made initially. <br>
> 3. If a valid contract is found, update the value of call/strike data received in `option-chain-with-ltp` API based on the value of 'option_type' from valid contract.
  
## Implementation
### Project tree

```bash
|-- lib/
  |-- components
  |   ├── atoms/
  |   ├── molecules/
  |   └── organisms/
  |-- config
  |   ├── themes/
  |   └── flavor_config.dart
  |-- constants/
  |-- modules
  |   ├── app
  |   |   └── base_app_module.dart
  |   ├── home
  |   |   ├── bloc/
  |   |   ├── models/
  |   |   ├── pages/
  |   |   ├── repositories/
  |   |   └── home_module.dart
  |-- networking
  |   ├── constants/
  |   ├── interceptors/
  |   ├── models/
  |   ├── retrofit/
  |   ├── http_client.dart
  |   └── web_socket_client.dart
  |-- utils/
  |-- main_base.dart
  |-- main_development.dart
  |-- main_mock.dart
  |-- main_staging.dart
  └── main.dart
|-- test/
  |-- mocks/
  |   |-- bloc/
  |   |    |-- mock_blocs.dart
  |   |    └── mock_blocs.mocks.dart
  |   |-- models/
  |   |    └── test_models_builder.dart
  |   |-- repositories/
  |   |    |-- mock_repositories.dart
  |   |    └── mock_repositories.mocks.dart
  |   └── services/
  |   |    |-- mock_services.dart
  |   |    └── mock_services.mocks.dart
  |-- modules
  |   ├── home
  |   |   ├── bloc/
  |   |   └── pages/
  |-- networking
  |   |   └── http_client_test.dart
  |-- test_utils
  |   |   └── mock_dio_exception.dart
  └── utils
      └── dio_error_extension_test.dart
```

### Project Setup:

- Architecture Pattern- [Layered Architecture](https://www.sciencedirect.com/topics/computer-science/layered-architecture)
- Design Pattern- [Atomic Design Pattern](https://atomicdesign.bradfrost.com/chapter-2/)
- State-management- [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- Dependency Injection - [flutter_modular](https://pub.dev/packages/flutter_modular)
- Navigation - [flutter_modular](https://pub.dev/packages/flutter_modular)
- Localization - [easy_localization](https://pub.dev/packages/easy_localization)
- Model classes - [json_serializable](https://pub.dev/packages/json_serializable) and [equatable](https://pub.dev/packages/equatable)
- Unit And Widget testing - flutter_test, [modular_test](https://pub.dev/packages/modular_test)
- Testing Mocks- [mockito](https://pub.dev/packages/mockito)
- Http client - [dio](https://pub.dev/packages/dio) with [retrofit](https://pub.dev/packages/retrofit) as dio client generator
- Web Socket client - [web_socket_channel](https://pub.dev/packages/web_socket_channel)

### Steps for running the application-

1. Install Flutter following `https://docs.flutter.dev/get-started/install`
2. Clone the project using the command `git clone https://github.com/kaxp/algo_stocks.git`
3. run `flutter pub get`
4. run `flutter pub run build_runner build`
5. run the application on Android device
   - `flutter run --release`
6. running the unit and widget tests
   - `flutter test`


### Assumptions
1. Some intended behaviours in the app
  -  Background State is not managed in the app for WebSocket.
  -  No retry mechanism in the Error State of the app.


### Screenshots
<img width = "300" src="https://github.com/user-attachments/assets/8b48e2e0-e582-4556-b261-3278de85b71b">         <img width = "300" src="https://github.com/user-attachments/assets/dbd825a4-9452-45a6-91d2-bb2d9a2bebe9">      

### Screen Recording

https://github.com/user-attachments/assets/ab324fb0-c569-4bf6-8e92-f6658f35534c


### APK Link
[Link](https://i.diawi.com/SLFQ8W)

