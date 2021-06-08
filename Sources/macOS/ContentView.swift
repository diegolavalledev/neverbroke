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
        allowanceEnteredBody
      }
    }
    .modifier(WelcomeMessage())
  }

  var allowanceEnteredBody: some View {
    ScrollView {
      VStack {
        UserPreferencesButton()
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
    .frame(width: 400)
  }

  var currentDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: Date())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(userPreferences: .default)
    .environmentObject(NeverbrokeStore())
  }
}
