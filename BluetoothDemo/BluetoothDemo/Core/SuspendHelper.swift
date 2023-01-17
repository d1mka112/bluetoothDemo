//
//  SuspendHelper.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 17.01.2023.
//

import UIKit

enum SuspendHelper {
    static func suspend(after time: CGFloat = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            UIControl().sendAction(
                #selector(NSXPCConnection.suspend),
                to: UIApplication.shared, for: nil
            )
        }
    }
}
