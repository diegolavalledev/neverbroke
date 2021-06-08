import SwiftUI
import Intents

struct WelcomeMessage: ViewModifier {

  @AppStorage("showWelcome") var showWelcome = true
  @State var useSiri = true

  func body(content: Content) -> some View {
    content
    .sheet(isPresented: $showWelcome) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Welcome to Neverbroke").font(.title)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
        Text("Use this app to track your every-day spending.")
        Text("Be sure to specify your daily allowance amount first. After that you can begin recording each of your expenses.")
        Text("Neverbroke will always remind you of how much you have left to spend before the end of the day.")
        Text("You don't even need to open the app! Add our widget to your home screen or just ask Siri for your remaining allowance.")

        #if !os(macOS)
        Toggle("Use Siri (you will be asked for permission on the next screen)", isOn: $useSiri)
        #endif

        Button("Done") {

          #if !os(macOS)
            if useSiri {
              INPreferences.requestSiriAuthorization { _ in }
            }
          #endif
          showWelcome.toggle()
        }
        .foregroundColor(.primary)
        .padding()
        .background(Color.accentColor)
        .cornerRadius(9.0)
        .frame(maxWidth: .infinity)
        .padding(.vertical)
      }
      .padding()
    }
  }
}

struct WelcomeMessage_Previews: PreviewProvider {
  static var previews: some View {
    EmptyView().modifier(WelcomeMessage(showWelcome: true))
  }
}
