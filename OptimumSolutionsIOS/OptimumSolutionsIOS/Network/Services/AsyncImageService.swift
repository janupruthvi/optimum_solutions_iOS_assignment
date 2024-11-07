//
//  AsynImageService.swift
//  OptimumSolutionsIOS
//
//  Created by Pruthvi Nithyanandan on 2024-11-07.
//

import Foundation
import UIKit

class AsyncImageService {
    
    static let shared = AsyncImageService()
    
    private init(){}
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    func loadImageFromURL(imageUrl: String,
                          completion: @escaping (UIImage) -> Void) {
        
        let url = URL(string: imageUrl)
        
        guard let url = url else {
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: imageUrl as NSString) {
            completion(imageFromCache)
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: {
            [weak self] (data, response, error) in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    guard let cachedImage = UIImage(data: data) else {
                        return
                    }
                    
                    self?.imageCache.setObject(cachedImage, forKey: imageUrl as NSString)
                    
                    completion(cachedImage)
                }
            }
            
        }).resume()
    }
}
