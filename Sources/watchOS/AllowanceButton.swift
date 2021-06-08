import SwiftUI

struct AllowanceButton: View {

  let userPreferences: UserPreferences
  let allowances: [AllowanceAmount]

  @State var showForm = false

  @Environment(\.managedObjectContext) private var viewContext

  var allowance: String {
    allowances.lastAmount.currencyFormat(symbol: userPreferences.currencySymbol)
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Allowance").bold()
      HStack {
        Text(allowance)
        Image(systemName: "pencil.circle.fill").foregroundColor(.accentColor)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top)
    }
    .onTapGesture {
      showForm.toggle()
    }
    .sheet(isPresented: $showForm) {
      AllowanceForm(isPresented: $showForm, allowances: Array(allowances))
      .environment(\.managedObjectContext, viewContext)
    }
  }
}

struct AllowanceButton_Previews: PreviewProvider {
  static var previews: some View {
    AllowanceButton(userPreferences: .default, allowances: .default)
    .previewLayout(.sizeThatFits)
  }
}
