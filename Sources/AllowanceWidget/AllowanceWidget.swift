import WidgetKit
import SwiftUI
import Intents
import CoreData

struct Provider: IntentTimelineProvider {

  // TODO: On the main App struct this is required for iOS 14 (not for iOS 15), looks like on this provider it is not required. Confirm that there is no "purple" error before removing.
  // private let persistenceController = PersistenceController.shared

  func placeholder(in context: Context) -> AllowanceEntry {
    AllowanceEntry(
      date: Date(),
      currency: UserPreferences.default.currencySymbol,
      allowance: AllowanceAmount.default.amount,
      remaining: AllowanceAmount.default.amount,
      configuration: ConfigurationIntent(),
      isPlaceholder: true
    )
  }

  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AllowanceEntry) -> ()) {
    let entry = AllowanceEntry(
      date: Date(),
      currency: UserPreferences.default.currencySymbol,
      allowance: AllowanceAmount.default.amount,
      remaining: AllowanceAmount.default.amount,
      configuration: configuration
    )
    completion(entry)
  }

  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [AllowanceEntry] = []

    let currentDate = Date()
    let store = NeverbrokeStore()
    let currency = store.userPreferences.currencySymbol

    let viewContext = PersistenceContainer.shared.viewContext
    let allowancesRequest = NSFetchRequest<AllowanceAmount>(entityName: String(describing: AllowanceAmount.self))
    allowancesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)]
    let allowances = try! viewContext.fetch(allowancesRequest)

    let expensesRequest = NSFetchRequest<ExpenseItem>(entityName: String(describing: ExpenseItem.self))
    expensesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)]
    let expenses = try! viewContext.fetch(expensesRequest)

    let allowance = allowances.lastAmount
    let remaining = allowance - expenses.todaysOnly.total

    let entry = AllowanceEntry(
      date: currentDate,
      currency: currency,
      allowance: allowance,
      remaining: remaining,
      configuration: configuration
    )
    entries.append(entry)
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    let timeline = Timeline(entries: entries, policy: .after(tomorrow))
    completion(timeline)
  }
}

struct AllowanceEntry: TimelineEntry {
  var date: Date
  let currency: CurrencySymbol
  let allowance: Double
  let remaining: Double
  let configuration: ConfigurationIntent
  var isPlaceholder = false
}

struct AllowanceWidgetEntryView : View {

  var entry: Provider.Entry

  var allowance: Double {
    entry.allowance
  }

  var remainingValue: Double {
    entry.remaining
  }

  var secondaryBgColor: Color {
    #if os(macOS)
      Color(.textBackgroundColor)
    #else
      Color(.secondarySystemBackground)
    #endif
  }

  var widgetBody: some View {
    VStack {
      Spacer()
      Text("Allowance")
      Text(allowance.currencyFormat(symbol: entry.currency))
      .bold()
      Spacer()
      if entry.configuration.showRemaining?.boolValue ?? true {
        Text(remainingValue < 0 ? "Short" : "Remaining")
        Text(remainingValue.currencyFormat(symbol: entry.currency))
        .foregroundColor(remainingValue < 0 ? .red : .green)
        .bold()
        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal)
    .background(
      LinearGradient(
        gradient: Gradient(colors: [secondaryBgColor, Color.accentColor]),
        startPoint: .topLeading, endPoint: .bottomTrailing
      )
    )
    .edgesIgnoringSafeArea(.all)
    .accentColor(.orange)
  }

  var body: some View {
    if entry.isPlaceholder {
      widgetBody.redacted(reason: .placeholder)
    } else {
      widgetBody
    }
  }
}

@main
struct AllowanceWidget: Widget {
  let kind: String = "AllowanceWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      AllowanceWidgetEntryView(entry: entry)
      .accentColor(Color("AccentColor"))
    }
    .configurationDisplayName("Allowance Widget")
    .description("See your daily allowance and remaining amount.")
    .supportedFamilies([.systemSmall])
  }
}

struct AllowanceWidget_Previews: PreviewProvider {
  static let sampleEntry = AllowanceEntry(
    date: Date(),
    currency: UserPreferences.default.currencySymbol,
    allowance: AllowanceAmount.default.amount,
    remaining: AllowanceAmount.default.amount,
    configuration: ConfigurationIntent()
  )

  static var previews: some View {
    Group {
      AllowanceWidgetEntryView(entry: sampleEntry)
      .environment(\.colorScheme, .light)
      .previewDisplayName("Light mode")

      AllowanceWidgetEntryView(entry: sampleEntry)
      .environment(\.colorScheme, .dark)
      .previewDisplayName("Dark mode")
    }
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
