import Intents
import CoreData

class AllowanceIntentHandler: NSObject, AllowanceIntentHandling {
  func handle(intent: AllowanceIntent, completion: @escaping (AllowanceIntentResponse) -> ()) {
    let store = NeverbrokeStore()
    let currency = store.userPreferences.currencySymbol

    let viewContext = PersistenceContainer.shared.viewContext
    let allowancesRequest = NSFetchRequest<AllowanceAmount>(entityName: String(describing: AllowanceAmount.self))
    allowancesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)]
    let allowances = try! viewContext.fetch(allowancesRequest)

    let expensesRequest = NSFetchRequest<ExpenseItem>(entityName: String(describing: ExpenseItem.self))
    expensesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)]
    let expenses = try! viewContext.fetch(expensesRequest)

    let allowance = allowances.lastAmount
    let remaining = allowance - expenses.todaysOnly.total

    let response = AllowanceIntentResponse(code: .success, userActivity: nil)
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
