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

    private func playAudio(data: Data) {
        do {
            player = try AVAudioPlayer(data: data, fileTypeHint: "mp3")
            player?.play()
        } catch let error {
            LoggerHelper.warning(error.localizedDescription)
        }
    }

    func playAudio(name: String) {
        guard let asset = NSDataAsset(name: name) else {
            LoggerHelper.warning("Невозможно найти данные \(name)")
            return
        }
        playAudio(data: asset.data)
    }
}

enum GlobalPlayer {
    static func paySuccess() {
        Player.shared.playAudio(name: Spec.Sound.paySuccess)
    }
}
