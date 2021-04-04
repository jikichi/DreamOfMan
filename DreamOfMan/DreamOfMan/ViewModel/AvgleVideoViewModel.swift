//
//  AvgleVideoViewModel.swift
//  PokeData
//
//  Created by jikichi on 2021/04/02.
//

import Foundation
import RxSwift
import RxCocoa

class AvgleVideoViewModel {
    let video: Video
    var imageURL: Driver<String>
    var title: Driver<String>
    var previewURL: Driver<String>
    
    init(video: Video) {
        self.imageURL = .never()
        self.title = .never()
        
        self.video = video
        self.imageURL = .just(video.previewURL)
        self.title = .just(video.title)
        self.previewURL = .just(video.previewURL)
    }
}
