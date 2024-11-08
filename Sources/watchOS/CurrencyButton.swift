import SwiftUI

struct CurrencyButton: View {

  let userPreferences: UserPreferences
  @Environment(NeverbrokeStore.self) var store

  var body: some View {
    NavigationLink(destination: symbolForm) {
      VStack(alignment: .leading) {
        Text("Currency").bold()
        HStack {
          Text(userPreferences.currencySymbol.rawValue)
          Image(systemName: "pencil.circle.fill").foregroundColor(.accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top)
      }
    }
  }

  @ViewBuilder
  var symbolForm: some View {
    @Bindable var store = store
    CurrencyForm(userPreferences: $store.userPreferences)
  }
}

#Preview(traits: .sizeThatFitsLayout) {
  CurrencyButton(userPreferences: .default)
    .environment(NeverbrokeStore())
}
