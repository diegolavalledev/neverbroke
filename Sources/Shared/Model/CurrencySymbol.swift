enum CurrencySymbol: String, CaseIterable, Identifiable, Codable {

  var id: Self { self }

  case dollar = "$"
  case euro = "€"
  case bitcoin = "₿"

  /// Currency code (e.g. USD)
  var code: String {
    switch self {
    case .dollar:
      return "USD"
    case .euro:
      return "EUR"
    case .bitcoin:
      return "BTC"
    }
  }
}
