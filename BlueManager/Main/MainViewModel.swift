import Foundation
import CoreBluetooth

final class MainViewModel: NSObject, ObservableObject, BluetoothDelegate {
  @Published var statusText = String()
  @Published var nearbyPeripheralInfos = [PeripheralInfo]()
  @Published var services = [CBService]()
  @Published var refer: Int = 0
  
  private let bluetoothManager = BluetoothManager.getInstance()
  
  override init() {
    super.init()
    bluetoothManager.delegate = self
  }
  
  // MARK: - Actions
  
  func sort() {
    nearbyPeripheralInfos.sort(by: { labs($0.RSSI) < labs($1.RSSI) })
  }
  
  func startScan() {
    bluetoothManager.startScanPeripheral()
  }
  
  func stopScan() {
    bluetoothManager.stopScanPeripheral()
  }
  
  func connect(peripheral: CBPeripheral) {
    services = []
    bluetoothManager.connectPeripheral(peripheral)
  }
  
  func disconnect() {
    services = []
    bluetoothManager.disconnectPeripheral()
  }
  
  // MARK: - BluetoothDelegate
  
  func didDiscoverPeripheral(_ peripheral: CBPeripheral, advertisementData: [String : Any], RSSI: NSNumber) {
    let peripheralInfo = PeripheralInfo(peripheral)
    if !nearbyPeripheralInfos.contains(peripheralInfo) {
      peripheralInfo.name = peripheral.name ?? "No name"
      peripheralInfo.RSSI = RSSI.intValue
      peripheralInfo.advertisementData = advertisementData
      nearbyPeripheralInfos.append(peripheralInfo)
      print("Peripheral - \(peripheral)")
    } else {
      guard let index = nearbyPeripheralInfos.firstIndex(of: peripheralInfo) else {
        return
      }
      let originPeripheralInfo = nearbyPeripheralInfos[index]
      let nowTimeInterval = Date().timeIntervalSince1970
      guard nowTimeInterval - originPeripheralInfo.lastUpdatedTimeInterval >= 1.0 else {
        return
      }
      originPeripheralInfo.lastUpdatedTimeInterval = nowTimeInterval
      originPeripheralInfo.RSSI = RSSI.intValue
      originPeripheralInfo.advertisementData = advertisementData
      refer = RSSI.intValue
    }
  }
  
  func didUpdateState(_ state: CBManagerState) {
    switch state {
    case .resetting:
      statusText = "Resetting"
    case .poweredOn:
      statusText = "Powered On"
    case .poweredOff:
      statusText = "Powered Off"
    case .unauthorized:
      statusText = "Powered Off"
    case .unknown:
      statusText = "Unknown"
    case .unsupported:
      statusText = "Unsupported"
      bluetoothManager.stopScanPeripheral()
      bluetoothManager.disconnectPeripheral()
    @unknown default:
      print("State: Unsupported")
    }
  }
  
  func didConnectedPeripheral(_ connectedPeripheral: CBPeripheral) {
    //      connectingView?.tipLbl.text = "Interrogating..."
  }
  func didFailedToInterrogate(_ peripheral: CBPeripheral) {
    //      ConnectingView.hideConnectingView()
    //      AlertUtil.showCancelAlert("Connection Alert", message: "The perapheral disconnected while being interrogated.", cancelTitle: "Dismiss", viewController: self)
  }
  
  func didDiscoverServices(_ peripheral: CBPeripheral) {
    guard let services = peripheral.services else { return }
    self.services = services
    for service in services {
      print("Service - \(service)")
      bluetoothManager.discoverCharacteristics()
    }
  }
  
  func didDiscoverCharacteritics(_ service: CBService) {
    guard let characteristics = service.characteristics else { return }
    for characteristic in characteristics {
      print("Characteristic - \(characteristic)")
    }
  }
}
