import SwiftUI

struct CurrencyButton: View {

  let userPreferences: UserPreferences
  @EnvironmentObject var store: NeverbrokeStore

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

  var symbolForm: some View {
    CurrencyForm(userPreferences: $store.userPreferences)
  }
}

struct CurrencyButton_Previews: PreviewProvider {
  static var previews: some View {
    CurrencyButton(userPreferences: .default, store: EnvironmentObject<NeverbrokeStore>())
    .previewLayout(.sizeThatFits)
  }
}
