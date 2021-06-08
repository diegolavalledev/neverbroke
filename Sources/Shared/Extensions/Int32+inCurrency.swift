import Foundation

extension Int32 {
  var inCurrency: Double {
    Double(self) / 100
  }
}
