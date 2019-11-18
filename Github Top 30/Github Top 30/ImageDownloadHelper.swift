//
//  ImageDownloadHelper.swift
//  Github Top 30
//
//  Created by Kiran Kumar on 17/11/19.
//  Copyright © 2019 Kiran Kumar. All rights reserved.
//

import Foundation
import UIKit

open class ImageDownloadHelper {
    
    let imageCache = NSCache<NSString, UIImage>()
    
    private static var sharedImageDownloadHelper: ImageDownloadHelper = {
        let imageDownloadHelper = ImageDownloadHelper()
        return imageDownloadHelper
    }()

    class func shared() -> ImageDownloadHelper {
        return sharedImageDownloadHelper
    }

    
    func loadImage(imageURL: String, indexPath: IndexPath?, completionHandler: @escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        var imageName = imageURL
        if let ip = indexPath {
            imageName.append("_\(ip.section)_\(ip.row)")
        }

        if let image = getImage(name: imageName) {
            completionHandler(image, nil)
            return
        }
        
        NetworkHelper.shared().fetchImage(imgageURL: imageURL) { (image, error) in
            guard let downloadedImage = image else {
                completionHandler(nil, error)
                return
            }
            self.saveToCache(image: downloadedImage, imageName: imageName)
            completionHandler(downloadedImage, error)
        }
    }
    
    private func saveToCache(image: UIImage, imageName: String) {
        imageCache.setObject(image, forKey: imageName as NSString)
    }
    
    private func getImage(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}

extension NetworkHelper {
    
    func fetchImage(imgageURL: String, completionHandler: @escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        let url = URL(string: imgageURL)
        performGetRequest(url) { (responseData, responseCode, error) in
            guard let data = responseData else {
                completionHandler(nil, error)
                return
            }
            guard let image = UIImage(data: data) else {
                completionHandler(nil, error)
                return
            }
            completionHandler(image, error)
        }
    }
    
}
