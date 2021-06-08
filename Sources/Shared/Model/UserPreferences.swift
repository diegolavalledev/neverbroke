import Foundation

struct UserPreferences: Equatable, Codable {

  static let `default` = UserPreferences(userName: "", currencySymbol: .dollar)

  var userName: String
  var currencySymbol: CurrencySymbol

  var greeting: String {
    userName.isEmpty ? "Hello." : "Hello, \(userName)."
  }
}
