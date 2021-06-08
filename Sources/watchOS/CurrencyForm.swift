import SwiftUI

struct CurrencyForm: View {

  @Environment(\.presentationMode) var presentationMode
  @Binding var userPreferences: UserPreferences
  @State var newCurrency = UserPreferences.default.currencySymbol

  var body: some View {
    Form {
      Picker("Currency", selection: $newCurrency) {
        ForEach(CurrencySymbol.allCases) {
          Text("\($0.rawValue)").tag($0)
        }
      }
      .pickerStyle(WheelPickerStyle())
      .frame(minHeight: 80)
      saveButton
      cancelButton
    }
    .onAppear {
      newCurrency = userPreferences.currencySymbol
    }
  }

  var saveButton: some View {
    Button {
      userPreferences.currencySymbol = newCurrency
      presentationMode.wrappedValue.dismiss()
    } label: {
      Text("Save").bold().foregroundColor(.accentColor)
    }
  }

  var cancelButton: some View {
    Button("Cancel") {
      presentationMode.wrappedValue.dismiss()
    }
    .foregroundColor(.red)
  }
}

struct CurrencyForm_Previews: PreviewProvider {
  static var previews: some View {
    CurrencyForm(userPreferences: .constant(.default))
  }
}
