import SwiftUI
import CoreData

struct AllowanceForm: View {

  @Binding var isPresented: Bool
  let allowances: [AllowanceAmount]

  @State var disableSave = false
  @State var newAmount = 0.0

  @Environment(\.managedObjectContext) private var viewContext

  var firstTime: Bool {
    allowances.count == 0
  }

  var amountFieldBody: some View {
    TextField("20.99", value: $newAmount, formatter: .currency) {
      if $0 {
        disableSave = true
      }
    } onCommit: {
      if newAmount != allowances.lastAmount {
        disableSave = false
      }
    }
  }

  #if os(iOS) || os(macOS)
    let sectionFooter = "Press return (enter) to validate the amount. Your new allowance must be different than the current allowance."
  #endif
  #if os(watchOS)
    let sectionFooter = "Your new allowance must be different than the current allowance."
  #endif

  var formBody: some View {
    Form {
      Section(
        header: Text("Amount"),
        footer: Text(sectionFooter).lineLimit(5).fixedSize(horizontal: false, vertical: true)
      ) {
        #if os(macOS) || os(watchOS)
          amountFieldBody
        #else
          amountFieldBody
          .keyboardType(.numbersAndPunctuation)
        #endif
        #if os(watchOS)
          AmountStepper(amount: $newAmount)
        #endif
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
    #if os(iOS)
      NavigationView {
        formBody
        .navigationBarTitle("Daily allowance", displayMode: .inline)
        .navigationBarItems(leading: firstTime ? nil : cancelButton, trailing: saveButton)
      }
      .onAppear(perform: setInitialValue)
    #endif

    #if os(macOS)
      formBody
      .padding()
      .frame(maxWidth: 200)
      .onAppear(perform: setInitialValue)
    #endif

    #if os(watchOS)
      NavigationView {
        formBody
      }
      .onAppear(perform: setInitialValue)
      // // This will eliminate "Cancel"
    #endif
  }

  func setInitialValue() {
    newAmount = firstTime ? AllowanceAmount.suggestedValue : allowances.lastAmount
  }

  var saveButton: some View {
    Button("Save") {
      let now = Date()
      let allowance: AllowanceAmount

      #if os(watchOS)
        allowance = AllowanceAmount(context: viewContext)
        allowance.day = now
      #else
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: AllowanceAmount.self))
        request.predicate = NSPredicate(format: "day_ == %@", now.normalized as NSDate)
        if let result = try? viewContext.fetch(request) as? [AllowanceAmount], result.count > 0 {
          allowance = result[0]
        } else {
          allowance = AllowanceAmount(context: viewContext)
          allowance.day = now
        }
      #endif

      allowance.amount = newAmount
      allowance.timestamp = now
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

struct AllowanceForm_Previews: PreviewProvider {
  static var previews: some View {
    AllowanceForm(isPresented: .constant(true), allowances: .default)
  }
}
