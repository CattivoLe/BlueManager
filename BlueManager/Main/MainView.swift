import SwiftUI

struct MainView: View {
  @StateObject private var viewModel = MainViewModel()
  
  var body: some View {
    NavigationView {
      VStack {
        List(viewModel.nearbyPeripheralInfos, id: \.self) { peripheralInfo in
          var servicesCount: String {
            if let serviceUUIDs = peripheralInfo.advertisementData["kCBAdvDataServiceUUIDs"] as? NSArray, serviceUUIDs.count != 0 {
              return "\(serviceUUIDs.count) service" + (serviceUUIDs.count > 1 ? "s" : "")
            } else {
              return "No services"
            }
          }
          
          NavigationLink {
            PeripheralView(
              name: peripheralInfo.name,
              uuid: peripheralInfo.peripheral.identifier.uuidString,
              status: peripheralInfo.peripheral.state,
              services: viewModel.services,
              onConnect: { viewModel.connect(peripheral: peripheralInfo.peripheral) },
              onDisconnect: { viewModel.disconnect() }
            )
          } label: {
            PeripheralElementView(
              name: peripheralInfo.name,
              uuid: peripheralInfo.peripheral.identifier.uuidString,
              rssi: peripheralInfo.RSSI,
              service: servicesCount
            )
          }
        }
        
        HStack {
          Button("Start scan", action: { viewModel.startScan() })
          Spacer()
          Button("Stop scan", action: { viewModel.stopScan() })
        }
        .padding(.horizontal, 50)
        .padding(.vertical, 10)
      }
      .navigationTitle(viewModel.statusText)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(
            action: { viewModel.sort() },
            label: {
              Text("Sort")
            }
          )
          .disabled(viewModel.nearbyPeripheralInfos.isEmpty)
        }
      }
    }
  }
}

// MARK: - Preview

#Preview {
  MainView()
}
