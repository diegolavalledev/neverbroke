import SwiftUI

struct ExpenseForm: View {

  @Binding var isPresented: Bool

  @Environment(\.managedObjectContext) private var viewContext

//  @FetchRequest(
//    sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)],
//    animation: .default)
//  private var expenses: FetchedResults<ExpenseItem>

  @State var date = Date()
  @State var amount = 0.0
  @State var description = ""
  @State var category = ""
  @State var emoji = ""

  var amountFieldBody: some View {
    Group {
      TextField("1.99", value: $amount, formatter: .currency)

      #if os(watchOS)
        AmountStepper(amount: $amount)
      #endif
    }
  }

  var formBody: some View {
    Form {
      Section(header: Text("Amount")) {

        #if os(iOS)
          amountFieldBody
          .keyboardType(.numbersAndPunctuation)
        #else
          amountFieldBody
        #endif
      }
      Section(header: Text("Expense date")) {
        #if os(watchOS)
          TextField("Date", value: $date, formatter: .infoDateFormatter).disabled(true)
        #else
          DatePicker("Date/time", selection: $date)
        #endif
      }
      Section(header: Text("Emoji")) {
        TextField(ExpenseItem.emptyEmoji, text: $emoji)
      }
      Section(header: Text("Description and category")) {
        TextField("Description", text: $description)
        TextField("Category", text: $category)
      }

      #if os(macOS) || os(watchOS)
        Section {
          saveButton
          #if os(macOS)
            cancelButton
          #endif
        }
      #endif
    }
  }

  var body: some View {
    NavigationView {

      #if os(iOS)
        formBody
        .navigationBarTitle("Expense", displayMode: .inline)
        .navigationBarItems(leading: cancelButton, trailing: saveButton)
      #else
        formBody
      #endif
    }
  }

  var saveButton: some View {
    Button("Save") {
      let tz = Calendar.current.timeZone
      let newItem = ExpenseItem(context: viewContext)
      newItem.amount = amount
      newItem.category = category
      newItem.day = date
      newItem.emoji = emoji
      newItem.memo = description
      newItem.timestamp = date
      newItem.timezoneId = tz.identifier
      newItem.timezoneSeconds = tz.secondsFromGMT(for: date)

      do {
        try viewContext.save()
      } catch {
        #if DEBUG
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        #endif
      }

      isPresented.toggle()
    }
  }

  var cancelButton: some View {
    Button("Cancel") {
      isPresented.toggle()
    }
  }
}

struct ExpenseForm_Previews: PreviewProvider {
  static var previews: some View {
    ExpenseForm(isPresented: .constant(true))
  }
}
