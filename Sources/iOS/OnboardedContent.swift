import SwiftUI

struct OnboardedContent: View {

  let userPreferences: UserPreferences

  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \AllowanceAmount.timestamp_, ascending: true)],
    animation: .default)
  private var allowances: FetchedResults<AllowanceAmount>

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
          VStack {
            Text(userPreferences.greeting).font(.title)
            Text(currentDate)
          }
          HStack {
            AllowanceBox(userPreferences: userPreferences, allowances: Array(allowances))
            RemainingBox(userPreferences: userPreferences)
          }.padding()

          NewExpenseButton()

          GroupBox(label: Text("Today's expenses")) {
            VStack {
              TodaysExpenses()
            }
            NavigationLink("Show all expenses", destination: AllExpenses())
          }
          .padding()
        }
      }
      .navigationBarTitle("Dashboard")
      .navigationBarItems(trailing: UserPreferencesButton())
    }
  }

  var currentDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: Date())
  }
}

#Preview {
  OnboardedContent(userPreferences: .default)
    .environment(NeverbrokeStore())
}
