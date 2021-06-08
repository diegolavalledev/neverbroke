import Intents

class AllowanceIntentHandler: NSObject, AllowanceIntentHandling {
  func handle(intent: AllowanceIntent, completion: @escaping (AllowanceIntentResponse) -> ()) {
    let response = AllowanceIntentResponse(code: .success, userActivity: nil)
    let store = NeverbrokeStore()

    let currency = store.userPreferences.currencySymbol

    let allowance = 0.0 //store.allowanceData.lastAmount
    let remaining = 0.0 // store.expenses.todaysOnly.total

    response.allowanceSummary = AllowanceSummary(identifier: "Daily and remaining allowance", display: "You have \(remaining.currencyFormat(symbol: currency)) remaining out of a \(allowance.currencyFormat(symbol: currency)) daily allowance.")

    response.allowanceSummary?.remainingAllowance =
      // INCurrencyAmount(amount: .init(value: remaining), currencyCode: currency.code)
      remaining.currencyFormat(symbol: currency)

    response.allowanceSummary?.dailyAllowance =
      // INCurrencyAmount(amount: .init(value: allowance), currencyCode: currency.code)
      allowance.currencyFormat(symbol: currency)
    completion(response)
  }
}
