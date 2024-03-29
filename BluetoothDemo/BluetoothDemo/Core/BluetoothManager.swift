//
//  BluetoothManager.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import Foundation
import CoreBluetooth

protocol BluetoothManagerDelegate {
    func didStartScanning()
    func didStopScanning()
    func didReceiveDeviceWithRSSI(model: BluetoothTagModel)
    func didUpdateModels(models: [BluetoothTagModel])
}

protocol BluetoothManagerProgotol {
    func setupManager()
    func setDelegate(delegate: BluetoothManagerDelegate)
    func setNeedsToStartScanning()
    func startScanningIfCan()
    func stopScanning()
}

@objc final class BluetoothManager: NSObject, BluetoothManagerProgotol {
    static let shared: BluetoothManagerProgotol = BluetoothManager()

    private let queue: DispatchQueue = DispatchQueue(label: "com.bluetoothManager", attributes: .concurrent)

    private var manager: CBCentralManager?
    private var delegate: BluetoothManagerDelegate?
    private var canScanDevices: Bool = false {
        didSet {
            if canScanDevices && isNeedsToStartScanning {
//                startScanningIfCan()
                isNeedsToStartScanning = false
            }
        }
    }
    private var isNeedsToStartScanning: Bool = false

    @Atomic private var models: [String: BluetoothTagModel] = [:] {
        didSet {
            delegate?.didUpdateModels(models: models.map(\.value))
        }
    }

    @Atomic private var peripherals: [String: CBPeripheral] = [:] {
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

    func setNeedsToStartScanning() {
        isNeedsToStartScanning = true
    }

    func startScanningIfCan() {
        guard canScanDevices else {
            LoggerHelper.warning("Сканирование не началось")
            return
        }
        stopScanning()
        LoggerStorage.shared.clear()
        manager?.scanForPeripherals(withServices: nil, options: nil)
        delegate?.didStartScanning()
        FeedbackGenerator.prepare()
        LoggerHelper.info("Начинаем сканирование")
    }

    func stopScanning() {
        peripherals.values.forEach {
            manager?.cancelPeripheralConnection($0)
        }
        peripherals.removeAll()
        manager?.stopScan()
        delegate?.didStopScanning()
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
//        LoggerHelper.info("Прочитан RSSI:\(RSSI.intValue) - \(peripheral.identifier.description)")

        guard let peripheral = peripherals[peripheral.identifier.description] else { return }

        let model = BluetoothTagModel(rssi: RSSI.intValue, name: peripheral.identifier.description, deviceName: peripheral.name)
        models[peripheral.identifier.description] = model

        var isBluetoothDevice = true
        if !Toggle.shouldScanAppleDevices.isActive,
           let name = model.deviceName {
            isBluetoothDevice = 
                !name.lowercased().contains("watch") &&
                !name.lowercased().contains("airpods")
        }

        if model.rssi >= GlobalStorage.shared.minimalRSSI,
           isBluetoothDevice {
            stopScanning()
            LoggerHelper.success("Найден подходящий peripheral \(peripheral.description)\nRSSI:\(RSSI.intValue)")
            delegate?.didReceiveDeviceWithRSSI(model: model)
        } else {
            queue.async {
                peripheral.readRSSI()
            }
        }
    }
}
