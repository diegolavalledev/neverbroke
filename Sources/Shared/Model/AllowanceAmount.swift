import Foundation

extension AllowanceAmount {

  static let suggestedValue = 20.0

  static let `default`: AllowanceAmount = {
    let allowance = AllowanceAmount(context: PersistenceContainer.mock.viewContext)
    allowance.amount = 20
    allowance.day = Date()
    return allowance
  }()

  var amount: Double {
    get { amount_.inCurrency }
    set { amount_ = newValue.inCents }
  }

  var day: Date {
    get { day_! }
    set { day_ = newValue.normalized }
  }

  var timestamp: Date {
    get { timestamp_! }
    set { timestamp_ = newValue }
  }
}

extension Sequence where Element == AllowanceAmount {

  static var `default`: [AllowanceAmount] {
    [.default]
  }

  /// The amount of the last allowance in the sequence. The Sequence must be pre-sorted for this value to be meaningful.
  var lastAmount: Double {
    Array(self).last?.amount ?? 0
  }

  /// The allowance for a specific day
  func dayAmount(_ date: Date) -> Double {
    guard let allowance = allowance(for: date) else {
      return 0
    }
    return allowance.amount
  }

  /// The allowance amount that is closest to the day
  func allowance(for date: Date) -> AllowanceAmount? {
    // We will search for either the closest to our date (but earlier than it) and also the earliest date as backup
    let initial = (closest: AllowanceAmount?.none, earliest: AllowanceAmount?.none)

    let result = reduce(initial) {
      // Update the earliest
      let newEarliest: AllowanceAmount?
      if let earliest = $0.earliest {
        newEarliest = $1.day < earliest.day ? $1 : earliest
      } else {
        newEarliest = $1
      }
      // Update the closest
      let newClosest: AllowanceAmount?
      if $1.day <= date.normalized {
        if let closest = $0.closest {
          newClosest = $1.day > closest.day ? $1 : closest
        } else {
          newClosest = $1
        }
      } else {
        // We keep the previous closest (or nil)
        newClosest = $0.closest
      }
      // Return best results so far
      return (closest: newClosest, earliest: newEarliest)
    }

    if let closest = result.closest {
      // The closest to our date but no later than it
      return closest
    }
    // The actual earliest date or nil if there aren't any
    return result.earliest
  }

  // TODO: Revisit and add support for earliest allowance when the interval begins (and maybe ends) before the first amount's date
  /// Requires ascending order
  func amount(for interval: DateInterval) -> Double {
    // TODO: Assert ascending order

    let startDate = interval.start.normalized
    let endDate = interval.end.normalized

    let result = self.reduce((0, nil)) { (previousResult: (Double, AllowanceAmount?), currentAllowance) in
      let (accumValue, maybePreviousAllowance) = previousResult
      guard currentAllowance.day <= endDate else {
        return previousResult
      }
      guard currentAllowance.day >= startDate, let previousAllowance = maybePreviousAllowance else {
        return (accumValue, currentAllowance)
      }
      let countingFrom = previousAllowance.day <= startDate
        ? startDate
        : previousAllowance.day

      let days = Calendar.current.dateComponents([.day], from: countingFrom, to: currentAllowance.day).day!
      let valueIncrement = Double(days) * previousAllowance.amount
      return (accumValue + valueIncrement, currentAllowance)
    }
    
    let (accumValue, maybePreviousAllowance) = result
    guard let previousAllowance = maybePreviousAllowance else {
      return accumValue
    }
    let countingFrom = previousAllowance.day <= startDate
      ? startDate
      : previousAllowance.day
    let days = Calendar.current.dateComponents([.day], from: countingFrom, to: endDate).day!
    let valueIncrement = Double(days) * previousAllowance.amount

    return accumValue + valueIncrement
  }
}
