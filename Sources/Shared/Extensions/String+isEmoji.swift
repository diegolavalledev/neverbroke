extension String {
  var isEmoji: Bool {
    guard count == 1 else {
      return false
    }
    return unicodeScalars.reduce(true) {
      $0 && $1.properties.isEmoji
    }
  }
}
