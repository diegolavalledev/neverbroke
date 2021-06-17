import SwiftUI

struct ExpenseForm: View {

  @Binding var isPresented: Bool

  #if os(iOS) || os (macOS)
    @State var disableSave = true
  #endif
  #if os(watchOS)
    @State var disableSave = false
  #endif

  @State var date = Date()
  @State var amount = 0.0
  @State var description = ""
  @State var category = ""
  @State var emoji = ""

  @Environment(\.managedObjectContext) private var viewContext

  var amountFieldBody: some View {
    Group {
      TextField("1.99", value: $amount, formatter: .currency) {
        if $0 {
          disableSave = true
        }
      } onCommit: {
        if amount > 0 {
          disableSave = false
        }
      }

      #if os(watchOS)
        AmountStepper(amount: $amount)
      #endif
    }
  }

  #if os(iOS) || os(macOS)
    let sectionFooter = "Press return (enter) to validate the amount. The specified value must be greater than 0."
  #endif
  #if os(watchOS)
    let sectionFooter = "The specified value must be greater than 0."
  #endif

  var formBody: some View {
    Form {
      Section(
        header: Text("Amount"),
        footer: Text(sectionFooter)
      ) {

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
    .disabled(disableSave)
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
