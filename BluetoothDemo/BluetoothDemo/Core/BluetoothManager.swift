//
//  BluetoothManager.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import Foundation
import CoreBluetooth

struct BluetoothTagModel {
    let rssi: Int
    let data: [String: Any]
    let name: String?
}

protocol BluetoothManagerDelegate {
    func didReceiveDeviceWithRSSI(model: BluetoothTagModel)
}

protocol BluetoothManagerProgotol {
    var manager: CBCentralManager? { get }
    var canScanDevices: Bool { get set }

    func setupManager()
    func startScanningIfCan()
    func setDelegate(delegate: BluetoothManagerDelegate)
}

@objc final class BluetoothManager: NSObject, BluetoothManagerProgotol {
    
    static let shared: BluetoothManagerProgotol = BluetoothManager()
    let minimalRSSI: Int = -40

    var manager: CBCentralManager?
    var canScanDevices: Bool = false
    var delegate: BluetoothManagerDelegate?

    func setupManager() {
        guard manager == nil else { return }
        self.manager = CBCentralManager(delegate: self, queue:nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

    func startScanningIfCan() {
        print("trying to start")
        guard canScanDevices else {
            print("ne poluchilos")
            return
        }
        print("poluhilos")
        manager?.scanForPeripherals(withServices: nil, options: nil)
    }

    func setDelegate(delegate: BluetoothManagerDelegate) {
        self.delegate = delegate
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Did update state \(central.state)")
        canScanDevices = central.state == .poweredOn
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber) {
            print("DID DISCOVER: NAME: \(peripheral.identifier.description) RSSI: \(RSSI.intValue)")
        if RSSI.intValue > minimalRSSI {
            manager?.stopScan()
            print("🟢🟢🟢🟢\nNAME: \(peripheral.identifier.description)\nRSSI: \(RSSI.intValue)\nDATA: \(advertisementData)")
            print("stop scan")
            delegate?.didReceiveDeviceWithRSSI(
                model:
                    BluetoothTagModel(
                        rssi: RSSI.intValue,
                        data: advertisementData,
                        name: peripheral.identifier.description
                    )
            )
        }
    }
}

