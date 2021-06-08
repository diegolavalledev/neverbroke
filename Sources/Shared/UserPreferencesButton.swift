import SwiftUI

struct UserPreferencesButton: View {

  @State var showingForm = false
  @EnvironmentObject var store: NeverbrokeStore

  var body: some View {
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

struct UserPreferencesButton_Previews: PreviewProvider {
  static var previews: some View {
    UserPreferencesButton(showingForm: false, store: EnvironmentObject<NeverbrokeStore>())
    .previewLayout(.sizeThatFits)
  }
}
