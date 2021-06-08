import Intents

class IntentHandler: INExtension {
  override func handler(for intent: INIntent) -> Any {
    switch intent {
      case is AllowanceIntent:
        return AllowanceIntentHandler()
      default:
        return self
    }
  }
}
