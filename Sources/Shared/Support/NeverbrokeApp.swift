import SwiftUI
import WidgetKit
import Combine

@main
struct NeverbrokeApp: App {

  @StateObject var store = NeverbrokeStore()
  @Environment(\.scenePhase) private var scenePhase

  private let viewContext = PersistenceContainer.shared.viewContext

  var body: some Scene {
    WindowGroup {
      ContentView(userPreferences: store.userPreferences)
      .accentColor(Color("AccentColor"))
      .environment(\.managedObjectContext, viewContext)
      .environmentObject(store)
    }
  }
}
