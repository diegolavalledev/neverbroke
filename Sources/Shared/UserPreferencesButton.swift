import SwiftUI

struct UserPreferencesButton: View {

  @State var showingForm = false
  @Environment(NeverbrokeStore.self) var store

  var body: some View {
    @Bindable var store = store
    Button {
      showingForm.toggle()
    }
    label: {
      Image(systemName: "person.circle.fill")
    }
    .font(.title)
    .sheet(isPresented: $showingForm) {
      UserPreferencesForm(isPresented: $showingForm, userPreferences: $store.userPreferences)
    }
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  UserPreferencesButton(showingForm: false)
    .environment(NeverbrokeStore())
}
