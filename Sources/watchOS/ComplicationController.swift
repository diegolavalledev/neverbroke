import ClockKit
import CoreData

class ComplicationController: NSObject, CLKComplicationDataSource {
  
  // MARK: - Complication Configuration
  
  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let descriptors = [
      CLKComplicationDescriptor(
        identifier: "complication", displayName: "Allowance",
        supportedFamilies:
          // CLKComplicationFamily.allCases
          [
            .modularSmall,
            .circularSmall,
            .graphicCircular
          ]
      )
      // Multiple complication support can be added here with more descriptors
    ]
    
    // Call the handler with the currently supported complication descriptors
    handler(descriptors)
  }
  
  func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
    // Do any necessary work to support these newly shared complication descriptors
  }
  
  // MARK: - Timeline Configuration
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
    handler(nil)
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    // Call the handler with your desired behavior when the device is locked
    handler(.showOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry

    let store = NeverbrokeStore()
    let currency = store.userPreferences.currencySymbol.rawValue

    let viewContext = PersistenceContainer.shared.viewContext
    let allowancesRequest = NSFetchRequest<AllowanceAmount>(entityName: String(describing: AllowanceAmount.self))
    allowancesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)]
    let allowances = try! viewContext.fetch(allowancesRequest)

    let expensesRequest = NSFetchRequest<ExpenseItem>(entityName: String(describing: ExpenseItem.self))
    expensesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseItem.timestamp_, ascending: false)]
    let expenses = try! viewContext.fetch(expensesRequest)

    let allowance = allowances.lastAmount
    let remaining = allowance - expenses.todaysOnly.total
    let remainingRounded = remaining.rounded()
    
    let currencyText = CLKSimpleTextProvider(text: "\(currency)")
    let remainingText = CLKSimpleTextProvider(text: Formatter.currencySmall.string(for: remainingRounded)!)

    let template: CLKComplicationTemplate?
    switch complication.family {
    case .modularSmall:
      template = CLKComplicationTemplateModularSmallStackText(
        line1TextProvider: currencyText,
        line2TextProvider: remainingText
      )
    case .circularSmall:
      template = CLKComplicationTemplateCircularSmallStackText(
        line1TextProvider: currencyText,
        line2TextProvider: remainingText
      )
    case .graphicCircular:
      template = CLKComplicationTemplateGraphicCircularStackText(
        line1TextProvider: currencyText,
        line2TextProvider: remainingText
        )
    default:
      //preconditionFailure("Complication family not supported")
      template = nil
    }
    if let template = template {
      handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))
    } else {
      handler(nil)
    }
  }
  
  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after the given date
    handler(nil)
  }
  
  // MARK: - Sample Templates
  
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    switch complication.family {
    case .modularSmall:
      let template = CLKComplicationTemplateModularSmallStackText(
        line1TextProvider: CLKSimpleTextProvider(text: "REM"),
        line2TextProvider: CLKSimpleTextProvider(text: "100.00")
      )
      handler(template)
      
    case .circularSmall:
      let template = CLKComplicationTemplateCircularSmallStackText(
        line1TextProvider: CLKSimpleTextProvider(text: "RM"),
        line2TextProvider: CLKSimpleTextProvider(text: "200")
      )
      handler(template)
    case .graphicCircular:
      handler(
        CLKComplicationTemplateGraphicCircularStackText(
          line1TextProvider: CLKSimpleTextProvider(text: "REM"),
          line2TextProvider: CLKSimpleTextProvider(text: "300")
        )
      )
    default:
      //preconditionFailure("Complication family not supported")
      print("Complication fam \(complication.family)")
      handler(nil)
    }
  }
}
