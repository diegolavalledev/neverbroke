import Combine
import Foundation

#if os(watchOS)
  import ClockKit
#else
  import WidgetKit
#endif

class NeverbrokeStore: ObservableObject {

  static let suite = UserDefaults(suiteName: "group.com.diegolavalle.Neverbroke2")!

  enum Key: String {
    case userPreferences
  }

  var cancellable: Cancellable?

  /// Sync'd with custom User Defaults and iCloud Key-Value Storage
  @Published var userPreferences: UserPreferences = {
    let key = Key.userPreferences.rawValue
    if let json = NeverbrokeStore.suite.string(forKey: key) {
      return try! JSONDecoder().decode(UserPreferences.self, from: json.data(using: .utf8)!)
    } else {
      let newValue = UserPreferences.default
      let data = try! JSONEncoder().encode(newValue)
      let json = String(data: data, encoding: .utf8)!

      NeverbrokeStore.suite.setValue(json, forKey: key)

      #if os(iOS) || os(macOS)
        NSUbiquitousKeyValueStore.default.set(json, forKey: key)  // iCloud Key-Value Storage
      #endif

      updateComplications()
      updateWidgets()
      return newValue
    }
  }() {
    didSet {
      let key = Key.userPreferences.rawValue
      let jsonData = try! JSONEncoder().encode(userPreferences)
      let json = String(data: jsonData, encoding: .utf8)!

      NeverbrokeStore.suite.setValue(json, forKey: key)

      #if os(iOS) || os(macOS)
        NSUbiquitousKeyValueStore.default.set(json, forKey: key)  // iCloud Key-Value Storage
      #endif

      Self.updateComplications()
      Self.updateWidgets()
    }
  }

  init() {

    #if !os(watchOS)
      if NSUbiquitousKeyValueStore.default.synchronize() == false {
        fatalError("This app was not built with the proper entitlement requests.")
      }

      cancellable = NotificationCenter.default.publisher(for: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default).sink { notification in

        let key = Key.userPreferences.rawValue

        guard let userInfo = notification.userInfo else { return }
        guard let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }
        guard let keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else { return }
        guard keys.contains(key) else { return }

        if reasonForChange == NSUbiquitousKeyValueStoreAccountChange {
          self.userPreferences = self.userPreferences
        } else if let json = NSUbiquitousKeyValueStore.default.string(forKey: key) {
          self.userPreferences = try! JSONDecoder().decode(UserPreferences.self, from: json.data(using: .utf8)!)
        }
      }
    #endif
  }

  static func updateComplications() {
    #if os(watchOS)
      let server = CLKComplicationServer.sharedInstance()
      server.activeComplications?.forEach {
        server.reloadTimeline(for: $0)
      }
    #endif
  }

  static func updateWidgets() {
    #if os(iOS) || os(macOS)
      WidgetCenter.shared.reloadAllTimelines()
    #endif
  }
}
