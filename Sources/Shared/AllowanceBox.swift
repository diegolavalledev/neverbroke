import SwiftUI

struct AllowanceBox: View {

  let userPreferences: UserPreferences
  let allowances: [AllowanceAmount]

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)],
    animation: .default)
  private var expenses: FetchedResults<ExpenseItem>

  var allowance: String {
    allowances.lastAmount.currencyFormat(symbol: userPreferences.currencySymbol)
  }

  var body: some View {
    GroupBox(label: Text("Daily allowance")) {
      HStack {
        EditAllowanceButton()
        Text(allowance)
      }.padding(.vertical)
    }
  }
}

struct AllowanceBox_Previews: PreviewProvider {
  static var previews: some View {
    AllowanceBox(userPreferences: .default, allowances: .default)
  }
}
