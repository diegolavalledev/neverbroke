import SwiftUI
import Intents

struct WelcomeMessage: ViewModifier {

  @AppStorage("showWelcome") var showWelcome = true
  @State var useSiri = true

  func body(content: Content) -> some View {
    content
    .sheet(isPresented: $showWelcome) {
      ScrollView {
        VStack(alignment: .leading, spacing: 8) {
          Text("Welcome to Neverbroke").font(.title)
          .frame(maxWidth: .infinity)
          .padding(.vertical)
          
          Group {
            Text("Use this app to keep track your every-day spending.")
            Text("On the next screen you'll be able to set your daily allowance.")
            Text("After that you can begin recording each of your expenses.")
            Text("Neverbroke will always remind you of how much you have left to spend before the end of the day.")
            Text("You don't even need to open the app. Add a widget to your home screen or just ask Siri how much do you have left.")
          }
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)


          #if !os(macOS)
          VStack(alignment: .leading, spacing: 4) {
            Toggle("Use Siri", isOn: $useSiri)
            Text("You will be asked for permission on the next screen.")
            .font(.caption)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
          }
          .padding(.top)
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
}

struct WelcomeMessage_Previews: PreviewProvider {
  static var previews: some View {
    EmptyView().modifier(WelcomeMessage(showWelcome: true))
  }
}
