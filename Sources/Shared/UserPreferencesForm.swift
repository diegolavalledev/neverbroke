import SwiftUI

struct UserPreferencesForm: View {

  @Binding var isPresented: Bool
  @Binding var userPreferences: UserPreferences

  @State var newName: String = UserPreferences.default.userName
  @State var newCurrency = UserPreferences.default.currencySymbol

  var body: some View {
    NavigationView {
    #if os(macOS)
      formBody
    #else
      formBody
      .navigationBarTitle("Preferences", displayMode: .inline)
      .navigationBarItems(leading: cancelButton, trailing: saveButton)
    #endif
    }
    .onAppear {
      newName = userPreferences.userName
      newCurrency = userPreferences.currencySymbol
    }
  }

  var formBody: some View {
    Form {
      Section(header: Text("Your name (optional)")) {
        TextField("Jane", text: $newName)
      }
      Section(header: Text("Preferred currency symbol")) {
        Picker("Currency", selection: $newCurrency) {
          ForEach(CurrencySymbol.allCases) {
            Text("\($0.rawValue)").tag($0)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      Section {
        Button("Revert") {
          newName = userPreferences.userName
          newCurrency = userPreferences.currencySymbol
        }
        Button("Reset to defaults") {
          newName = UserPreferences.default.userName
          newCurrency = UserPreferences.default.currencySymbol
        }
      }
#if os(macOS)
      Section {
        saveButton
        cancelButton
      }
#endif
    }
  }

  var saveButton: some View {
    Button("Save") {
      userPreferences.userName = newName
      userPreferences.currencySymbol = newCurrency
      isPresented.toggle()
    }
  }

  var cancelButton: some View {
    Button("Cancel") {
      isPresented.toggle()
    }
  }
}

struct UserPreferencesForm_Previews: PreviewProvider {
  static var previews: some View {
    UserPreferencesForm(isPresented: .constant(true), userPreferences: .constant(.default))
  }
}
