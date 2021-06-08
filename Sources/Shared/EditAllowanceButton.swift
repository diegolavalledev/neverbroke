import SwiftUI

struct EditAllowanceButton: View {

  @State var showingForm = false

  @Environment(\.managedObjectContext) private var viewContext

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)],
    animation: .default)
  private var allowances: FetchedResults<AllowanceAmount>

  var body: some View {
    Button {
      showingForm.toggle()
    }
    label: {
      Image(systemName: "pencil.circle.fill")
    }
    .sheet(isPresented: $showingForm) {
      AllowanceForm(isPresented: $showingForm, allowances: Array(allowances))
      .environment(\.managedObjectContext, viewContext)
    }
  }
}

struct EditAllowanceButton_Previews: PreviewProvider {
  static var previews: some View {
    EditAllowanceButton()
    .previewLayout(.sizeThatFits)
  }
}
