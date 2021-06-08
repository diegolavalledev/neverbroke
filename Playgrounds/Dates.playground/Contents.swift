import Foundation

let rightNow = Date()
let another = ISO8601DateFormatter().date(from: "2020-03-13T14:29:52Z")
//Int16.max
let cal = Calendar.current
let utc = TimeZone(abbreviation: "UTC")!
utc.abbreviation()
utc.identifier
utc.secondsFromGMT()
utc.daylightSavingTimeOffset()

let currentTZ = cal.timeZone
currentTZ.abbreviation()
currentTZ.identifier
currentTZ.secondsFromGMT()
currentTZ.daylightSavingTimeOffset()

var utcCal = Calendar(identifier: Calendar.current.identifier)
utcCal.timeZone = utc

cal.dateComponents([.timeZone], from: rightNow).timeZone == cal.timeZone // true

cal.dateComponents(in: utc, from: rightNow).timeZone ==
  utcCal.dateComponents([.timeZone], from: rightNow).timeZone // true

cal.dateComponents([.timeZone], from: rightNow).timeZone
cal.dateComponents([.hour], from: rightNow).hour
utcCal.dateComponents([.hour], from: rightNow).hour

let formatter = DateFormatter()
formatter.dateStyle = .medium
formatter.timeStyle = .long
formatter.string(from: rightNow)

let formatterUtc = DateFormatter()
formatterUtc.dateStyle = .medium
formatterUtc.timeStyle = .long
formatterUtc.timeZone = utc

// Reset seconds and transport to UTC keeping the same hour
var components = cal.dateComponents([.day, .month, .year, .hour, .minute], from: rightNow)
components.timeZone = utc
let normalized = cal.date(from: components)!
formatterUtc.string(from: normalized)

