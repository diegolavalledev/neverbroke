import Foundation

extension Date {

  private var calendar: Calendar { Calendar.current }

  var normalized: Date {
    var components = calendar.dateComponents([.year, .month, .day], from: self)
    components.timeZone = TimeZone(secondsFromGMT: 0)
    return calendar.date(from: components)!
  }

  var startOfMonth: Date {
    let month = calendar.dateComponents([.year, .month], from: normalized)
    return calendar.date(from: month)!.normalized
  }

  var mtdInclusive: DateInterval {
    let endDate = calendar.date(byAdding: .day, value: 1, to: normalized)!
    return DateInterval(start: startOfMonth, end: endDate)
  }

  var monthToDate: DateInterval {
    DateInterval(start: startOfMonth, end: normalized)
  }

  var month: DateInterval {
    // TODO: Check start date normalization
    calendar.dateInterval(of: .month, for: normalized)!
  }
}
