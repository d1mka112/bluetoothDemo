//
//  BluetoothManager.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import Foundation
import CoreBluetooth

protocol BluetoothManagerDelegate {
    func didReceiveDeviceWithRSSI(model: BluetoothTagModel)

    func didUpdateModels(models: [BluetoothTagModel])
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

    private let queue: DispatchQueue = DispatchQueue(label: "com.bluetoothManager", attributes: .concurrent)
    @Atomic var models: [String: BluetoothTagModel] = [:] {
        didSet {
            delegate?.didUpdateModels(models: models.map(\.value))
        }
    }

    @Atomic var peripherals: [String: CBPeripheral] = [:] {
        didSet {
            let subtract = Set(peripherals.keys).subtracting(Set(models.keys))
            subtract.forEach {
                models[$0] = BluetoothTagModel(rssi: -200, name: $0, deviceName: nil)
            }
            let remove = Set(models.keys).subtracting(Set(peripherals.keys))
            remove.forEach {
                models[$0] = nil
            }
        }
    }

    var manager: CBCentralManager?
    var delegate: BluetoothManagerDelegate?
    var canScanDevices: Bool = false
    var isStartingScan: Bool = false

    func setupManager() {
        guard manager == nil else { return }
        self.manager = CBCentralManager(
            delegate: self,
            queue:nil,
            options: [CBCentralManagerOptionShowPowerAlertKey: true] // Позволяет открывать алерт для получения доступа
        )
        LoggerHelper.info("Bluetooth manager настроен")
    }

    func setDelegate(delegate: BluetoothManagerDelegate) {
        self.delegate = delegate
    }

    func startScanningIfCan() {
        guard canScanDevices else {
            LoggerHelper.warning("Сканирование не началось")
            return
        }
        manager?.scanForPeripherals(withServices: nil, options: nil)
        FeedbackGenerator.prepare()
        LoggerHelper.info("Начинаем сканирование")
    }

    func stopScanning() {
        peripherals.values.forEach {
            manager?.cancelPeripheralConnection($0)
        }
        peripherals.removeAll()
        manager?.stopScan()
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        canScanDevices = central.state == .poweredOn
        LoggerHelper.info("State \(central.state.rawValue == 5)")
    }

    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        guard peripherals[peripheral.identifier.description] == nil else {
            return
        }
        peripherals[peripheral.identifier.description] = peripheral

        central.connect(peripheral, options: nil)
        LoggerHelper.warning("Получен новый peripheral \(peripheral.identifier.description)")
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        LoggerHelper.success("Подключен peripheral \(peripheral.identifier.description)")
        peripheral.delegate = self
        peripheral.readRSSI()
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        LoggerHelper.error("Отключен peripheral \(peripheral.identifier.description)")
        peripherals[peripheral.identifier.description] = nil
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        LoggerHelper.info("Прочитан RSSI:\(RSSI.intValue) - \(peripheral.identifier.description)")

        guard let peripheral = peripherals[peripheral.identifier.description] else { return }

        let model = BluetoothTagModel(rssi: RSSI.intValue, name: peripheral.identifier.description, deviceName: peripheral.name)
        models[peripheral.identifier.description] = model

        if model.rssi > Spec.Constant.minimalRSSI {
            FeedbackGenerator.success()
            GlobalPlayer.paySuccess()
            stopScanning()
            delegate?.didReceiveDeviceWithRSSI(model: model)
            LoggerHelper.success("Найден подходящий peripheral \(peripheral.description)\nRSSI:\(RSSI.intValue)")
        } else {
            queue.async {
                peripheral.readRSSI()
            }
        }
    }
}
