import SwiftUI

struct NewExpenseButton: View {

  @State var showingForm = false
  @Environment(\.managedObjectContext) private var viewContext

  var body: some View {
    Button {
      showingForm.toggle()
    }
    label: {
      Label("Record an expense", systemImage: "plus.circle.fill")
    }
    .sheet(isPresented: $showingForm) {
      ExpenseForm(isPresented: $showingForm)
      .environment(\.managedObjectContext, viewContext)
    }
  }
}

struct NewExpenseButton_Previews: PreviewProvider {
  static var previews: some View {
    NewExpenseButton()
    .previewLayout(.sizeThatFits)
  }
}
