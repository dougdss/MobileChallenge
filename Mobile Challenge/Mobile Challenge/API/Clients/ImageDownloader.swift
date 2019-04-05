//
//  ImageDownloader.swift
//  Mobile Challenge
//
//  Created by Douglas da Silva Santos on 05/04/19.
//  Copyright © 2019 Douglas da Silva Santos. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

protocol ImageDownloaderProtocol {
    func downloadImage(from url: String, completion: @escaping (UIImage?, Error?) -> Void)
}

class ImageDownloader: ImageDownloaderProtocol {
    
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func downloadImage(from url: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let imageURL = URL(string: url) else {
            let error = NSError(domain: "challenge.imagedownloader.error", code: 997, userInfo: [NSLocalizedDescriptionKey: "could not create URL from string:\(url)"])
            completion(nil, error)
            return
        }
        
        let stringObject = NSString(string: url)
        
        //check cache for image
        if let cachedImage = imageCache.object(forKey: stringObject) as? UIImage {
            completion(cachedImage, nil)
            return
        }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let imageData = data else {
                completion(nil, error)
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                let error = NSError(domain: "challenge.imagedownloader.error", code: 996, userInfo: [NSLocalizedDescriptionKey: "could not generate image from imageData"])
                completion(nil, error)
                return
            }
            
            imageCache.setObject(image, forKey: stringObject)
            completion(image, nil)
        }.resume()
    }
}
