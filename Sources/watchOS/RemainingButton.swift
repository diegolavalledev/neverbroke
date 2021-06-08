import SwiftUI

struct RemainingButton: View {

  let userPreferences: UserPreferences
  let allowances: [AllowanceAmount]
  let expenses: [ExpenseItem]

  var spentValue: Double {
    expenses.todaysOnly.total
  }

  var remainingValue: Double {
    allowances.lastAmount - spentValue
  }

  var remaining: String {
    remainingValue.currencyFormat(symbol: userPreferences.currencySymbol)
  }

  var expensesList: some View {
    ExpenseList(currency: userPreferences.currencySymbol)
  }

  var body: some View {
    NavigationLink(destination: expensesList) {
      VStack(alignment: .leading) {
        Text(remainingValue < 0 ? "Short" : "Remaining").bold()
        HStack {
          Text(remaining)
          .foregroundColor(remainingValue < 0 ? .red : nil)
          Image(systemName: "info.circle.fill").foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top)
      }
    }
  }
}

struct RemainingButton_Previews: PreviewProvider {
  static var previews: some View {
    RemainingButton(userPreferences: .default, allowances: .default, expenses: [])
    .previewLayout(.sizeThatFits)
  }
}
