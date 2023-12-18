import SwiftUI

struct PeripheralElementView: View {
  let name: String
  let uuid: String
  let rssi: Int
  let service: String
  
  var body: some View {
    var icon: UIImage? {
      switch labs(rssi) {
      case 0...40:
        return UIImage(named: "signal_strength_5")
      case 41...53:
        return UIImage(named: "signal_strength_4")
      case 54...65:
        return UIImage(named: "signal_strength_3")
      case 66...77:
        return UIImage(named: "signal_strength_2")
      case 77...89:
        return UIImage(named: "signal_strength_1")
      default:
        return UIImage(named: "signal_strength_0")
      }
    }
    
    var noSignal: Bool {
      rssi == 127
    }
    
    HStack(alignment: .center, spacing: 10) {
      VStack(alignment: .leading) {
        Image(uiImage: icon ?? UIImage())
        Text(noSignal ? "---" : "\(rssi)")
      }
      VStack(alignment: .leading) {
        HStack(alignment: .center, spacing: 10) {
          Text(name)
          Text(service)
        }
        Text(uuid)
          .font(.caption)
      }
      .foregroundColor(noSignal ? .gray : .black)
    }
  }
}

// MARK: - Preview

#Preview {
  PeripheralElementView(
    name: "Device name",
    uuid: "sfsd-sdfg-gfdf-dfgg",
    rssi: 12,
    service: "No services"
  )
}
