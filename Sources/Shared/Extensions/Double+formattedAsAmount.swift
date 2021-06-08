import Foundation

extension Double {
  func currencyFormat(symbol: CurrencySymbol? = nil) -> String {
    let prefix: String
    if let symbol = symbol {
      prefix = "\(symbol.rawValue) "
    } else {
      prefix = ""
    }
    return "\(prefix)\(Formatter.currency.string(for: self)!)"
  }
}
