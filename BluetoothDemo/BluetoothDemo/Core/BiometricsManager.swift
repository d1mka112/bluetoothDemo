//
//  BiometricsManager.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 02.01.2023.
//

import Foundation
import LocalAuthentication

enum BiometricsManager {

    static func checkBiometrics(completion: @escaping (Bool, Error?)->Void) {
        let context = LAContext()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: Spec.Text.biometricReasonForUser
            ) { (success, error) in
                completion(success, error)
            }
        }
    }
}
