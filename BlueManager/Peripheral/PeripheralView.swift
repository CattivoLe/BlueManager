import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
  let name: String
  let uuid: String
  let status: CBPeripheralState
  let services: [CBService]
  
  var onConnect: () -> Void
  var onDisconnect: () -> Void
  
  var body: some View {
    var statusColor: Color {
      switch status {
      case .disconnected, .disconnecting:
        return .red
      case .connecting:
        return .yellow
      case .connected:
        return .green
      @unknown default:
        return .gray
      }
    }
    
    var statusText: String {
      switch status {
      case .disconnected:
        return "Disconnected"
      case .disconnecting:
        return "Disconnecting"
      case .connecting:
        return "Connecting"
      case .connected:
        return "Connected"
      @unknown default:
        return "Unknown"
      }
    }
    
    VStack(alignment: .leading) {
      Text(name)
        .font(.title)
        .padding(.horizontal)
      
      Text(uuid)
        .font(.subheadline)
        .padding(.horizontal)
      
      Text(statusText)
        .font(.title3)
        .foregroundColor(statusColor)
        .padding(.horizontal)
      
      if !services.isEmpty {
        List(services, id: \.self) { service in
          NavigationLink {
            ServiceInfoView(
              service: service,
              characteristics: service.characteristics ?? []
            )
          } label: {
            VStack(alignment: .leading) {
              HStack {
                var color: Color {
                  if let chars = service.characteristics, !chars.isEmpty {
                    return .green
                  } else {
                    return .red
                  }
                }
                Image(systemName: "bolt.horizontal.fill")
                  .foregroundColor(color)
                
                Text("Available: \(service.characteristics?.count ?? 0)")
              }
              Text(service.description)
            }
          }
          .disabled(service.characteristics?.isEmpty ?? false)
        }
        .listStyle(.plain)
      }
    }
    
    Spacer()
    
    HStack {
      Button("Connect", action: { onConnect() })
      Spacer()
      Button("Disconnect", action: { onDisconnect() })
    }
    .padding(.horizontal, 50)
    .padding(.vertical, 10)
  }
}

// MARK: - Preview

#Preview {
  PeripheralView(
    name: "JBL Speaker",
    uuid: "sdeg-gfdvs-vcbn-ege4-g23f2f-f2dsfv",
    status: .disconnected,
    services: [],
    onConnect: {},
    onDisconnect: {}
  )
}
