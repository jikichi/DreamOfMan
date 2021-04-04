//
//  AvgleWebViewModel.swift
//  PokeData
//
//  Created by jikichi on 2021/04/04.
//

import Foundation
import RxSwift

class AvgleWebViewModel {
    
    var url: Observable<URL>
    
    init(url: URL) {
        self.url = .never()
        
        self.url = .just(url)
    }
    
}
