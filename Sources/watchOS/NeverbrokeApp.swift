import SwiftUI
import Intents

@main
struct NeverbrokeApp: App {

  @StateObject var store = NeverbrokeStore()
  @Environment(\.scenePhase) private var scenePhase

  private let viewContext = PersistenceContainer.shared.viewContext

  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView(userPreferences: store.userPreferences)
        .accentColor(Color("AccentColor"))
        .environment(\.managedObjectContext, viewContext)
        .environmentObject(store)
      }
    }
    .onChange(of: scenePhase) { phase in
      INPreferences.requestSiriAuthorization { _ in }
    }
  }
}
