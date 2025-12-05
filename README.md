# Loan Calculator (тестовый проект)

![Light](screenshots/screen.png)

![Dark](screenshots/screen_dark.png)

## Кратко

- Экран расчета займа: ввод суммы, выбор срока, расчет итоговой суммы и даты возврата, отправка заявки.  
- Архитектура презентации: UDF/Redux подход (Store + Reducer).  
- Бизнес-логика вынесена в Use Case слой, доступ к данным через Repository контракты.  
- DI: Swinject (в репозитории присутствует как SwiftPM пакет).  
- Тесты: Swift Testing (@Suite/@Test, #expect), покрывают ключевые сценарии Store.  

- Экран расчета займа: ввод суммы, выбор срока, расчет итоговой суммы и даты возврата, отправка заявки.
- Архитектура презентации: UDF/Redux подход (Store + Reducer + Environment).
- Бизнес-логика вынесена в Use Case слой, доступ к данным через Repository контракты.
- Environment: явная dependency injection через  LoanEnvironment  для тестируемости и композируемости.
- Side Effects: асинхронные эффекты возвращаются из Reducer как  Task<Action, Never>? .
- Debouncing: оптимизированное сохранение preferences через отдельные Task’и для каждого поля.
- DI: Swinject (в репозитории присутствует как SwiftPM пакет).
- Тесты: Swift Testing (@Suite/@Test, #expect), покрывают ключевые сценарии Store и Reducer.
    
## Стек

- Swift 5.9+, Xcode 15+  
- Swift Concurrency: async/await, @MainActor  
- DI: Swinject  
- Архитектура: UDF/Redux (State, Action, Reducer + Environment) + Use Case + Repository
- Форматирование: Foundation FormatStyle (числа/даты)  
- Тестирование: Swift Testing  

## Структура (ключевое)

- **Package.swift** SwiftPM пакет Swinject (поддерживает iOS, macOS, tvOS, watchOS, visionOS).  
- **Calculator** (модуль приложения): 
  - **LoanStore.swift** Store: хранит  LoanState , делегирует изменения в  LoanReducer , обрабатывает асинхронные эффекты (через  Task<Action> ), управляет debouncing для сохранения preferences, предоставляет вычисляемые значения для UI.
  - **LoanReducer.swift** чистая функция  (inout State, Action, Environment) -> Task<Action, Never>? : применяет синхронные мутации, возвращает асинхронные эффекты как Task.
  - **LoanEnvironment.swift** контейнер зависимостей ( applyForLoan ,  preferences ) для явной DI и тестируемости.
  - **LoanState.swift** состояние экрана:  amount ,  termIndex , диапазоны,  terms ,  isLoading ,  result ,  errorMessage ,  theme . Реализует  Equatable  для оптимизации SwiftUI.
  - **LoanAction.swift** все возможные действия:  .setAmount ,  .setTermIndex ,  .apply ,  .setLoading ,  .setResult ,  .setErrorMessage ,  .setTheme .
  - **LoanApplicationRequest.swift** / LoanApplicationResult.swift модели запроса/результата.
  - **DomainError.swift** доменная ошибка.
  - **Use cases:
    - `ApplyForLoanUseCase.swift`  протокол +  `DefaultApplyForLoanUseCase`  (делегирует в Repository).
    - `LoanPreferencesUseCase.swift`  протокол +  `DefaultLoanPreferencesUseCase`  (делегирует в Repository). Поддерживает раздельную загрузку/сохранение  amount ,  termIndex ,  theme .
  - **Repositories (контракты)**:  
    - `ApplyForLoanRepository.swift` отправка заявки.  
    - `LoanPreferencesRepository.swift` загрузка/сохранение преференций и темы.  
  - **Networking
    - `RequestDescriptor.swift` контракт запроса (path, method, headers, body, requiresAuth)
    - `HTTPMethod` GET/POST/PUT/PATCH/DELETE
    - `LoanApplicationRequestDescriptor.swift` эндпоинты модуля займа (.loanApplication)
    - `BaseURLProvider.swift` базовый URL из Info.plist (“API base URL”)
    - `NetworkManager.swift` абстракция клиента
    - `DefaultNetworkManager` URLSession, JSON encode/decode, обработка статусов, OSLog

  - **DI (Swinject)
    - `ManagerAssembly.swift` регистрация BaseURLProvider, NetworkManager, UserDefaultsManager
    - `(далее)` регистрируются репозитории и use case

- **Tests**:  
  - `LoanStoreTests.swift`  тесты Store на Swift Testing.
      - LoanReducerTests.swift`  юнит-тесты чистого Reducer.
      - Моки:  `MockApplyForLoanUseCase.swift` ,  `MockLoanPreferencesUseCase.swift` ,  `MockLoanEnvironment.swift` .
    
## Как это работает (коротко)

- `Store`  ( @MainActor ) хранит  LoanState  и принимает  LoanAction  через  send(_:) .
- `Reducer`  — чистая функция:
- Применяет синхронные мутации к  State .
- для асинхронных операций ( .apply ) возвращает  Task<Action, Never>? .
- Store.send(_:) :
- Вызывает  reducer(&state, action, environment) .
- Если возвращается Task — ждет результат и рекурсивно вызывает  send()  с новым Action.
- Для синхронных Action ( .setAmount ,  .setTermIndex ,  .setTheme ) запускает debounced сохранение через отдельные Task’и.
- Debouncing: каждое поле (amount, termIndex, theme) имеет свой  Task , отменяется при новом изменении, сохраняется через 1 секунду.
- Environment: внедряется в Store через инициализатор, предоставляет  applyForLoan  и  preferences  use cases.


Вычисляемые значения для UI:  

- Ставка: `15%`.  
- `totalRepaymentValue = amount + amount * 0.15` (округление).  
- `formattedAmount`, `totalRepaymentText`, `interestRateText`, `dueDateText` (через FormatStyle API).  

## Установка и запуск

1. **Требования**  
   - Xcode 15+, Swift 5.9+  
   - Платформы Swinject: iOS 12+, macOS 10.13+, tvOS 12+, watchOS 4+, visionOS 1+  

2. **Клонирование**  
   - `git clone <repo_url>`  
   - Откройте проект в Xcode (`Package.swift` или `.xcodeproj`/`.xcworkspace` в зависимости от структуры).  

3. **Зависимости**  
   - Swinject уже в репозитории как SwiftPM-пакет. Xcode подтянет и соберет автоматически.  

4. **Сборка и запуск**  
   - Выберите схему приложения (например, `Calculator`) и соберите (`Cmd+B`).  
   - Запустите на симуляторе или устройстве (`Cmd+R`).  
   - Для устройства при необходимости настройте Signing (Team) в Signing & Capabilities.  

## Тесты

- Xcode: `Product > Test` (`Cmd+U`).  
- Используется Swift Testing:  
  - Проверяется инициализация Store из сохраненных преференций/темы.  
  - Сохранение при изменении суммы/срока.  
  - Корректный расчет `totalRepayment` и `interestRateText`.  
  - Успешная и неуспешная отправка заявки (`result`/`errorMessage`, снятие `isLoading`).  
- Моки: `MockApplyForLoanUseCase`, `MockLoanPreferences

## DI в реальном приложении (пример на словах)
- В композиционном корне создается Container/Assembler (Swinject).
- Регистрируются:
   - ApplyForLoanRepository (реальная сеть) -> ApplyForLoanUseCase (Default…)
   - LoanPreferencesRepository (например, UserDefaults) -> LoanPreferencesUseCase (Default…)
   - LoanStore резолвится с нужными зависимостями.
- Экран получает готовый Store через контейнер.

## Заметки
- DomainError: Equatable реализован упрощенно (в тестовых целях).
- Реальные реализации репозиториев (сеть/хранилище) опущены в тестовом проекте достаточно контрактов и моков.
- Store помечен @MainActor для потокобезопасной работы с UI.
