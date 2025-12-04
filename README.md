# iOSCalculator

Calculator

Кратко
Calculator — демо-приложение для расчета займа и оформления заявки. Используются слои UseCase/Repository, Swift Concurrency (async/await) и модульные тесты на новом Swift Testing.

Требования
• Xcode 16.x (Swift Testing поддерживается начиная с Xcode 15)
• Swift 5.9+
• Платформы (по умолчанию предполагается iOS 17+; если есть другие цели — проект собирается как обычный iOS проект)

Структура проекта
• Calculator (модуль приложения)
   • Domain
      • Models
         • LoanPreferences
         • DomainError
         • LoanApplicationRequest
         • LoanApplicationResult
         • LoanTheme
      • UseCases
         • LoanApplicationUseCase.swift
            • Протокол LoanApplicationUseCase
            • Реализация DefaultLoanApplicationUseCase (через LoanApplicationRepository)
         • LoanPreferencesUseCase.swift􀰓
            • Структура LoanPreferences
            • Протокол LoanPreferencesUseCase
            • Реализация DefaultLoanPreferencesUseCase (через LoanPreferencesRepository)
   • Data
      • Repositories
         • LoanApplicationRepository (предполагается)
         • LoanPreferencesRepository (предполагается)
   • Presentation
      • Store
         • LoanCalculatorStore (управление состоянием калькулятора; используется в тестах)
   • UI
      • Экран калькулятора (предполагается SwiftUI/UIKit)
• Tests
   • LoanCalculatorStoreTests.swift􀰓 — тесты для LoanCalculatorStore на Swift Testing
   • Mocks
      • MockLoanApplicationUseCase.swift􀰓 — мок для LoanApplicationUseCase
      • MockLoanPreferencesUseCase.swift􀰓 — мок для LoanPreferencesUseCase

Ключевые типы
• LoanPreferences: amount (Double), termIndex (Int)
• LoanPreferencesUseCase: load/save предпочтений, load/save темы (LoanTheme)
• DefaultLoanPreferencesUseCase: реализация через LoanPreferencesRepository
• LoanApplicationUseCase: оформление заявки
• DefaultLoanApplicationUseCase: реализация через LoanApplicationRepository
• DomainError: доменная ошибка (statusCode, errorCode?, message)
• LoanCalculatorStore: стор калькулятора (используется в тестах)
• Тестовые моки:
   • MockLoanApplicationUseCase: имитирует результаты apply(loan:)
   • MockLoanPreferencesUseCase: хранит/возвращает сохраненные prefs и theme

Сборка и запуск
Через Xcode
1. Откройте проект (Calculator.xcodeproj или .xcworkspace).
2. Выберите схему Calculator.
3. Выберите симулятор (например, iPhone 15).
4. Запустите Cmd+R.

Через командную строку (xcodebuild)
• Список схем:
xcodebuild -list -project Calculator.xcodeproj
• Сборка:
xcodebuild -project Calculator.xcodeproj -scheme Calculator -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 15'
• Запуск:
xcodebuild test -project Calculator.xcodeproj -scheme Calculator -destination 'platform=iOS Simulator,name=iPhone 15'

Тестирование (Swift Testing)
В Xcode:
• Откройте Test Navigator (Cmd+6) и запустите тесты или Cmd+U для всех.

Что проверяют тесты
• Инициализация LoanCalculatorStore подхватывает сохраненные предпочтения и тему.
• Обновление суммы сохраняет предпочтения.
• Расчет общей суммы платежа (пример: 10 000 при 15% → 11 500) и форматирование процента.
• Успешная заявка обновляет result и снимает isLoading.
• Ошибка заявки устанавливает errorMessage и снимает isLoading.

Зависимости и конфигурация
• Внешних API-ключей нет.
• Хранение prefs/theme — через LoanPreferencesRepository (реализация может использовать UserDefaults).
• Оформление заявки — через LoanApplicationRepository (может быть заглушкой/имитацией сети).
• В тестах используются моки MockLoanApplicationUseCase и MockLoanPreferencesUseCase.

Полезные команды
• Очистка DerivedData:
rm -rf ~/Library/Developer/Xcode/DerivedData
• Документация (если используете DocC):
xcodebuild docbuild -scheme Calculator -destination 'platform=macOS' -derivedDataPath ./DerivedData

Стиль и практики
• Используется Swift Concurrency (async/await).
• Протоколы помечены Sendable для потокобезопасности.
• Тесты — через Swift Testing (@Suite, @Test).
