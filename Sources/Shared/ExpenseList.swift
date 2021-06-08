import SwiftUI

struct ExpenseList: View {

  let currency: CurrencySymbol

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)],
    animation: .default)
  private var expenses: FetchedResults<ExpenseItem>

  @Environment(\.managedObjectContext) private var viewContext

  let dateFormatter: Formatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .short
    df.doesRelativeDateFormatting = true
    return df
  }()

  var body: some View {
    if expenses.count == 0 {
      VStack {
        Text("You have not recorded any expenses.")
        NewExpenseButton()
      }
    } else {
      List {
        ForEach(expenses) { expense in
          NavigationLink(destination: ExpenseDetails(expense: expense, currency: currency)) {
            VStack {
              HStack {
                Text("\(expense.timestamp, formatter: dateFormatter)")
                Spacer()
                Text(expense.category ?? ExpenseItem.emptyCategory)
              }
              .font(.caption)

              HStack {
            Text("\(String(expense.emoji ?? ExpenseItem.emptyEmoji)) \(expense.amount.currencyFormat(symbol: currency))").bold()
                Spacer()
                Text(expense.memo ?? ExpenseItem.emptyMemo)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
              }.padding(.vertical)
            }
          }
        }
        .onDelete {
          guard let i = $0.first else {
            return
          }
          viewContext.delete(viewContext.object(with: expenses[i].objectID))
          do {
            try viewContext.save()
          } catch {
            #if DEBUG
              let nsError = error as NSError
              fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            #endif
          }
        }
      }
    }
  }
}

struct ExpenseList_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ExpenseList(currency: UserPreferences.default.currencySymbol)
      ExpenseList(currency: UserPreferences.default.currencySymbol)
    }
    .previewLayout(.sizeThatFits)
  }
}
