import Foundation
import CoreBluetooth

final class ServiceInfoViewModel: NSObject, ObservableObject, BluetoothDelegate {
  @Published var characteristicValue = String()
  
  private let bluetoothManager = BluetoothManager.getInstance()
  
  override init() {
    super.init()
    bluetoothManager.delegate = self
  }
  
  func readValue(_ characteristic: CBCharacteristic?) {
    guard let characteristic else { return }
    bluetoothManager.readValueForCharacteristic(characteristic: characteristic)
  }
  
  // MARK: - BluetoothDelegate
  
  func didReadValueForCharacteristic(_ characteristic: CBCharacteristic) {
    if let characteristicData = characteristic.value {
      let stringValue = String(decoding: characteristicData, as: UTF8.self)
      
      print("Value - \(characteristic.uuid) - \(stringValue)")
      characteristicValue = stringValue
    }
  }
  
  func didFailToReadValueForCharacteristic(_ error: Error) {
    characteristicValue = error.localizedDescription
  }
}
