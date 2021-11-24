import SwiftUI

struct AllExpenses: View {

  @EnvironmentObject var store: NeverbrokeStore

  var body: some View {
    ExpenseList(currency:  store.userPreferences.currencySymbol)
    .navigationTitle("Expenses")
  }
}

struct AllExpenses_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      AllExpenses(store: EnvironmentObject<NeverbrokeStore>())
    }
  }
}
