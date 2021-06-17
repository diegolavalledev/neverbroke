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
    #if os(macOS)
      WindowGroup {
        NavigationView {
          AllExpenses()
          .frame(minWidth: 200)
        }
        .navigationTitle("Expenses")
        .frame(minWidth: 400, minHeight: 400)
        .accentColor(Color("AccentColor"))
        .environment(\.managedObjectContext, viewContext)
        .environmentObject(store)
      }
      .handlesExternalEvents(matching: Set(arrayLiteral: WindowID.expenses.rawValue))
    #endif
  }
}
