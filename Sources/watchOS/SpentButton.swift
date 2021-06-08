import SwiftUI

struct SpentButton: View {

  let userPreferences: UserPreferences
  let expenses: [ExpenseItem]

  @State var showForm = false

  @Environment(\.managedObjectContext) private var viewContext

  var spentValue: Double {
    expenses.todaysOnly.total
  }

  var spent: String {
    spentValue.currencyFormat(symbol: userPreferences.currencySymbol)
  }

  var body: some View {
    VStack(alignment: .leading) {
      Text("Spent Today").bold()
      HStack {
        Text(spent)
        Image(systemName: "plus.circle.fill").foregroundColor(.accentColor)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top)
    }
    .onTapGesture {
      showForm.toggle()
    }
    .sheet(isPresented: $showForm) {
      ExpenseForm(isPresented: $showForm)
      .environment(\.managedObjectContext, viewContext)
    }
  }
}

struct SpentButton_Previews: PreviewProvider {
  static var previews: some View {
    SpentButton(userPreferences: .default, expenses: [])
    .previewLayout(.sizeThatFits)
  }
}
