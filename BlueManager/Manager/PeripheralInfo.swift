import Foundation
import CoreBluetooth

final class PeripheralInfo: Equatable, Hashable {
  var name: String = ""
  let peripheral: CBPeripheral
  var RSSI: Int = 0
  var advertisementData: [String: Any] = [:]
  var lastUpdatedTimeInterval: TimeInterval
  
  init(_ peripheral: CBPeripheral) {
    self.peripheral = peripheral
    self.lastUpdatedTimeInterval = Date().timeIntervalSince1970
  }
  
  static func == (lhs: PeripheralInfo, rhs: PeripheralInfo) -> Bool {
    return lhs.peripheral.isEqual(rhs.peripheral)
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(0)
  }
}
