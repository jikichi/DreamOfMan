//
//  AvgleAPI.swift
//  PokeData
//
//  Created by jikichi on 2021/04/02.
//

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON
import Alamofire

struct Video: Hashable {
    let vid: String
    let title: String
    let videoURL: String
    let previewURL: String
}

extension Video: Decodable {
    
}

class AvgleAPI {
    
    
    private let disposeBag = DisposeBag()
    
    private func convertVideoFromJSON(res: DataResponse<Any, Alamofire.AFError>) -> [Video] {
        guard let data = res.value else { return [] }
        let json = JSON(data)
        return json["response"]["videos"].map { data -> Video in
            return Video.init(vid: data.1["vid"].stringValue, title: data.1["title"].stringValue, videoURL: data.1["video_url"].stringValue, previewURL: data.1["preview_url"].stringValue)
        }
    }

    func getAllVideos() -> Observable<[Video]> {
        let page = "0"
        let url = "https://api.avgle.com/v1/videos/\(page)"
        return RxAlamofire.request(.get, url)
            .responseJSON()
            .map { [weak self] res -> [Video] in
                guard let self = self else { return [] }
                return self.convertVideoFromJSON(res: res)
            }
    }
    
    func getSearchVideo(query: String, page: Int = 0) -> Observable<[Video]> {
        let url = "https://api.avgle.com/v1/search/\(query)/\(String(page))"
        return RxAlamofire.request(.get, url)
            .responseJSON()
            .map { [weak self] res -> [Video] in
                guard let self = self else { return [] }
                return self.convertVideoFromJSON(res: res)
            }
    }
    
    func getVideo(urlString: String) {
        RxAlamofire.request(.get, urlString)
            .responseJSON()
            .subscribe(onNext: { value in
                print(value)
            })
    }
}
