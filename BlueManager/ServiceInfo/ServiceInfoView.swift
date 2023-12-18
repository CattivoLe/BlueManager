import SwiftUI
import CoreBluetooth

struct ServiceInfoView: View {
  let service: CBService?
  let characteristics: [CBCharacteristic]
  
  @StateObject private var viewModel = ServiceInfoViewModel()
  
  var body: some View {
    VStack(spacing: 10) {
      if let service {
        Text("\(service.uuid)")
      }
      
      Text(viewModel.characteristicValue)
      
      Divider()
      
      List(characteristics, id: \.self) { characteristic in
        VStack(alignment: .leading, spacing: 10) {
          Text(characteristic.description)
          Button("Read value", action: {
            viewModel.readValue(characteristic)
          })
        }
      }
    }
  }
}

// MARK: - Preview

#Preview {
  ServiceInfoView(
    service: nil,
    characteristics: []
  )
}
