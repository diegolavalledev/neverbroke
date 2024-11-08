import SwiftUI

struct ContentView: View {

  let userPreferences: UserPreferences

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)],
    animation: .default)
  private var allowances: FetchedResults<AllowanceAmount>

  var body: some View {
    Group {
      if allowances.isEmpty {
        AllowanceForm(isPresented: .constant(true), allowances: Array(allowances))
      } else {
        OnboardedContent(userPreferences: userPreferences)
      }
    }
    .modifier(WelcomeMessage())
  }
}

#Preview {
  ContentView(userPreferences: .default)
    .environment(NeverbrokeStore())
}
