import SwiftUI

struct ExpenseDetails: View {

  let expense: ExpenseItem
  let currency: CurrencySymbol

  #if os(iOS) || os(watchOS)
    var amountHeader: some View {
      Text("Amount")
    }
  #endif
  #if os(macOS)
    var amountHeader: some View {
      Text("Amount")
      .font(.callout)
      .foregroundColor(.secondary)
      .padding()
    }
  #endif

  #if os(iOS) || os(watchOS)
    var dateHeader: some View {
      Text("Expense date")
    }
  #endif
  #if os(macOS)
    var dateHeader: some View {
      Text("Expense date")
      .font(.callout)
      .foregroundColor(.secondary)
      .padding()
    }
  #endif

  #if os(iOS) || os(watchOS)
    var emojiHeader: some View {
      Text("Emoji")
    }
  #endif
  #if os(macOS)
    var emojiHeader: some View {
      Text("Emoji")
      .font(.callout)
      .foregroundColor(.secondary)
      .padding()
    }
  #endif

  #if os(iOS) || os(watchOS)
    var descriptionHeader: some View {
      Text("Description and category")
    }
  #endif
  #if os(macOS)
    var descriptionHeader: some View {
      Text("Description and category")
      .font(.callout)
      .foregroundColor(.secondary)
      .padding()
    }
  #endif

  var formBody: some View {
    Form {
      Section(header: amountHeader) {
        Text(expense.amount.currencyFormat(symbol: currency))
      }
      Section(header: dateHeader) {
        HStack {
          Text("Date/time")
          Spacer()
          Text("\(expense.timestamp, formatter: .infoDateFormatter)")
        }
        
      }
      Section(header: emojiHeader) {
        Text(String(expense.emoji ?? ExpenseItem.emptyEmoji))
      }
      Section(header: descriptionHeader) {
        Text(expense.memo ?? ExpenseItem.emptyMemo)
        Text(expense.category ?? ExpenseItem.emptyCategory)
      }
      HStack {
        DeleteExpenseButton(expense: expense)
        #if os(macOS)
          Spacer()
        #endif
      }
    }
  }

  var body: some View {
#if os(macOS)
      VStack {
        formBody
        Spacer()
      }
      .padding()
      .frame(minWidth: 250, maxWidth: 300)
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
