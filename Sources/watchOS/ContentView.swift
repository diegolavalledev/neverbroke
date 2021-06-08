import SwiftUI

struct ContentView: View {

  let userPreferences: UserPreferences

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)],
    animation: .default)
  private var allowances: FetchedResults<AllowanceAmount>

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)],
    animation: .default)
  private var expenses: FetchedResults<ExpenseItem>

  var body: some View {
    if allowances.isEmpty {
      AllowanceForm(isPresented: .constant(true), allowances: Array(allowances))
    } else {
      allowanceEnteredBody
    }
  }

  var allowanceEnteredBody: some View {
    NavigationView {
      List {
        AllowanceButton(userPreferences: userPreferences, allowances: Array(allowances))
        RemainingButton(userPreferences: userPreferences, allowances: Array(allowances), expenses: Array(expenses))
        SpentButton(userPreferences: userPreferences, expenses: Array(expenses))
        CurrencyButton(userPreferences: userPreferences)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(userPreferences: .default)
    .environmentObject(NeverbrokeStore())
  }
}
