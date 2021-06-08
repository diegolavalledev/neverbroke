import SwiftUI

struct DeleteExpenseButton: View {

  let expense: ExpenseItem
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.managedObjectContext) private var viewContext

  var body: some View {
    Button("Remove expense") {
      viewContext.delete(viewContext.object(with: expense.objectID))
      do {
        try viewContext.save()
      } catch {
        #if DEBUG
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        #endif
      }
      presentationMode.wrappedValue.dismiss()
    }
    .foregroundColor(.red)
    .frame(maxWidth: .infinity)
  }
}

struct DeleteExpenseButton_Previews: PreviewProvider {
  static var previews: some View {
    DeleteExpenseButton(expense: ExpenseItem())
    .previewLayout(.sizeThatFits)
  }
}
