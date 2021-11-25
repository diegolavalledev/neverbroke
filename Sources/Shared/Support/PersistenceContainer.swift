import CoreData
import Combine

class PersistenceContainer: NSPersistentCloudKitContainer {

  private static let name = "Neverbroke"
  private static let model =  NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "Neverbroke", withExtension: "momd")!)!

  static let shared = PersistenceContainer()
  static let mock = PersistenceContainer(inMemory: true)

  private let inMemory: Bool
  private var cancellable: Cancellable?

  init(inMemory: Bool = false) {
    self.inMemory = inMemory
    super.init(name: Self.name, managedObjectModel: Self.model)

    if inMemory {
      persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
    } else {

      let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.diegolavalle.Neverbroke2")!
      persistentStoreDescriptions[0].url = containerURL.appendingPathComponent("\(Self.name).sqlite")
      persistentStoreDescriptions[0].setOption(true as NSNumber, forKey: String(describing: NSPersistentStoreRemoteChangeNotificationPostOptionKey.self))
    }

    //
    // For us to be able to use async sequence this initializer and all functions calling it need to be async.
    //
    // Replace following line with:
    // `for await notification in NotificationCenter.default.notifications(named: .NSPersistentStoreRemoteChange, object: .none) { … }`
    //
    cancellable = NotificationCenter.default.publisher(for: .NSPersistentStoreRemoteChange, object:  persistentStoreCoordinator).sink { notification in
      precondition(notification.name == NSNotification.Name.NSPersistentStoreRemoteChange)
      NeverbrokeStore.updateComplications()
      NeverbrokeStore.updateWidgets()
    }

    loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      self.viewContext.automaticallyMergesChangesFromParent = true
      self.viewContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyStoreTrumpMergePolicyType)
      // container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
  }
}
