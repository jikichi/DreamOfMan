//
//  PlayerView.swift
//  PokeData
//
//  Created by jikichi on 2021/04/02.
//

import Foundation
import UIKit.UIView
import AVKit

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
