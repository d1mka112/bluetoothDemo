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
    func didReceiveDevice(model: BluetoothTagModel)

    func didUpdateModels(models: [String: String])
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

    var maxTagModel: BluetoothTagModel = BluetoothTagModel(rssi: -200, name: nil)
    var models: [String: String] = [:]

    var manager: CBCentralManager?
    var delegate: BluetoothManagerDelegate?
    var canScanDevices: Bool = false

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
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        canScanDevices = central.state == .poweredOn
        LoggerHelper.info("\(central.state)")
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let model = BluetoothTagModel(
            rssi: RSSI.intValue,
            name: peripheral.identifier.description
        )

        maxTagModel = model.rssi > maxTagModel.rssi ? model : maxTagModel

        if RSSI.intValue > Spec.Constant.minimalRSSI {
            manager?.stopScan()
            FeedbackGenerator.success()
            delegate?.didReceiveDeviceWithRSSI(model: model)
            maxTagModel = BluetoothTagModel(rssi: -200, name: nil)
        } else {
            delegate?.didReceiveDevice(model: maxTagModel)
        }

        guard let name = model.name else { return }

        models[name] = model.description
        delegate?.didUpdateModels(models: models)
    }
}

