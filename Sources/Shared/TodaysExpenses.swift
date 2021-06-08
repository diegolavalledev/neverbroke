import SwiftUI

struct TodaysExpenses: View {

  @EnvironmentObject var store: NeverbrokeStore

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)],
    // predicate: ?,
    animation: .default)
  private var allExpenses: FetchedResults<ExpenseItem>

  var expenses: [ExpenseItem] {
    Array(allExpenses.todaysOnly)
  }

  var body: some View {
    if expenses.count == 0 {
      Text("You recorded no expenses so far today.")
      .padding()
    } else {
      Expenses(currency: store.userPreferences.currencySymbol, expenses: expenses)
    }
  }
}

struct TodaysExpenses_Previews: PreviewProvider {
  static var previews: some View {
    TodaysExpenses(store: EnvironmentObject<NeverbrokeStore>())
    .previewLayout(.sizeThatFits)
  }
}
