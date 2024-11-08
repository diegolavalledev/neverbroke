import SwiftUI

struct AllExpenses: View {

  @Environment(NeverbrokeStore.self) var store

  var body: some View {
    ExpenseList(currency:  store.userPreferences.currencySymbol)
      .navigationTitle("Expenses")
  }
}

#Preview {
  NavigationView {
    AllExpenses()
      .environment(NeverbrokeStore())
  }
}
