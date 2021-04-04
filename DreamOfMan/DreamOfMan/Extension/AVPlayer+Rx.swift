//
//  AVPlayer+Rx.swift
//  PokeData
//
//  Created by jikichi on 2021/04/02.
//

import Foundation
import RxSwift
import AVKit

extension Reactive where Base: AVPlayer {
    var status: Observable<AVPlayer.Status> {
        return observe(AVPlayer.Status.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
    }
}
