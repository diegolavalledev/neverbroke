import SwiftUI

struct Expenses: View {

  let currency: CurrencySymbol
  let expenses: [ExpenseItem]

  let dateFormatter: Formatter = {
    let df = DateFormatter()
    df.dateStyle = .none
    df.timeStyle = .short
    return df
  }()

  var body: some View {
    ForEach(expenses) { expense in
      VStack {
        HStack {
          Text("\(String(expense.emoji ?? ExpenseItem.emptyEmoji)) \(expense.amount.currencyFormat(symbol: currency))").bold()
          Spacer()
          Text("\(expense.timestamp, formatter: dateFormatter)")
          .font(.caption)
        }
        if let memo = expense.memo {
          Text(memo)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top)
        }
      }
      .padding()
    }
    //.navigationBarTitle("Expenses")
  }
}

struct Expenses_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Expenses(currency: UserPreferences.default.currencySymbol, expenses: [])
    }
    .previewLayout(.sizeThatFits)
  }
}
