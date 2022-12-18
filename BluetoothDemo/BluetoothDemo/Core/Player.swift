//
//  Player.swift
//  BluetoothDemo
//
//  Created by Dmitry Leukhin on 18.12.2022.
//

import Foundation
import AVFoundation
import UIKit

final class Player {
    static let shared = Player()

    private var player: AVAudioPlayer?

    func playAudio(data: Data) {
        do {
            player = try AVAudioPlayer(data: data, fileTypeHint: "mp3")
            player?.play()
        } catch let error {
            LoggerHelper.warning(error.localizedDescription)
        }
    }
}

enum GlobalPlayer {
    static func paySuccess() {
        guard let asset = NSDataAsset(name: "paySuccess") else {
            LoggerHelper.warning("Невозможно найти данные")
            return
        }
        Player.shared.playAudio(data: asset.data)
    }
}
