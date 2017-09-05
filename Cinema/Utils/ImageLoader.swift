//
//  ImageLoader.swift
//  Cinema
//
//  Created by Thu Trang on 9/5/17.
//  Copyright © 2017 ThuTrangT5. All rights reserved.
//

import UIKit
import Foundation

class ImageLoader {
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    func clearCache(forKey key: String) {
        self.cache.removeObject(forKey: key as AnyObject)
    }
    
    func imageForUrl(urlString: String, completionHandler:@escaping (_ image: UIImage?,_ url: String) -> ()) {
        
        if urlString.contains("http") == false {
            completionHandler(nil, urlString)
            return
        }
        
        DispatchQueue.global().async(execute: {
            let data: Data? = self.cache.object(forKey: urlString as AnyObject) as? Data
            
            if let goodData = data {
                let image = UIImage(data: goodData)
                DispatchQueue.main.async(execute: {() in
                    completionHandler(image, urlString)
                })
                return
            }
            
            let url = URL(string: urlString)!
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil || data == nil {
                    completionHandler(nil, urlString)
                    return
                }
                self.cache.setObject(data! as AnyObject, forKey: urlString as AnyObject)
                
                let image = UIImage(data: data!)
                DispatchQueue.main.async(execute: {() in
                    completionHandler(image, urlString)
                })
                return
            }).resume()
        })
    }
}

class UIImageViewLoader: UIImageView {
    var imageUrl: String = ""
    
    func loadPosterImage(name: String) {
        
        let url = APIManagement.shared.getPosterUrl(byName: name)
        
        self.imageUrl = url
        self.image = nil
        
        ImageLoader.sharedLoader.imageForUrl(urlString: url, completionHandler: { (image, responseUrl) in
            if responseUrl == self.imageUrl {
                self.image = image
            }
        })
    }
}
