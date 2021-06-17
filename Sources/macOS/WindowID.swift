import Foundation

enum WindowID: String {
  case main, expenses

  var url: URL {
    URL(string: "nbint://\(rawValue)")!
  }
}
