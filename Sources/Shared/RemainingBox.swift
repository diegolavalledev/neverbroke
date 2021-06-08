import SwiftUI

struct RemainingBox: View {

  let userPreferences: UserPreferences

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)],
    animation: .default)
  private var allowances: FetchedResults<AllowanceAmount>

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)],
    animation: .default)
  private var expenses: FetchedResults<ExpenseItem>

  var allowance: String {
    allowances.lastAmount.currencyFormat(symbol: userPreferences.currencySymbol)
  }

  var remainingValue: Double {
    allowances.lastAmount - expenses.todaysOnly.total
  }

  var remaining: String {
    remainingValue.currencyFormat(symbol: userPreferences.currencySymbol)
  }

  var body: some View {
    GroupBox(label: Text(remainingValue < 0 ? "Short" : "Remaining")) {
      Text(remaining)
      .foregroundColor(remainingValue < 0 ? .red : .green)
      .padding(.vertical)
    }
  }
}

struct RemainingBox_Previews: PreviewProvider {
  static var previews: some View {
    RemainingBox(userPreferences: .default)
  }
}
