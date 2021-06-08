import SwiftUI

struct AmountStepper: View {

  @Binding var amount: Double

  var body: some View {
    VStack(spacing: 8) {
      HStack {
        Image(systemName: "plus.circle").font(.body).foregroundColor(nil)
        Text("10").onTapGesture {
          amount += 10
        }
        Spacer()
        Text("1").onTapGesture {
          amount += 1
        }
        Spacer()
        Text(".10").onTapGesture {
          amount += 0.1
        }
        Spacer()
        Text(".01").onTapGesture {
          amount += 0.01
        }
      }
      Divider()
      HStack {
        Image(systemName: "minus.circle").font(.body).foregroundColor(nil)
        Text("10").bold().onTapGesture {
          amount -= 10
        }
        Spacer()
        Text("1").bold().onTapGesture {
          amount -= 1
        }
        Spacer()
        Text(".10").bold().onTapGesture {
          amount -= 0.1
        }
        Spacer()
        Text(".01").onTapGesture {
          amount -= 0.01
        }
      }
    }
    .foregroundColor(.accentColor)
    .font(.body.bold())
  }
}

struct AmountStepper_Previews: PreviewProvider {
  static var previews: some View {
    AmountStepper(amount: .constant(29.99))
  }
}
