import Foundation

extension ExpenseItem {

  static let emptyCategory = "(empty)"
  static let emptyEmoji = "💸"
  static let emptyMemo = "(empty description)"

  var amount: Double {
    get { amount_.inCurrency }
    set { amount_ = newValue.inCents }
  }

  var category: String? {
    get { category_ }
    set {
      guard let newValue = newValue else {
        category_ = .none
        return
      }
      let trimmed = newValue.trimmingCharacters(in: .whitespaces)
      category_ = trimmed.isEmpty ? .none : trimmed
    }
  }

  var day: Date {
    get { day_! }
    set { day_ = newValue.normalized }
  }

  var memo: String? {
    get { memo_ }
    set {
      guard let newValue = newValue else {
        memo_ = .none
        return
      }
      let trimmed = newValue.trimmingCharacters(in: .whitespaces)
      memo_ = trimmed.isEmpty ? .none : trimmed
    }
  }

  var emoji: String? {
    get { emoji_ }
    set {
      guard let newValue = newValue else {
        memo_ = .none
        return
      }
      let trimmed = newValue.trimmingCharacters(in: .whitespaces)
      memo_ = trimmed.isEmpty || !trimmed.isEmoji ? .none : trimmed
    }
  }

  var timestamp: Date {
    get { timestamp_! }
    set { timestamp_ = newValue }
  }

  var timezoneId: String {
    get { timezoneId_! }
    set { timezoneId_ = newValue }
  }

  var timezoneSeconds: Int {
    get { Int(timezoneSeconds_) }
    set { timezoneSeconds_ = Int32(newValue) }
  }
}

extension Sequence where Element == ExpenseItem {
//  static var mock: Self {
//    [.mock1, .mock2, .mock3]
//  }

  var todaysOnly: [ExpenseItem] {
    filter {
      Date().normalized == $0.day
    }
  }

  var total: Double {
    reduce(0) {
      $0 + $1.amount
    }
  }

  func mtdTotal(_ forDate: Date) -> Double {
    total(for: forDate.monthToDate)
  }

  func total(for interval: DateInterval) -> Double {
    // TODO: Normalize interval!
    let total = filter {
      interval.contains($0.day)
    }
    .reduce(0) {
      $0 + $1.amount
    }
    return total
  }

  func dayTotal(_ forDate: Date) -> Double {
    let cal = Calendar.current
    let year = cal.component(.year, from: forDate)
    let month = cal.component(.month, from: forDate)
    let day = cal.component(.day, from: forDate)

    let total = filter { item in
      let itemYear = cal.component(.year, from: item.day)
      let itemMonth = cal.component(.month, from: item.day)
      let itemDay = cal.component(.day, from: item.day)
      return itemYear == year && itemMonth == month && itemDay == day
    }
    .reduce(0) {
      $0 + $1.amount
    }
    return total
  }
}
