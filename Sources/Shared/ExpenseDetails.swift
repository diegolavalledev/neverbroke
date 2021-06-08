import SwiftUI

struct ExpenseDetails: View {

  let expense: ExpenseItem
  let currency: CurrencySymbol

  var formBody: some View {
    Form {
      Section(header: Text("Amount")) {
        Text(expense.amount.currencyFormat(symbol: currency))
      }
      Section(header: Text("Expense date")) {
        HStack {
          Text("Date/time")
          Spacer()
          Text("\(expense.timestamp, formatter: .infoDateFormatter)")
        }
        
      }
      Section(header: Text("Emoji")) {
        Text(String(expense.emoji ?? ExpenseItem.emptyEmoji))
      }
      Section(header: Text("Description and category")) {
        Text(expense.memo ?? ExpenseItem.emptyMemo)
        Text(expense.category ?? ExpenseItem.emptyCategory)
      }
      DeleteExpenseButton(expense: expense)
    }
  }

  var body: some View {
#if os(macOS)
      formBody
#else
      formBody
      .navigationBarTitle("Expense")
#endif
  }
}

struct ExpenseDetails_Previews: PreviewProvider {
  static var previews: some View {
    ExpenseDetails(expense: ExpenseItem(), currency: UserPreferences.default.currencySymbol)
  }
}
