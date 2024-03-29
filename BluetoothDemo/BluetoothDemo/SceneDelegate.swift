//
//  SceneDelegate.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 13.12.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()

        LoggerHelper.warning("Приложение запущено\nВерсия: \(version!)")
        BluetoothManager.shared.setupManager()

        let rootViewController = (GlobalStorage.shared.token != nil) ? 
            MainViewController() : 
            AuthorizationController()

        let navigationController = UINavigationController(rootViewController: rootViewController)
//        window?.rootViewController = navigationController
        window?.rootViewController = NFCTestController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
//        guard Toggle.rescanWhenAppForeground.isActive else { return }
        LoggerHelper.warning("Приложение вышло из бекграунда")
//        BluetoothManager.shared.startScanningIfCan()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        guard Toggle.rescanWhenAppForeground.isActive else { return }
        LoggerHelper.warning("Приложение ушло в бекграунд")
//        BluetoothManager.shared.stopScanning()
    }
}
