//
//  UIImageView+loadImageURL.swift
//  PokeData
//
//  Created by jikichi on 2021/04/02.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithURLStirng(urlString: String) {
        if urlString == "" {
            return
        }
        let url = URL(string: urlString)
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            print(" cache image.")
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                return
            }
            print(error)
            DispatchQueue.main.async {
                if let downloadImage: UIImage = UIImage(data: data!) {
                    imageCache.setObject(downloadImage as AnyObject, forKey: urlString as AnyObject)
                    self.image = downloadImage
                }
            }
        }).resume()
    }
}
