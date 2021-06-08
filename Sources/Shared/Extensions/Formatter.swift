import Foundation

extension Formatter {

  static var infoDateFormatter: some Formatter {
    let df = DateFormatter()
    df.dateStyle = .short
    df.timeStyle = .short
    return df
  }

  static var currency: some Formatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    return formatter
  }

  static var currencySmall: some Formatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none
    formatter.minimumFractionDigits = 0
    return formatter
  }
}
