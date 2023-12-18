import SwiftUI
import CoreBluetooth

final class PeripheralViewModel: NSObject, ObservableObject, BluetoothDelegate {
  @Published var services = [CBService]()
  
  private let bluetoothManager = BluetoothManager.getInstance()
  
  let peripheral: CBPeripheral
  
  init(peripheral: CBPeripheral) {
    self.peripheral = peripheral
    super.init()
    bluetoothManager.delegate = self
  }
  
  // MARK: - Actions
  
  func connect() {
    bluetoothManager.connectPeripheral(peripheral)
  }
  
  func disconnect() {
    bluetoothManager.disconnectPeripheral()
  }
  
  // MARK: - BluetoothDelegate
  
  func didDiscoverServices(_ peripheral: CBPeripheral) {
    guard let services = peripheral.services else { return }
    self.services = services
    for service in services {
      print("Service - \(service)")
      bluetoothManager.discoverCharacteristics()
    }
  }
}
